# Practical 07: Supervised Classification of Suspicious URL Patterns Using Lexical Features

**Aim:** Extract lexical features from URLs and train a classifier to tell
suspicious (phishing-like) URLs from benign ones.

**Dataset:** `datasets/urls_synthetic.csv` (from `datasets.zip` in this
folder) — 800 rows, columns `url,label` (`label=1` suspicious, `0` benign).

---

## 1. Setup

```bash
cd ~/pentest-lab
unzip -o "/home/adu/Documents/MScCS/Part 2/Sem III/SA&CM/Practicals/datasets.zip" -d .
pip install --break-system-packages pandas scikit-learn matplotlib
```

---

## 2. One script: features → train → evaluate

**`~/pentest-lab/url_classifier.py`**
```python
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, ConfusionMatrixDisplay
import matplotlib.pyplot as plt

WORDS = ["login", "secure", "account", "update", "verify", "support"]

def features(url):
    host = url.split("/")[2] if "//" in url else url
    return pd.Series({
        "length": len(url),
        "dots": url.count("."),
        "digits": sum(c.isdigit() for c in url),
        "has_ip_host": host.replace(".", "").isdigit(),
        "is_https": url.startswith("https"),
        "has_suspicious_word": any(w in url.lower() for w in WORDS),
    })

df = pd.read_csv("datasets/urls_synthetic.csv")
X = df["url"].apply(features)
y = df["label"]

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, random_state=42)

model = RandomForestClassifier(random_state=42).fit(X_train, y_train)

print(classification_report(y_test, model.predict(X_test)))
print(pd.Series(model.feature_importances_, index=X.columns).sort_values(ascending=False))

ConfusionMatrixDisplay.from_estimator(model, X_test, y_test)
plt.savefig("confusion_matrix.png", bbox_inches="tight")
```

```bash
python3 url_classifier.py
```

---

## 3. Reading the output

- **Classification report**: precision/recall/F1 per class — recall on
  class `1` (suspicious) matters most here, since a missed phishing URL is
  worse than a false alarm.
- **Feature importances**: ranks which lexical signals actually drove the
  model's decisions — expect `has_ip_host` and `has_suspicious_word` near
  the top, since those are classic phishing tells (raw IP instead of a
  domain, action/urgency keywords like "verify" or "login").
- **`confusion_matrix.png`**: how many benign/suspicious URLs were
  correctly vs incorrectly classified, at a glance.

---

## 4. What to put in your lab report

1. The classification report.
2. `confusion_matrix.png`.
3. The feature-importance ranking, with one sentence per top-3 feature
   explaining *why* it's a plausible phishing signal.
4. **Limitation**: this model only sees the URL string — it has no page
   content, domain age, or certificate/reputation data, and an attacker can
   adapt URLs to evade a purely lexical model. Note this as the key
   caveat for any real deployment.
