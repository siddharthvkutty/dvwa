# Practical 05: Analysis of Social Engineering and Credential-Harvesting Simulation Using SET

**Aim:** To simulate a credential-harvesting social-engineering attack using
the Social-Engineer Toolkit (SET), by cloning a login page and capturing
credentials submitted to it, in a controlled local environment.

**Environment:** Kali Linux, native tools only (`setoolkit` ships in the
Kali repos). The "victim" is your own browser on the same machine, pointed
at the SET listener on `127.0.0.1`/your own LAN IP — no real site's login
page is cloned and hosted for anyone outside your control to reach.

---

## 1. Build a target page to clone

Rather than cloning a real third-party site (which SET also supports, but
which you should not point at anyone besides yourself), host a small local
login page to clone — this keeps the whole exercise self-contained.

```bash
sudo apt install -y python3-flask
mkdir -p ~/pentest-lab/set-target && cd ~/pentest-lab/set-target
```

**`target.py`**
```python
from flask import Flask
app = Flask(__name__)

@app.route("/")
def login():
    return """
    <h2>Corporate Portal Login</h2>
    <form method="POST" action="/login">
      <input name="username" placeholder="username"><br>
      <input name="password" type="password" placeholder="password"><br>
      <button type="submit">Sign in</button>
    </form>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
```

```bash
python3 target.py
```

This is the page SET will clone — pretend it's a real corporate SSO page for
the purposes of the exercise.

---

## 2. Launch SET

```bash
sudo apt install -y set
sudo setoolkit
```

Navigate the menu:

```
1) Social-Engineering Attacks
    2) Website Attack Vectors
        3) Credential Harvester Attack Method
            2) Site Cloner
```

When prompted:
- **IP address for POST back**: your machine's own IP (`ip addr show`,
  e.g. `127.0.0.1` or your LAN IP) — this is where harvested creds are sent.
- **URL to clone**: `http://127.0.0.1:8080`

SET stands up a listener on port 80 serving a byte-for-byte clone of the
login form.

---

## 3. Simulate the victim

From the same machine (or another host on your LAN, both of which you
control), open a browser and go to the attacker's listener:

```
http://<kali-ip>/
```

Enter any dummy credentials and submit, e.g. `testuser` / `Password123!`.

The page will redirect to the real cloned site after submission (SET's
default behavior) — the victim sees a normal-looking login and nothing
visibly wrong happens.

---

## 4. Review harvested credentials

Back in the `setoolkit` terminal, SET prints each submitted field live, and
also logs it to disk:

```bash
sudo find / -iname "harvester*" 2>/dev/null
cat /root/.set/reports/<timestamp>/harvester_*.txt
```

You should see the exact `username`/`password` values submitted, with a
timestamp.

---

## 5. What to put in your lab report

1. Screenshot of the SET menu path used (Website Attack Vectors → Credential
   Harvester → Site Cloner) and the clone/listener setup prompts.
2. Screenshot of the cloned login page as seen by the "victim" browser,
   next to the original for comparison.
3. Screenshot/log excerpt of the harvested credentials captured by SET.
4. **Analysis**: what made the clone convincing (or not) — URL bar (no real
   domain/padlock to check against), visual fidelity, absence of MFA. Tie
   back to why this is a *social engineering* attack rather than a technical
   exploit — the vulnerability being abused is user trust/inattention, not a
   software bug.
5. **Mitigations**: browser anti-phishing warnings, email/link filtering
   before the page is ever reached, MFA (credential theft alone becomes
   insufficient), user awareness training, and organizational use of
   phishing-resistant auth (FIDO2/WebAuthn) where the login flow itself
   can't be replayed from a cloned page.
