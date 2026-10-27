# Practical 02: Network Traffic Capture and Protocol Analysis Using Wireshark

**Aim:** To capture live network traffic on a local interface and analyze
the captured packets to understand protocol behavior (ARP, DNS, TCP/HTTP)
using Wireshark.

**Environment:** Kali Linux, native tools only (`wireshark`/`tshark` ship in
the Kali repos). All traffic captured is your own machine's traffic on its
own interface.

---

## 1. Setup

```bash
sudo apt update
sudo apt install -y wireshark tshark
sudo usermod -aG wireshark $USER   # allows non-root capture; re-login after
ip link show                        # identify your interface, e.g. eth0/wlan0
```

---

## 2. Start a capture

GUI:
```bash
wireshark
```
Select your interface (e.g. `eth0`) and click the shark-fin **Start**
button.

CLI equivalent, useful for scripted/headless capture:
```bash
sudo tshark -i eth0 -w ~/capture.pcapng
```

---

## 3. Generate traffic to analyze

In a separate terminal, while the capture is running:

```bash
# ARP: force a fresh ARP resolution
ip neigh flush all
ping -c 2 <your-default-gateway-ip>

# DNS
dig example.com
nslookup example.com

# HTTP (cleartext, easy to inspect in full)
curl -v http://neverssl.com/

# HTTPS (encrypted — good for comparing what is/isn't visible)
curl -v https://example.com/

# A full 3-way handshake + teardown, isolated
curl -v http://example.com/ -o /dev/null
```

Stop the capture (red square / Ctrl-C) once you have a few seconds of each.

---

## 4. Protocol analysis in Wireshark

Apply each filter and inspect the matching packets:

| Filter | What to look at |
|---|---|
| `arp` | Who-has / is-at pairs; note source/destination MAC vs IP |
| `dns` | Query vs response, QTYPE (A/AAAA), TTL in the answer |
| `tcp.flags.syn==1 and tcp.flags.ack==0` | The SYN that opens a handshake |
| `tcp.flags.syn==1 and tcp.flags.ack==1` | The SYN-ACK reply |
| `tcp.flags.fin==1` | Connection teardown |
| `http` | Full cleartext request/response headers and body |
| `tls.handshake.type==1` | TLS ClientHello (SNI field shows the hostname *even over HTTPS*) |

For the HTTP capture: right-click a packet → **Follow → HTTP Stream** to see
the full reconstructed request/response in one view — this is the clearest
single artifact to put in the report, since it shows headers, cookies (if
any), and body all together in plaintext.

For the TCP handshake: **Statistics → Flow Graph** gives a clean
SYN/SYN-ACK/ACK timeline diagram to screenshot.

---

## 5. Protocol statistics

```
Statistics → Protocol Hierarchy     — breakdown of traffic by protocol/%
Statistics → Conversations          — per-host/per-port traffic volumes
Statistics → IO Graph               — throughput over the capture window
```

---

## 6. What to put in your lab report

1. Screenshot of the Protocol Hierarchy statistics for your capture.
2. ARP request/reply pair, with MAC/IP mapping noted.
3. DNS query + response pair, with the resolved IP and TTL.
4. TCP handshake Flow Graph (SYN → SYN-ACK → ACK) and the FIN teardown.
5. The followed HTTP stream (cleartext credentials/data visible) *next to*
   the TLS ClientHello from the HTTPS run (showing only the SNI hostname is
   visible, not the request/response body) — use this side-by-side as the
   core evidence for the **HTTP vs HTTPS confidentiality** discussion.
6. **Analysis**: explain, protocol by protocol, what information an
   on-path observer gains from each (ARP reveals L2↔L3 mapping, DNS reveals
   intended destinations even before a connection opens, unencrypted HTTP
   leaks full content, HTTPS leaks only metadata such as SNI and packet
   sizes/timing).
