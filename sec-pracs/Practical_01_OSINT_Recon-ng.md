# Practical 01: OSINT-Based Network Reconnaissance and Information Gathering Using Recon-ng

**Aim:** Performing Passive Reconnaissance and Open-Source Intelligence (OSINT)
Gathering on a target domain using the `recon-ng` framework, and generating a
consolidated HTML Reconnaissance report of the observations.

**Environment:** Kali Linux, native tools only (`recon-ng` ships in the Kali
repos). All reconnaissance here is **passive** — it only queries public
registries/APIs (WHOIS, certificate transparency logs, search engines) about
a target domain; it never sends traffic to the target's own servers.

---

## 1. Setup

```bash
sudo apt update
sudo apt install -y recon-ng
recon-ng --version
```

Create a workspace per target so modules, results, and the final report stay
isolated and reproducible:

```bash
recon-ng
```
```
[recon-ng][default] > workspaces create security-breaches
[recon-ng][security-breaches] > workspaces list
```

---

## 2. Seed the workspace with target domains

```
[recon-ng][security-breaches] > db insert domains
domain (TEXT): example.com
notes (TEXT):
[recon-ng][security-breaches] > show domains
```

> Use a domain you're authorized to research. Public WHOIS/OSINT lookups on
> well-known company domains are standard and legal (that's the point of
> "open-source" intelligence), but keep it to recording what's already
> public — don't pivot into active scanning of that company's live hosts
> without separate authorization.

---

## 3. Install and run OSINT modules

```
[recon-ng][security-breaches] > marketplace search whois
[recon-ng][security-breaches] > marketplace install recon/domains-contacts/whois_pocs
[recon-ng][security-breaches] > modules load recon/domains-contacts/whois_pocs
[recon-ng][security-breaches][whois_pocs] > options set SOURCE example.com
[recon-ng][security-breaches][whois_pocs] > run
[recon-ng][security-breaches][whois_pocs] > show contacts
```

Host / subdomain enumeration from public sources:

```
[recon-ng][security-breaches] > modules search host
[recon-ng][security-breaches] > marketplace install recon/domains-hosts/hackertarget
[recon-ng][security-breaches] > modules load recon/domains-hosts/hackertarget
[recon-ng][security-breaches][hackertarget] > options set SOURCE example.com
[recon-ng][security-breaches][hackertarget] > run
[recon-ng][security-breaches][hackertarget] > show hosts
```

Cross-platform username/profile check on a contact discovered above (e.g. a
WHOIS registrant name):

```
[recon-ng][security-breaches] > marketplace install recon/profiles-profiles/namechk
[recon-ng][security-breaches] > modules load recon/profiles-profiles/namechk
[recon-ng][security-breaches][namechk] > options set SOURCE "<name from show contacts>"
[recon-ng][security-breaches][namechk] > run
[recon-ng][security-breaches][namechk] > show profiles
```

Broader profile discovery with the `profiler` module — checks the same name
against a large catalog of sites/forums/communities (not just the handful
`namechk` covers), building out the `profiles` table further:

```
[recon-ng][security-breaches] > back
[recon-ng][security-breaches] > marketplace install recon/profiles-profiles/profiler
[recon-ng][security-breaches] > modules load recon/profiles-profiles/profiler
[recon-ng][security-breaches][profiler] > options set SOURCE "<name from show contacts>"
[recon-ng][security-breaches][profiler] > run
[recon-ng][security-breaches][profiler] > show profiles
```

Expect verbose output, one `[*] Checking: <site>` line per site in its
catalog, with any confirmed hits added to `profiles`.

---

## 4. Review the consolidated findings

```
[recon-ng][security-breaches] > show domains
[recon-ng][security-breaches] > show hosts
[recon-ng][security-breaches] > show contacts
[recon-ng][security-breaches] > show profiles
[recon-ng][security-breaches] > dashboard
```

---

## 5. Generate the consolidated HTML report

```
[recon-ng][security-breaches] > marketplace install reporting/html
[recon-ng][security-breaches] > modules load reporting/html
[recon-ng][security-breaches][html] > options set CREATOR "<your name>"
[recon-ng][security-breaches][html] > options set CUSTOMER "<target org>"
[recon-ng][security-breaches][html] > options set FILENAME ~/recon-ng-report.html
[recon-ng][security-breaches][html] > run
```

Open the result:

```bash
xdg-open ~/recon-ng-report.html
```

This HTML file is the deliverable for the practical — it consolidates every
domain, host, contact, and profile found across the modules you ran into one
report.

---

## 6. What to put in your lab report

1. Screenshots of each module's `run` output (`whois_pocs`, `hackertarget`,
   `namechk`, `profiler`).
2. `show domains` / `show hosts` / `show contacts` / `show profiles` tables.
3. The generated `recon-ng-report.html`, exported as PDF or screenshotted.
4. **Analysis**: for each data point found, note *which public source* it
   came from (WHOIS registry, CT logs, search-engine cache, etc.) and why
   that source is considered "open" / legally accessible.
5. **Discussion**: how an attacker could chain this passive recon (contacts,
   subdomains, usernames) into a targeted phishing or password-spray attempt
   — and what an organization can do to reduce its OSINT footprint (WHOIS
   privacy, subdomain hygiene, limiting staff info on public profiles).
