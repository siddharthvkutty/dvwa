# Blockchain Technology – Practicals 1–15

_Exam Notes_

## Practical 1 – Simple Blockchain (Addition, Prime, Krishnamurthy)

**Aim:** Build a simple blockchain whose blocks store (a) the sum of two numbers, (b) whether a number is prime, (c) whether a number is a Krishnamurthy number (sum of factorials of the digits = the number).

**To run:** Python: save each program under the name shown (e.g. add.py) and run: python add.py. JavaScript: needs Node.js. For each question save both files in one folder, the class file (e.g. add.js) and the test file (e.g. test_add.js), then run only the test file: node test_add.js (it loads the class file with require).

### Q1. Addition

**Python – add.py**

```python
import hashlib, time

class Block:
    def __init__(self, index, data, prev_hash=""):
        self.index = index
        self.timestamp = int(time.time() * 1000)
        self.data = data
        self.prev_hash = prev_hash
        text = f"{index}{self.timestamp}{data}{prev_hash}"
        self.hash = hashlib.sha256(text.encode()).hexdigest()

class Blockchain:
    def __init__(self):
        self.chain = [Block(0, "Genesis")]

    def add(self, data):
        self.chain.append(Block(len(self.chain), data, self.chain[-1].hash))

    def display(self):
        for b in self.chain:
            print("Block:", b.index)
            print("Data:", b.data)
            print("Hash:", b.hash)
            print("Previous Hash:", b.prev_hash)
            print()

    def addition(self, a, b):
        self.add({"num1": a, "num2": b, "sum": a + b})

bc = Blockchain()
bc.addition(24, 12)
bc.addition(6, 7)
bc.display()
```

**JavaScript – add.js**

```javascript
const crypto = require("crypto");

class Block {
    constructor(index, data, prevHash = "") {
        this.index = index;
        this.timestamp = Date.now();
        this.data = data;
        this.prevHash = prevHash;
        const text = `${index}${this.timestamp}${JSON.stringify(data)}${prevHash}`;
        this.hash = crypto.createHash("sha256").update(text).digest("hex");
    }
}

class Blockchain {
    constructor() {
        this.chain = [new Block(0, "Genesis")];
    }

    add(data) {
        const prev = this.chain[this.chain.length - 1];
        this.chain.push(new Block(this.chain.length, data, prev.hash));
    }

    display() {
        for (const b of this.chain) {
            console.log("Block:", b.index);
            console.log("Data:", b.data);
            console.log("Hash:", b.hash);
            console.log("Previous Hash:", b.prevHash);
            console.log();
        }
    }

    addition(a, b) {
        this.add({ num1: a, num2: b, sum: a + b });
    }
}

module.exports = Blockchain;
```

**JavaScript – test_add.js (run this)**

```javascript
const Blockchain = require("./add");

const bc = new Blockchain();
bc.addition(24, 12);
bc.addition(6, 7);
bc.display();
```

### Q2. Prime

**Python – prime.py**

```python
import hashlib, time

class Block:
    def __init__(self, index, data, prev_hash=""):
        self.index = index
        self.timestamp = int(time.time() * 1000)
        self.data = data
        self.prev_hash = prev_hash
        text = f"{index}{self.timestamp}{data}{prev_hash}"
        self.hash = hashlib.sha256(text.encode()).hexdigest()

class Blockchain:
    def __init__(self):
        self.chain = [Block(0, "Genesis")]

    def add(self, data):
        self.chain.append(Block(len(self.chain), data, self.chain[-1].hash))

    def display(self):
        for b in self.chain:
            print("Block:", b.index)
            print("Data:", b.data)
            print("Hash:", b.hash)
            print("Previous Hash:", b.prev_hash)
            print()

    def check_prime(self, n):
        prime = n > 1 and all(n % i for i in range(2, int(n ** 0.5) + 1))
        self.add({"number": n, "prime": prime})

bc = Blockchain()
bc.check_prime(6)
bc.check_prime(7)
bc.check_prime(11)
bc.display()
```

**JavaScript – prime.js**

```javascript
const crypto = require("crypto");

class Block {
    constructor(index, data, prevHash = "") {
        this.index = index;
        this.timestamp = Date.now();
        this.data = data;
        this.prevHash = prevHash;
        const text = `${index}${this.timestamp}${JSON.stringify(data)}${prevHash}`;
        this.hash = crypto.createHash("sha256").update(text).digest("hex");
    }
}

class Blockchain {
    constructor() {
        this.chain = [new Block(0, "Genesis")];
    }

    add(data) {
        const prev = this.chain[this.chain.length - 1];
        this.chain.push(new Block(this.chain.length, data, prev.hash));
    }

    display() {
        for (const b of this.chain) {
            console.log("Block:", b.index);
            console.log("Data:", b.data);
            console.log("Hash:", b.hash);
            console.log("Previous Hash:", b.prevHash);
            console.log();
        }
    }

    checkPrime(n) {
        let prime = n > 1;
        for (let i = 2; i * i <= n; i++) if (n % i === 0) prime = false;
        this.add({ number: n, prime });
    }
}

module.exports = Blockchain;
```

**JavaScript – test_prime.js (run this)**

```javascript
const Blockchain = require("./prime");

const bc = new Blockchain();
bc.checkPrime(6);
bc.checkPrime(7);
bc.checkPrime(11);
bc.display();
```

### Q3. Krishnamurthy

**Python – km.py**

```python
import hashlib, time, math

class Block:
    def __init__(self, index, data, prev_hash=""):
        self.index = index
        self.timestamp = int(time.time() * 1000)
        self.data = data
        self.prev_hash = prev_hash
        text = f"{index}{self.timestamp}{data}{prev_hash}"
        self.hash = hashlib.sha256(text.encode()).hexdigest()

class Blockchain:
    def __init__(self):
        self.chain = [Block(0, "Genesis")]

    def add(self, data):
        self.chain.append(Block(len(self.chain), data, self.chain[-1].hash))

    def display(self):
        for b in self.chain:
            print("Block:", b.index)
            print("Data:", b.data)
            print("Hash:", b.hash)
            print("Previous Hash:", b.prev_hash)
            print()

    def check_krishnamurthy(self, n):
        total = sum(math.factorial(int(d)) for d in str(n))
        self.add({"number": n, "krishnamurthy": total == n})

bc = Blockchain()
bc.check_krishnamurthy(145)
bc.check_krishnamurthy(12)
bc.check_krishnamurthy(40585)
bc.display()
```

**JavaScript – km.js**

```javascript
const crypto = require("crypto");

class Block {
    constructor(index, data, prevHash = "") {
        this.index = index;
        this.timestamp = Date.now();
        this.data = data;
        this.prevHash = prevHash;
        const text = `${index}${this.timestamp}${JSON.stringify(data)}${prevHash}`;
        this.hash = crypto.createHash("sha256").update(text).digest("hex");
    }
}

class Blockchain {
    constructor() {
        this.chain = [new Block(0, "Genesis")];
    }

    add(data) {
        const prev = this.chain[this.chain.length - 1];
        this.chain.push(new Block(this.chain.length, data, prev.hash));
    }

    display() {
        for (const b of this.chain) {
            console.log("Block:", b.index);
            console.log("Data:", b.data);
            console.log("Hash:", b.hash);
            console.log("Previous Hash:", b.prevHash);
            console.log();
        }
    }

    checkKrishnamurthy(n) {
        const fact = (k) => (k <= 1 ? 1 : k * fact(k - 1));
        const total = String(n)
            .split("")
            .reduce((s, d) => s + fact(Number(d)), 0);
        this.add({ number: n, krishnamurthy: total === n });
    }
}

module.exports = Blockchain;
```

**JavaScript – test_km.js (run this)**

```javascript
const Blockchain = require("./km");

const bc = new Blockchain();
bc.checkKrishnamurthy(145);
bc.checkKrishnamurthy(12);
bc.checkKrishnamurthy(40585);
bc.display();
```

**Output** Sample output of add.py / test_add.js (hash values change on every run; each Previous Hash equals the Hash of the block before it; hashes shortened here):

```text
Block: 0
Data: Genesis
Hash: bd79…
Previous Hash:

Block: 1
Data: {'num1': 24, 'num2': 12, 'sum': 36}
Hash: 0275…
Previous Hash: bd79…

Block: 2
Data: {'num1': 6, 'num2': 7, 'sum': 13}
Hash: a91c…
Previous Hash: 0275…

(JavaScript prints the data as { num1: 24, num2: 12, sum: 36 })

prime: 6, 7, 11        → prime: false, true, true
km:    145, 12, 40585  → krishnamurthy: true, false, true
```

## Practical 2 – Armstrong, Happy and Kaprekar Numbers using Blockchain

**Aim:** Store the result of a number check inside each block: (Q1) Armstrong number, (Q2) Happy number, (Q3) Kaprekar number.

**To run:** Same as Practical 1: Python – python arm.py; JavaScript – keep arm.js and test_arm.js in one folder and run node test_arm.js. Each program has the same Block and Blockchain classes; the numbers to check are passed by the calls at the bottom of the program / test file.

### Q1. Armstrong (only Armstrong numbers are added to the chain)

**Python – arm.py**

```python
import hashlib, time

class Block:
    def __init__(self, index, data, prev_hash=""):
        self.index = index
        self.timestamp = int(time.time() * 1000)
        self.data = data
        self.prev_hash = prev_hash
        text = f"{index}{self.timestamp}{data}{prev_hash}"
        self.hash = hashlib.sha256(text.encode()).hexdigest()

class Blockchain:
    def __init__(self):
        self.chain = [Block(0, "Genesis")]

    def add(self, data):
        self.chain.append(Block(len(self.chain), data, self.chain[-1].hash))

    def display(self):
        for b in self.chain:
            print("Block:", b.index)
            print("Data:", b.data)
            print("Hash:", b.hash)
            print("Previous Hash:", b.prev_hash)
            print()

    def check_armstrong(self, n):
        power = len(str(n))
        if sum(int(d) ** power for d in str(n)) == n:    # only Armstrong numbers are added
            self.add({"number": n, "armstrong": True})

bc = Blockchain()
bc.check_armstrong(24)
bc.check_armstrong(123)
bc.check_armstrong(153)
bc.check_armstrong(407)
bc.display()
```

**JavaScript – arm.js**

```javascript
const crypto = require("crypto");

class Block {
    constructor(index, data, prevHash = "") {
        this.index = index;
        this.timestamp = Date.now();
        this.data = data;
        this.prevHash = prevHash;
        const text = `${index}${this.timestamp}${JSON.stringify(data)}${prevHash}`;
        this.hash = crypto.createHash("sha256").update(text).digest("hex");
    }
}

class Blockchain {
    constructor() {
        this.chain = [new Block(0, "Genesis")];
    }

    add(data) {
        const prev = this.chain[this.chain.length - 1];
        this.chain.push(new Block(this.chain.length, data, prev.hash));
    }

    display() {
        for (const b of this.chain) {
            console.log("Block:", b.index);
            console.log("Data:", b.data);
            console.log("Hash:", b.hash);
            console.log("Previous Hash:", b.prevHash);
            console.log();
        }
    }

    checkArmstrong(n) {
        const power = String(n).length;
        const total = String(n)
            .split("")
            .reduce((s, d) => s + Number(d) ** power, 0);
        if (total === n) this.add({ number: n, armstrong: true }); // only Armstrong numbers are added
    }
}

module.exports = Blockchain;
```

**JavaScript – test_arm.js (run this)**

```javascript
const Blockchain = require("./arm");

const bc = new Blockchain();
bc.checkArmstrong(24);
bc.checkArmstrong(123);
bc.checkArmstrong(153);
bc.checkArmstrong(407);
bc.display();
```

### Q2. Happy

**Python – happy.py**

```python
import hashlib, time

class Block:
    def __init__(self, index, data, prev_hash=""):
        self.index = index
        self.timestamp = int(time.time() * 1000)
        self.data = data
        self.prev_hash = prev_hash
        text = f"{index}{self.timestamp}{data}{prev_hash}"
        self.hash = hashlib.sha256(text.encode()).hexdigest()

class Blockchain:
    def __init__(self):
        self.chain = [Block(0, "Genesis")]

    def add(self, data):
        self.chain.append(Block(len(self.chain), data, self.chain[-1].hash))

    def display(self):
        for b in self.chain:
            print("Block:", b.index)
            print("Data:", b.data)
            print("Hash:", b.hash)
            print("Previous Hash:", b.prev_hash)
            print()

    def check_happy(self, n):
        start, seen = n, set()
        while n != 1 and n not in seen:
            seen.add(n)
            n = sum(int(d) ** 2 for d in str(n))
        self.add({"number": start, "happy": n == 1})

bc = Blockchain()
bc.check_happy(24)
bc.check_happy(13)
bc.check_happy(19)
bc.display()
```

**JavaScript – happy.js**

```javascript
const crypto = require("crypto");

class Block {
    constructor(index, data, prevHash = "") {
        this.index = index;
        this.timestamp = Date.now();
        this.data = data;
        this.prevHash = prevHash;
        const text = `${index}${this.timestamp}${JSON.stringify(data)}${prevHash}`;
        this.hash = crypto.createHash("sha256").update(text).digest("hex");
    }
}

class Blockchain {
    constructor() {
        this.chain = [new Block(0, "Genesis")];
    }

    add(data) {
        const prev = this.chain[this.chain.length - 1];
        this.chain.push(new Block(this.chain.length, data, prev.hash));
    }

    display() {
        for (const b of this.chain) {
            console.log("Block:", b.index);
            console.log("Data:", b.data);
            console.log("Hash:", b.hash);
            console.log("Previous Hash:", b.prevHash);
            console.log();
        }
    }

    checkHappy(n) {
        const start = n,
            seen = new Set();
        while (n !== 1 && !seen.has(n)) {
            seen.add(n);
            n = String(n)
                .split("")
                .reduce((s, d) => s + d * d, 0);
        }
        this.add({ number: start, happy: n === 1 });
    }
}

module.exports = Blockchain;
```

**JavaScript – test_happy.js (run this)**

```javascript
const Blockchain = require("./happy");

const bc = new Blockchain();
bc.checkHappy(24);
bc.checkHappy(13);
bc.checkHappy(19);
bc.display();
```

### Q3. Kaprekar

**Python – kaprekar.py**

```python
import hashlib, time

class Block:
    def __init__(self, index, data, prev_hash=""):
        self.index = index
        self.timestamp = int(time.time() * 1000)
        self.data = data
        self.prev_hash = prev_hash
        text = f"{index}{self.timestamp}{data}{prev_hash}"
        self.hash = hashlib.sha256(text.encode()).hexdigest()

class Blockchain:
    def __init__(self):
        self.chain = [Block(0, "Genesis")]

    def add(self, data):
        self.chain.append(Block(len(self.chain), data, self.chain[-1].hash))

    def display(self):
        for b in self.chain:
            print("Block:", b.index)
            print("Data:", b.data)
            print("Hash:", b.hash)
            print("Previous Hash:", b.prev_hash)
            print()

    def check_kaprekar(self, n):
        square = str(n * n)
        kaprekar = n == 1
        for i in range(1, len(square)):        # split the square at every position
            left, right = int(square[:i]), int(square[i:])
            if right > 0 and left + right == n:
                kaprekar = True
        self.add({"number": n, "kaprekar": kaprekar})

bc = Blockchain()
bc.check_kaprekar(45)
bc.check_kaprekar(10)
bc.check_kaprekar(297)
bc.display()
```

**JavaScript – kaprekar.js**

```javascript
const crypto = require("crypto");

class Block {
    constructor(index, data, prevHash = "") {
        this.index = index;
        this.timestamp = Date.now();
        this.data = data;
        this.prevHash = prevHash;
        const text = `${index}${this.timestamp}${JSON.stringify(data)}${prevHash}`;
        this.hash = crypto.createHash("sha256").update(text).digest("hex");
    }
}

class Blockchain {
    constructor() {
        this.chain = [new Block(0, "Genesis")];
    }

    add(data) {
        const prev = this.chain[this.chain.length - 1];
        this.chain.push(new Block(this.chain.length, data, prev.hash));
    }

    display() {
        for (const b of this.chain) {
            console.log("Block:", b.index);
            console.log("Data:", b.data);
            console.log("Hash:", b.hash);
            console.log("Previous Hash:", b.prevHash);
            console.log();
        }
    }

    checkKaprekar(n) {
        const square = String(n * n);
        let kaprekar = n === 1;
        for (let i = 1; i < square.length; i++) {
            // split the square at every position
            const left = Number(square.slice(0, i)),
                right = Number(square.slice(i));
            if (right > 0 && left + right === n) kaprekar = true;
        }
        this.add({ number: n, kaprekar });
    }
}

module.exports = Blockchain;
```

**JavaScript – test_kaprekar.js (run this)**

```javascript
const Blockchain = require("./kaprekar");

const bc = new Blockchain();
bc.checkKaprekar(45);
bc.checkKaprekar(10);
bc.checkKaprekar(297);
bc.display();
```

**Output** Each program prints the chain with display(): a "Genesis" block, then one block per call (hashes change on every run). With the numbers used in the test files, the data fields are:

```text
arm:      24, 123, 153, 407  → blocks for 153 and 407 only (24 and 123 are skipped)
happy:    24, 13, 19         → happy: false, true, true
kaprekar: 45, 10, 297        → kaprekar: true, false, true
```

Note: the Kaprekar page (Q3) is blank in your journal, so Q3 is written fresh in the same style.

## Practical 3 – Blockchain in Python (Anagram, Deposit/Withdraw, Attendance)

**Aim:** Build a Python blockchain (SHA-256, `hashlib`) for (1) anagram checking, (2) deposit and withdraw money, (3) attendance.

**To run:** save each program under the file name shown (e.g. `p3a.py`) and run `python p3a.py`. The top part (`calc_hash`, `add_block`, `display`, `is_valid`) is the same in all three.

### Program 1. Anagram – p3a.py

```python
import hashlib, datetime

def calc_hash(index, timestamp, data, prev_hash):
    text = str(index) + timestamp + str(data) + prev_hash
    return hashlib.sha256(text.encode()).hexdigest()

def add_block(chain, data):
    index = len(chain)
    prev_hash = chain[-1]["hash"] if chain else "0"
    timestamp = str(datetime.datetime.now())
    chain.append({"index": index, "timestamp": timestamp, "data": data, "prev_hash": prev_hash,
                  "hash": calc_hash(index, timestamp, data, prev_hash)})

def display(chain):
    for b in chain:
        print("=" * 50)
        print("Block:", b["index"])
        print("Timestamp:", b["timestamp"])
        for key, value in b["data"].items():
            print(f"{key}: {value}")
        print("Hash:", b["hash"])
        print("Previous Hash:", b["prev_hash"])
    print("Blockchain is valid." if is_valid(chain) else "Blockchain is not valid.")

def is_valid(chain):
    for prev, cur in zip(chain, chain[1:]):
        if cur["prev_hash"] != prev["hash"]:
            return False
        if cur["hash"] != calc_hash(cur["index"], cur["timestamp"], cur["data"], cur["prev_hash"]):
            return False
    return True

chain = []
for w1, w2 in [("Genesis", "Genesis"), ("apple", "pleap"), ("hello", "tests"), ("listen", "silent")]:
    is_anagram = sorted(w1.lower()) == sorted(w2.lower())
    add_block(chain, {"Word 1": w1, "Word 2": w2, "Anagram": is_anagram})
display(chain)
```

### Program 2. Deposit & Withdraw – p3b.py

```python
import hashlib, datetime

def calc_hash(index, timestamp, data, prev_hash):
    text = str(index) + timestamp + str(data) + prev_hash
    return hashlib.sha256(text.encode()).hexdigest()

def add_block(chain, data):
    index = len(chain)
    prev_hash = chain[-1]["hash"] if chain else "0"
    timestamp = str(datetime.datetime.now())
    chain.append({"index": index, "timestamp": timestamp, "data": data, "prev_hash": prev_hash,
                  "hash": calc_hash(index, timestamp, data, prev_hash)})

def display(chain):
    for b in chain:
        print("=" * 50)
        print("Block:", b["index"])
        print("Timestamp:", b["timestamp"])
        for key, value in b["data"].items():
            print(f"{key}: {value}")
        print("Hash:", b["hash"])
        print("Previous Hash:", b["prev_hash"])
    print("Blockchain is valid." if is_valid(chain) else "Blockchain is not valid.")

def is_valid(chain):
    for prev, cur in zip(chain, chain[1:]):
        if cur["prev_hash"] != prev["hash"]:
            return False
        if cur["hash"] != calc_hash(cur["index"], cur["timestamp"], cur["data"], cur["prev_hash"]):
            return False
    return True

chain = []
add_block(chain, {"Balance": 1000, "Operation": "d"})              # genesis block
for op, amount in [("d", 100), ("w", 200)]:                        # d = deposit, w = withdraw
    balance = chain[-1]["data"]["Balance"]
    if op == "w" and amount > balance:
        print("Error: The withdrawn balance is greater than the money.")
    elif op == "d":
        add_block(chain, {"Balance": balance + amount, "Operation": op})
    else:
        add_block(chain, {"Balance": balance - amount, "Operation": op})
display(chain)
```

### Program 3. Attendance – p3c.py

```python
import hashlib, datetime

def calc_hash(index, timestamp, data, prev_hash):
    text = str(index) + timestamp + str(data) + prev_hash
    return hashlib.sha256(text.encode()).hexdigest()

def add_block(chain, data):
    index = len(chain)
    prev_hash = chain[-1]["hash"] if chain else "0"
    timestamp = str(datetime.datetime.now())
    chain.append({"index": index, "timestamp": timestamp, "data": data, "prev_hash": prev_hash,
                  "hash": calc_hash(index, timestamp, data, prev_hash)})

def display(chain):
    for b in chain:
        print("=" * 50)
        print("Block:", b["index"])
        print("Timestamp:", b["timestamp"])
        for key, value in b["data"].items():
            print(f"{key}: {value}")
        print("Hash:", b["hash"])
        print("Previous Hash:", b["prev_hash"])
    print("Blockchain is valid." if is_valid(chain) else "Blockchain is not valid.")

def is_valid(chain):
    for prev, cur in zip(chain, chain[1:]):
        if cur["prev_hash"] != prev["hash"]:
            return False
        if cur["hash"] != calc_hash(cur["index"], cur["timestamp"], cur["data"], cur["prev_hash"]):
            return False
    return True

chain = []
for name, status in [("Genesis", "p"), ("Yash", "p"), ("Dhruv", "a")]:   # p = present, a = absent
    add_block(chain, {"Student Name": name, "Status": status})
display(chain)
```

**Output** (timestamps and hashes change every run)

```text
Anagram                                   Deposit & Withdraw                 Attendance
Block: 0  Genesis / Genesis  True         Block: 0  Balance: 1000  d         Block: 0  Genesis  p
Block: 1  apple / pleap      True         Block: 1  Balance: 1100  d         Block: 1  Yash     p
Block: 2  hello / tests      False        Block: 2  Balance: 900   w         Block: 2  Dhruv    a
Block: 3  listen / silent    True         Blockchain is valid.               Blockchain is valid.
Blockchain is valid.
```

(On the real console every block prints on separate lines: `====…`, `Block:`, `Timestamp:`, the fields, `Hash:`, `Previous Hash:`. A withdrawal larger than the balance prints `Error: The withdrawn balance is greater than the money.`)

## Practical 4 – Smart Contracts using Remix IDE (Solidity)

**Aim:** Create and demonstrate smart contracts in Remix IDE.

**How to run any program:** open remix.ethereum.org → new file `x.sol` → paste the code → _Solidity Compiler_ tab → Compile → _Deploy & Run_ tab (environment: Remix VM) → Deploy → expand the deployed contract and call the functions.

### Program 1 – Print a simple message

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MessageContract {
    string public ms = "Hello MSc CS Students";
    function setMessage(string memory nm) public { ms = nm; }
}
```

**Output** `ms()` → `Hello MSc CS Students`; after `setMessage("Good Night")`, `ms()` → `Good Night`.

### Program 2 – Addition of two numbers

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract AdditionContract {
    function AddNumber(int num01, int num02) public pure returns (int) { return num01 + num02; }
}
```

**Output** `AddNumber(6, 7)` → `0:int256: 13`.

### Program 3 – Arithmetic operations on two numbers

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AdditionContract {
    function AddNumbers(int n1, int n2) public pure returns (int) { return n1 + n2; }
    function SubNumbers(int n1, int n2) public pure returns (int) { return n1 - n2; }
    function MultiplyNumbers(int n1, int n2) public pure returns (int) { return n1 * n2; }
    function DivideNumbers(int n1, int n2) public pure returns (int) { return n1 / n2; }
}
```

**Output** `AddNumbers` → `13`, `SubNumbers` → `-1`, `MultiplyNumbers` → `42`, `DivideNumbers` → `0` (integer division).

### Program 4 – Palindrome number

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Palindrome {
    function IsPalindrome(int num) public pure returns (bool) {
        if (num < 10) return true;
        int temporary = num;
        int reversed;
        for (; num > 0; num /= 10) reversed = reversed * 10 + num % 10;
        return temporary == reversed;
    }
}
```

**Output** `IsPalindrome(67)` → `bool: false`; `IsPalindrome(121)` → `bool: true`.

### Program 5 – Array of student names, count and list

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract StudentCount {
    string[] public StudentArray;
    function addStudent(string memory name) public { StudentArray.push(name); }
    function getCount() public view returns (uint) { return StudentArray.length; }
}
```

**Output** after `addStudent("Yash")`, `addStudent("Dhruv")` and one more name: `StudentArray(0)` → `Yash`, `StudentArray(1)` → `Dhruv`, `getCount()` → `3`.

### Program 6 – Mean, median and mode of an array

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Stats {
    uint[] public a;
    function set(uint[] memory x) public { a = x; }
    function mean() public view returns (uint) {
        uint s;
        for (uint i; i < a.length; i++) s += a[i];
        return s / a.length;
    }
    function median() public view returns (uint) { return a[a.length / 2]; }   // middle element (array entered sorted)
    function mode() public view returns (uint) { return a[0]; }                // simplified, as in the original
}
```

**Output** for example `set([24,45,66])` → `mean()` = `45`, `median()` = `45`, `mode()` = `24` (the values in your screenshots). As in your original, median assumes a sorted array and mode just returns the first element; if asked, say so.

## Practical 5 – Structures in Solidity

**Aim:** Use `struct`, arrays and mappings in Solidity (run in Remix IDE).

### Q1 A – Structure for one student

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract studInfo {
    struct student { int id; string name; string addres; int age; uint[] marks; }
    student s;

    function setValue(int i, string memory n, string memory a, int ag, uint[] memory m) public {
        s = student(i, n, a, ag, m);
    }
    function getName() public view returns (string memory) { return s.name; }
    function getGrade() public view returns (string memory) {
        uint sum;
        for (uint i; i < s.marks.length; i++) sum += s.marks[i];
        uint avg = sum / s.marks.length;
        if (avg >= 90) return "A+";
        if (avg >= 80) return "A";
        if (avg >= 70) return "B";
        if (avg >= 60) return "C";
        if (avg >= 50) return "D";
        return "F";
    }
}
```

**Run:** `setValue(1, "parth", "ssbas", 21, [90,90,90,90,90])` → `getName` = `parth`, `getGrade` = `A+`.

### Q1 B – Structure for multiple students

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract StudInfo {
    struct Student { int id; string name; string addr; int age; uint[] marks; }
    Student[] students;

    function addStudent(int i, string memory n, string memory a, int ag, uint[] memory m) public {
        students.push(Student(i, n, a, ag, m));
    }
    function totalStudents() public view returns (uint) { return students.length; }
    function allStudentDetails() public view returns (Student[] memory) { return students; }

    function getAllGrade() public view returns (string[] memory names, string[] memory grades) {
        names = new string[](students.length);
        grades = new string[](students.length);
        for (uint i; i < students.length; i++) {
            names[i] = students[i].name;
            uint sum;
            for (uint j; j < students[i].marks.length; j++) sum += students[i].marks[j];
            uint p = sum / students[i].marks.length;
            if (p >= 95) grades[i] = "Special Grade";
            else if (p >= 80) grades[i] = "Grade 1";
            else if (p >= 75) grades[i] = "Semi Grade 1";
            else grades[i] = "You are the Potential Man";
        }
    }
}
```

**Run:** `addStudent(11, "dhob", "dom", 2, [70,70,70,70])` and `addStudent(12, "raven", "dom", 2, [90,90,90,90])` → `totalStudents` = `2`; `getAllGrade` = names `dhob,raven`, grades `You are the Potential Man,Grade 1`; `allStudentDetails` lists both records.

### Q2 – Deposit and transactions of a user account

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract BankAccount {
    struct User { int accNo; string name; uint balance; }
    User u;

    function createAccount(int acc, string memory n, uint bal) public { u = User(acc, n, bal); }
    function deposit(uint amount) public { u.balance += amount; }
    function withdraw(uint amount) public returns (string memory) {
        if (u.balance < amount) return "Insufficient Balance";
        u.balance -= amount;
        return "Transaction Successful";
    }
    function getBalance() public view returns (uint) { return u.balance; }
}
```

**Run:** `createAccount(676767, "Dhob", 2000)` → `deposit(2000)` → `getBalance` = `4000` → `withdraw(1000)` returns `Transaction Successful`, `getBalance` = `3000`.

### Q3 – Perfect number

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PerfectNumber {
    function isPerfect(uint num) public pure returns (string memory) {
        if (num <= 1) return "enter a number greater than 1";
        uint sum = 1;                                   // 1 divides every number
        for (uint i = 2; i <= num / 2; i++) if (num % i == 0) sum += i;
        if (sum == num) return "It is a perfect number"; return "It is not a perfect number";
    }
}
```

**Run:** `isPerfect(6)` → `It is a perfect number`; `isPerfect(10)` → `It is not a perfect number`.

## Practical 6 – Mapping in Solidity (Voting, Quiz Single-Choice, Quiz Multi-Choice)

**Aim:** Use mappings, arrays, structs, `require` and events in Solidity (Remix IDE).

### 1. Voting

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract voting {
    mapping(string => uint) public ct;       // votes per candidate
    mapping(address => bool) public voters;  // who has voted
    mapping(string => bool) isC;             // valid candidate names
    string[] public cn;                      // candidate list

    constructor(string[] memory cdn) {
        cn = cdn;
        for (uint i; i < cdn.length; i++) isC[cdn[i]] = true;
    }
    function vote(string memory c) public {
        require(!voters[msg.sender], "You have already voted.");
        require(isC[c], "Candidate does not exist.");
        ct[c]++;
        voters[msg.sender] = true;
    }
    function getWinner() public view returns (string memory w) {
        uint t;
        for (uint i; i < cn.length; i++) if (ct[cn[i]] > t) { t = ct[cn[i]]; w = cn[i]; }
    }
}
```

**Output** deploy with `["BJP","Congress","AAP"]`; vote `BJP` from the accounts (use different accounts); `getWinner()` → `0:string: BJP`. A second vote from the same account reverts with "You have already voted."

### 2. Quiz (single-choice, answer typed as text)

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Quiz {
    struct Question { string Qtext; string CA; }   // question text, correct answer
    Question[] public q;
    uint public tc;                                // total correct
    uint public tw;                                // total wrong
    event AnswerEv(string qu, string uans, bool isc);

    function addQ(string memory qt, string memory cans) public { q.push(Question(qt, cans)); }
    function ansQ(uint i, string memory uans) public {
        require(i < q.length, "Invalid Question Index");
        bool ok = keccak256(bytes(uans)) == keccak256(bytes(q[i].CA));   // strings can't be compared with ==
        if (ok) tc++; else tw++;
        emit AnswerEv(q[i].Qtext, uans, ok);
    }
    function getCAns() public view returns (uint) { return tc; }
}
```

**Output** `addQ("Does Fushiguro Megumi have a lot of potential?", "Yes")`; `ansQ(0, "Yes")` logs `AnswerEv(…, "Yes", true)`; `ansQ(0, "No")` logs `AnswerEv(…, "No", false)`; `getCAns()` → `1`.

### 3. Quiz (multi-choice, answer picked by option number)

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Quiz {
    struct Question { string Qtext; string[4] O; uint8 cO; }   // text, 4 options, correct option index
    Question[] public q;
    uint public tc;
    uint public tw;
    event AnswerRes(string Qtext, string ans, bool isc);

    function addQ(string memory _q, string[4] memory _O, uint8 _cO) public {
        require(_cO < 4, "Invalid option");
        q.push(Question(_q, _O, _cO));
    }
    function ansQ(uint i, uint8 sO) public {
        require(i < q.length, "Invalid question");
        require(sO < 4, "Invalid option");
        bool isc = sO == q[i].cO;
        if (isc) tc++; else tw++;
        emit AnswerRes(q[i].Qtext, q[i].O[sO], isc);
    }
    function getQ(uint i) public view returns (string memory, string[4] memory, uint8) {
        require(i < q.length, "Invalid question");
        return (q[i].Qtext, q[i].O, q[i].cO);
    }
    function getS() public view returns (uint cor, uint wro) { return (tc, tw); }
}
```

**Output** `addQ("Who is the strongest Jujutsu sorcerer?", ["Itadori Yuji","Ryomen Sukuna","Gojo Satoru","Megumi Fushiguro"], 0)`; `ansQ(0, 0)` logs `AnswerRes(…, "Itadori Yuji", true)`; `ansQ(0, 1)` logs `AnswerRes(…, "Ryomen Sukuna", false)`; `getS()` → `1, 1`.

## Practical 7 – Inheritance in Solidity (Single and Multiple)

**Aim:** Demonstrate single and multiple inheritance using constructors in Solidity.

### 1. Single inheritance (Vehicle → Car)

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Vehicle {
    string vehTyp;
    string vehNum;
    constructor(string memory typ, string memory num) { vehTyp = typ; vehNum = num; }
    function display() public view returns (string memory) { return vehTyp; }
}

contract Car is Vehicle {
    string color;
    string brand;
    constructor(string memory typ, string memory num, string memory col, string memory bnd) Vehicle(typ, num) {
        color = col;
        brand = bnd;
    }
    function displayCar() public view returns (string memory) { return brand; }
}
```

**Output** deploy `Car` with `SUV`, `6767`, `Maroon`, `Maruti Suzuki`; `display()` → `0:string: SUV`; `displayCar()` → `0:string: Maruti Suzuki`.

### 2. Multiple inheritance (StudentData + Marks → Grade)

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract StudentData {
    string name;
    string rollNo;
    constructor(string memory _name, string memory _rollNo) { name = _name; rollNo = _rollNo; }
    function displayStudent() public view returns (string memory) { return name; }
    function displayRollNo() public view returns (string memory) { return rollNo; }
}

contract Marks {
    uint public marks;
    constructor(uint m) { marks = m; }
    function displayMarks() public view returns (uint) { return marks; }
}

contract Grade is StudentData, Marks {
    constructor(string memory _name, string memory _rollNo, uint m) StudentData(_name, _rollNo) Marks(m) {}

    function calculateGrade() public view returns (string memory) {
        if (marks >= 80) return "O";
        if (marks >= 70) return "A";
        if (marks >= 60) return "B";
        if (marks >= 50) return "C";
        return "F";
    }
    function displayGrade() public view returns (string memory) {
        return string.concat("Name: ", displayStudent(), " Roll No: ", displayRollNo(), " Grade: ", calculateGrade());
    }
}
```

**Output** deploy `Grade` with `Harry`, `36`, `75`; `displayGrade()` → `0:string: Name: Harry Roll No: 36 Grade: A`.

## Practical 8 – Ether in Solidity (payable functions)

**Aim:** Accept, store, transfer and withdraw Ether using `payable` functions (Remix, Remix VM accounts hold 100 ETH each).

### Q1 – Deposit and show Ether

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract payex {
    uint public b;
    function deposit() public payable { b += msg.value; }
}
```

**Output** `b()` → `0` before deposit; `deposit` with Value 20 ether → `b()` = `20000000000000000000`.

### Q2 – Deposit and transfer Ether

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract payex {
    uint public b;
    function deposit() public payable { b += msg.value; }
    function transferE(address payable r) public payable {
        require(address(this).balance >= msg.value, "Insufficient balance");
        r.transfer(msg.value);
    }
}
```

**Output** `transferE(<Account 2 address>)` with Value 15 ether → Account 1 drops from 100 to about 84.999 ETH, Account 2 rises to 115.000 ETH.

### Q2 (bank version) – deposit, transfer, balance, withdraw

Your journal's output screenshots use a contract with `deposit`, `transfer`, `showBalance`, `balance` and `withdraw`, but its code is not in the journal. This is a minimal contract that produces those outputs:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract SimpleBank {
    mapping(address => uint) public balance;
    function deposit() public payable { balance[msg.sender] += msg.value; }
    function transfer(address to, uint amt) public {
        require(balance[msg.sender] >= amt, "Insufficient balance");
        balance[msg.sender] -= amt;
        balance[to] += amt;
    }
    function showBalance() public view returns (uint) { return balance[msg.sender]; }
    function withdraw(uint amt) public {
        require(balance[msg.sender] >= amt, "Insufficient balance");
        balance[msg.sender] -= amt;
        payable(msg.sender).transfer(amt);
    }
}
```

**Output** `deposit` with 20 ether → `showBalance()` = `20000000000000000000`; `transfer(<Account 3>, 10)` → `showBalance()` = `19999999999999999990` and `balance(<Account 3>)` = `10`; `withdraw(5)` → `showBalance()` = `19999999999999999985`.

### Q3 – Student fee payment

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentFeePayment {
    address public owner = msg.sender;
    uint256 public totalFeesCollected;
    mapping(address => uint256) private feesPaid;

    function payFee() public payable {
        require(msg.value > 0, "Fee must be greater than 0");
        feesPaid[msg.sender] += msg.value;
        totalFeesCollected += msg.value;
    }
    function viewMyFee() public view returns (uint256) { return feesPaid[msg.sender]; }
    function viewTotalFeesCollected() public view returns (uint256) { return totalFeesCollected; }
    function getContractBalance() public view returns (uint256) { return address(this).balance; }
}
```

**Output** `payFee` with 55 ether from Account 1 → its balance falls to about 44.999 ETH and `viewMyFee()` = `55000000000000000000`. After other accounts pay too, `totalFeesCollected()` = `137000000000000000000` (137 ETH) and the contract balance shows 137.0 ETH.

## Practical 9 – Student Scholarship (inheritance, struct, mapping, events, payable)

**Aim:** Student scholarship system: base contract `student` (struct + mapping), derived contract `scholarship` (owner adds students, deposits funds, students claim once), with three events and `require` checks.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract student {
    struct Details { uint id; string name; string course; uint marks; bool eligible; }
    mapping(uint => Details) public students;
    mapping(uint => bool) public isRegistered;
    address public owner = msg.sender;
    event StudentAdded(uint id, string name);

    modifier onlyOwner() {
        require(msg.sender == owner, "This Action can only be performed by the Owner!");
        _;
    }
    function addStudent(uint id, string memory name, string memory course, uint marks) public onlyOwner {
        require(!isRegistered[id], "Student ID already exists!");
        students[id] = Details(id, name, course, marks, marks > 75);   // eligible only if marks > 75
        isRegistered[id] = true;
        emit StudentAdded(id, name);
    }
    function getStudent(uint id) public view returns (uint, string memory, string memory, uint, bool) {
        require(isRegistered[id], "Student Record not Found!");
        Details memory s = students[id];
        return (s.id, s.name, s.course, s.marks, s.eligible);
    }
}

contract scholarship is student {
    uint public scholarshipAmount = 4;           // wei, fixed amount per student
    mapping(uint => bool) public hasClaimed;
    event FundsDeposited(uint amount);
    event ScholarshipClaimed(uint id, address to);

    function depositFunds() public payable onlyOwner { emit FundsDeposited(msg.value); }

    function claimScholarship(uint id) public {
        require(isRegistered[id], "Student Record not found!");
        require(students[id].eligible, "Student Not Eligible!");
        require(!hasClaimed[id], "Scholarship Already Claimed!");
        require(address(this).balance >= scholarshipAmount, "Insufficient Funds");
        hasClaimed[id] = true;
        payable(msg.sender).transfer(scholarshipAmount);
        emit ScholarshipClaimed(id, msg.sender);
    }
    function getTotalFunds() public view returns (uint) { return address(this).balance; }
}
```

Deploy the `scholarship` contract.

**Output**

1. `addStudent(101, "Arv", "CS", 56)` → `getStudent(101)` = `101, Arv, CS, 56, false`.
2. `depositFunds` with Value 30 ether (owner account) → contract balance 30 ETH.
3. `claimScholarship(101)` reverts: `Student Not Eligible!` (marks too low).
4. `addStudent(102, "Adu", "CS", 99)` then `claimScholarship(102)` succeeds; claiming again reverts `Scholarship Already Claimed!`.
5. `getTotalFunds()` = `29999999999999999996` (30 ETH minus 4 wei).

Note: the question says marks > 75, but your journal code used `>= 60`. This version follows the question; both give the same results for 56 and 99. Change `marks > 75` if your teacher used 60. The three events were asked for but missing in the journal code, so they are added here.

## Practical 10 – Creating a DApp (Truffle + Ganache + MetaMask): Addition

**Aim:** Create a decentralized app (DApp) that adds two numbers using a Solidity contract, Truffle, Ganache and MetaMask.

### One-time setup

1. Install **Ganache** (Truffle Suite archive page → Download for Windows).
2. Open PowerShell and run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`, press `A` (yes to all).
3. In VS Code create a folder `DApp`, open it, open the terminal and check `npm -v`, then run `npm install -g truffle`.
4. Add the **MetaMask** extension in Chrome → _Create new wallet_ → log in.
5. Open Ganache → _Quickstart_. Click the key icon next to one account and copy its **private key**.
6. MetaMask → _Add wallet_ → _Import an account_ → paste the key → Import.
7. MetaMask → Networks → _Add a custom network_: RPC URL = the _RPC Server_ shown in Ganache (`http://127.0.0.1:7545`), currency `ETH` (chain ID 1337 if asked) → Save. Enable _show test networks_, select the new network; the imported account shows about 100 ETH. Keep the MetaMask window open.
8. In the `DApp` terminal run `npx truffle init` (creates `contracts`, `migrations`, `test`, `truffle-config.js`).

### Build the DApp

9. `contracts/addition.sol`

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Addition {
    function add(uint a, uint b) public pure returns (uint) { return a + b; }
}
```

10. `migrations/1_deploy.js`

```javascript
const Addition = artifacts.require("Addition");
module.exports = (deployer) => deployer.deploy(Addition);
```

11. `truffle-config.js` – un-comment/edit only these two parts (port must equal Ganache's RPC port):

```javascript
networks: {
  development: { host: "127.0.0.1", port: 7545, network_id: "*" },
},
compilers: {
  solc: { version: "0.8.21", settings: { optimizer: { enabled: false, runs: 200 }, evmVersion: "byzantium" } },
},
```

12. Compile: `truffle compile`
13. Create folder `frontend` with `index.html` and `app.js`.

`frontend/index.html`

```html
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Addition App</title>
    </head>
    <body>
        <input type="number" id="n1" placeholder="enter first number" /><br />
        <input type="number" id="n2" placeholder="enter second number" /><br />
        <button onclick="addition()">addition</button>
        <h1>addition is : <span id="result"></span></h1>
        <script src="https://cdn.jsdelivr.net/npm/web3@4.16.0/dist/web3.min.js"></script>
        <script src="app.js"></script>
    </body>
</html>
```

14. Deploy: `truffle migrate --reset --network development`. Copy the **contract address** from the output. The ABI is in `build/contracts/Addition.json` (the `abi` part); the short ABI below is the same thing for the one function used.

`frontend/app.js`

```javascript
const contractAddress = "PASTE_CONTRACT_ADDRESS_HERE";
const contractABI = [
    {
        type: "function",
        name: "add",
        stateMutability: "pure",
        inputs: [
            { internalType: "uint256", name: "a", type: "uint256" },
            { internalType: "uint256", name: "b", type: "uint256" },
        ],
        outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    },
];

async function addition() {
    try {
        await window.ethereum.request({ method: "eth_requestAccounts" }); // connect MetaMask
        const contract = new new Web3(window.ethereum).eth.Contract(
            contractABI,
            contractAddress,
        );
        const n1 = document.getElementById("n1").value,
            n2 = document.getElementById("n2").value;
        if (n1 === "" || n2 === "") return alert("Please enter both numbers.");
        document.getElementById("result").innerText = await contract.methods
            .add(n1, n2)
            .call();
    } catch (error) {
        alert("Error: " + error.message);
    }
}
```

15. Install the **Live Server** extension in VS Code, open `index.html`, click **Go Live** (bottom right). The browser page asks MetaMask to connect → click Connect.
16. Type two numbers (for example 40 and 27) and click _addition_.

**Output** the page shows `addition is : 67`. `add` is a `pure` function, so no MetaMask transaction pop-up and no gas are needed.

## Practical 11 – DApp for a Bank (MetaMask + Ganache + Truffle)

**Aim:** Create a decentralized bank app with deposit, withdraw, transfer and balance.

### Steps

1. Do the one-time setup of Practical 10 (steps 1–8): Ganache running, MetaMask connected, `npx truffle init` done.
2. Create `contracts/bank.sol`.
3. Create `migrations/1_deploy.js`.
4. Edit `truffle-config.js` exactly as in Practical 10 (port = Ganache RPC port, solc `0.8.21`, `evmVersion: "byzantium"`).
5. Create folder `frontend` with `index.html` and `app.js`.
6. `truffle compile`
7. `truffle migrate --network development` → copy the **contract address** (and, if you do not use the short ABI below, the ABI from `build/contracts/Bank.json`) into `app.js`.
8. Open `index.html` with Live Server (Go Live) → _Connect MetaMask_ → use Deposit / Withdraw / Transfer; confirm each transaction in the MetaMask pop-up.
9. Check the result in the page, MetaMask and the Ganache _Accounts_ tab.

### 1. contracts/bank.sol

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Bank {
    mapping(address => uint) public balance;

    function deposit() public payable { balance[msg.sender] += msg.value; }

    function withdraw(uint amount) public {
        require(balance[msg.sender] >= amount, "Insufficient Balance");
        balance[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
    function transfer(address receiver, uint amount) public {
        require(balance[msg.sender] >= amount, "Insufficient Balance");
        balance[msg.sender] -= amount;
        balance[receiver] += amount;
    }
    function showBalance() public view returns (uint) { return balance[msg.sender]; }
}
```

### 2. migrations/1_deploy.js

```javascript
const Bank = artifacts.require("bank");
module.exports = (deployer) => deployer.deploy(Bank);
```

(`artifacts.require` takes the **file name** `bank`; the contract inside is `Bank`.)

### 3. frontend/index.html

```html
<!DOCTYPE html>
<html>
    <head>
        <title>Simple Bank DApp</title>
    </head>
    <body>
        <h1>Simple Bank</h1>
        <button id="connectButton">Connect MetaMask</button>
        <p>Account: <span id="account">Not connected</span></p>

        <h2>Balance</h2>
        <p><span id="balance">0</span> ETH</p>
        <button id="refreshButton">Refresh Balance</button>
        <hr />
        <h2>Deposit</h2>
        <input id="depositAmount" type="number" placeholder="ETH amount" />
        <button id="depositButton">Deposit</button>
        <hr />
        <h2>Withdraw</h2>
        <input id="withdrawAmount" type="number" placeholder="ETH amount" />
        <button id="withdrawButton">Withdraw</button>
        <hr />
        <h2>Transfer</h2>
        <input id="receiver" type="text" placeholder="Receiver address" />
        <input id="transferAmount" type="number" placeholder="ETH amount" />
        <button id="transferButton">Transfer</button>
        <p id="status"></p>

        <script src="https://cdn.jsdelivr.net/npm/web3@4.16.0/dist/web3.min.js"></script>
        <script src="app.js"></script>
    </body>
</html>
```

### 4. frontend/app.js

```javascript
const BANK_ADDRESS = "PASTE_DEPLOYED_BANK_ADDRESS";
const BANK_ABI = [
    // only the four functions the page uses (same as the ABI in build/contracts/Bank.json)
    {
        type: "function",
        name: "deposit",
        stateMutability: "payable",
        inputs: [],
        outputs: [],
    },
    {
        type: "function",
        name: "withdraw",
        stateMutability: "nonpayable",
        inputs: [{ name: "amount", type: "uint256" }],
        outputs: [],
    },
    {
        type: "function",
        name: "transfer",
        stateMutability: "nonpayable",
        inputs: [
            { name: "receiver", type: "address" },
            { name: "amount", type: "uint256" },
        ],
        outputs: [],
    },
    {
        type: "function",
        name: "showBalance",
        stateMutability: "view",
        inputs: [],
        outputs: [{ name: "", type: "uint256" }],
    },
];

let web3, bank, user;
const $ = (id) => document.getElementById(id);
const wei = (id) => web3.utils.toWei($(id).value, "ether"); // ETH box -> wei

async function connect() {
    // connect MetaMask
    [user] = await ethereum.request({ method: "eth_requestAccounts" });
    web3 = new Web3(ethereum);
    bank = new web3.eth.Contract(BANK_ABI, BANK_ADDRESS);
    $("account").innerText = user;
    getBalance();
}
async function getBalance() {
    // show bank balance
    $("balance").innerText = web3.utils.fromWei(
        await bank.methods.showBalance().call({ from: user }),
        "ether",
    );
}
async function send(txn, status, value) {
    // send transaction, refresh, show status
    await txn.send({ from: user, value });
    await getBalance();
    $("status").innerText = status;
}

$("connectButton").onclick = connect;
$("refreshButton").onclick = getBalance;
$("depositButton").onclick = () =>
    send(bank.methods.deposit(), "Deposit successful!", wei("depositAmount"));
$("withdrawButton").onclick = () =>
    send(
        bank.methods.withdraw(wei("withdrawAmount")),
        "Withdrawal successful!",
    );
$("transferButton").onclick = () =>
    send(
        bank.methods.transfer($("receiver").value, wei("transferAmount")),
        "Transfer successful!",
    );
```

**Output** Connect → account shown, balance `0 ETH`. Deposit `23` → MetaMask asks to confirm → balance `23 ETH`. Withdraw `3` → `20 ETH`. Transfer `3` to the second imported account (`0x8b373…`) → `17 ETH` and the status line shows `Transfer successful!`. The Ganache Accounts tab shows the first account at about 68 ETH (100 − deposited 23 + withdrawn 3 − gas).

## Practical 12 – DApp to Check a Prime Number (Truffle + Ganache + MetaMask)

**Aim:** Create a DApp whose Solidity contract tells whether a number is prime.

### Steps

1. Do the one-time setup of Practical 10 (steps 1–8): Ganache running, MetaMask on the Ganache network, `npx truffle init`.
2. Create `contracts/Prime.sol`.
3. Create `migrations/1_deploy.js`.
4. Edit `truffle-config.js` as in Practical 10 (port 7545, solc `0.8.21`).
5. `truffle compile`
6. `truffle migrate --reset --network development` → copy the contract address.
7. Create `frontend/index.html` and `frontend/app.js`; paste the address into `app.js`.
8. Open `index.html` with Live Server → connect MetaMask → enter a number → click the button.

### 1. contracts/Prime.sol

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Prime {
    function isPrime(uint256 num) public pure returns (string memory) {
        if (num <= 1) return "Please enter a value above one!";
        for (uint256 i = 2; i * i <= num; i++)
            if (num % i == 0) return "The entered number is not a prime number.";
        return "The entered number is a prime number.";
    }
}
```

### 2. migrations/1_deploy.js

```javascript
const Prime = artifacts.require("Prime");
module.exports = (deployer) => deployer.deploy(Prime);
```

### 3. frontend/index.html

```html
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Prime Checker</title>
    </head>
    <body>
        <input type="number" id="n" placeholder="Enter a number" />
        <button onclick="checkPrime()">Check Prime</button>
        <h1><span id="result"></span></h1>
        <script src="https://cdn.jsdelivr.net/npm/web3@4.16.0/dist/web3.min.js"></script>
        <script src="app.js"></script>
    </body>
</html>
```

### 4. frontend/app.js

```javascript
const contractAddress = "PASTE_CONTRACT_ADDRESS_HERE";
const contractABI = [
    {
        // same as the isPrime entry in build/contracts/Prime.json
        type: "function",
        name: "isPrime",
        stateMutability: "pure",
        inputs: [{ internalType: "uint256", name: "num", type: "uint256" }],
        outputs: [{ internalType: "string", name: "", type: "string" }],
    },
];

async function checkPrime() {
    if (!window.ethereum) return alert("Please install MetaMask!");
    try {
        await ethereum.request({ method: "eth_requestAccounts" });
        const contract = new new Web3(ethereum).eth.Contract(
            contractABI,
            contractAddress,
        );
        const n = document.getElementById("n").value;
        if (n === "") return alert("Please enter a number.");
        document.getElementById("result").innerText = await contract.methods
            .isPrime(n)
            .call();
    } catch (e) {
        alert("Error: " + e.message);
    }
}
```

**Output**

| Input  | Page shows                                |
| ------ | ----------------------------------------- |
| 2      | The entered number is a prime number.     |
| 21     | The entered number is not a prime number. |
| 7      | The entered number is a prime number.     |
| 0 or 1 | Please enter a value above one!           |

(`isPrime` is `pure`, so it is a free call: no MetaMask transaction pop-up.)

## Practical 13 – DApp using Hardhat (Addition) + Voting DApp

**Aim:** Build a DApp with the Hardhat framework (local node + ethers.js front end). A Voting DApp variant (Truffle) follows.

_Note: the aim line in the journal mentions "Student Registration", but neither of your PDFs contains a student-registration contract for this practical; the executed work is the Addition DApp below (and the Voting DApp from the journal)._

### A) Hardhat – Addition DApp (minimal project)

1. Prerequisites: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`, then `node -v` (Hardhat 3 needs Node 22 or newer) and `npm -v`.
2. Create and open an empty folder: `mkdir hardhat-addition`, then `cd hardhat-addition`.
3. Install Hardhat: `npm install --save-dev hardhat`. Verify: `npx hardhat --version`.
4. Initialize: `npx hardhat --init` → keep the current folder → choose `A minimal Hardhat project` → accept ESM support → answer yes to installing the dependencies.
5. Create the folders: `mkdir -p contracts scripts frontend`.
6. Create `contracts/addition.sol`:

```solidity
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Addition {
    function add(uint a, uint b) public pure returns (uint) { return a + b; }
}
```

7. Replace `hardhat.config.ts` with:

```typescript
import { defineConfig } from "hardhat/config";
import hardhatToolboxMochaEthers from "@nomicfoundation/hardhat-toolbox-mocha-ethers";

export default defineConfig({
    plugins: [hardhatToolboxMochaEthers],
    solidity: "0.8.28",
});
```

8. Install the packages the config and script need: `npm install --save-dev @nomicfoundation/hardhat-toolbox-mocha-ethers ethers`.
9. Compile: `npx hardhat compile` (Hardhat 3 also accepts `npx hardhat build`). If it does not compile, run `npx hardhat clean` and then `npx hardhat compile --force`.
10. Create `scripts/deploy.js`:

```javascript
import { network } from "hardhat";

const { ethers } = await network.create();

const Addition = await ethers.getContractFactory("Addition");
const addition = await Addition.deploy();
await addition.waitForDeployment();

console.log("Addition deployed to:", await addition.getAddress());
```

11. Open a new terminal in the same folder and start the local blockchain: `npx hardhat node` (JSON-RPC at http://127.0.0.1:8545; leave it running).
12. In the first terminal deploy: `npx hardhat run scripts/deploy.js --network localhost` → copy the printed address. (Restarting the node wipes the chain, so deploy again and paste the new address.)
13. Create `frontend/index.html`:

```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>Hardhat Addition DApp</title>
    </head>
    <body>
        <h2>Addition DApp</h2>
        <input id="a" type="number" placeholder="a" /> +
        <input id="b" type="number" placeholder="b" />
        <button id="add">Add</button>
        <p>Result: <span id="out"></span></p>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/ethers/6.13.4/ethers.umd.min.js"></script>
        <script src="app.js"></script>
    </body>
</html>
```

14. Create `frontend/app.js` (paste the deployed address):

```javascript
const CONTRACT_ADDRESS = "PASTE_DEPLOYED_ADDRESS";
const RPC_URL = "http://127.0.0.1:8545";
const ABI = ["function add(uint256 a, uint256 b) pure returns (uint256)"];

const contract = new ethers.Contract(
    CONTRACT_ADDRESS,
    ABI,
    new ethers.JsonRpcProvider(RPC_URL),
);
const $ = (id) => document.getElementById(id);

$("add").onclick = async () => {
    try {
        const r = await contract.add($("a").value, $("b").value);
        $("out").innerText = r.toString();
    } catch (e) {
        $("out").innerText = "Error: " + e.message;
    }
};
```

15. Host `frontend/index.html` with the VS Code Live Server extension (Go Live). Enter 40 and 27, click Add.
16. Check the `npx hardhat node` terminal: it logs `eth_call` for `Addition#add`.

**Output** step 9 compiles without errors; step 12 prints Addition deployed to: 0x…; the page shows Result: 67; the node terminal shows the eth_call Addition#add entry.

### B) Voting DApp (Truffle + Ganache + MetaMask)

Setup is the same as Practical 10 (steps 1–8, `npx truffle init`, truffle-config as before). Then:

### 1. contracts/voting.sol

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Voting {
    struct Candidate { uint256 id; string name; uint256 voteCount; }

    address public owner;
    uint256 public candidateCount;
    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public hasVoted;

    event CandidateAdded(uint256 id, string name);
    event VoteCast(address voter, uint256 candidateId);

    constructor() { owner = msg.sender; }

    function addCandidate(string memory _name) public {
        require(msg.sender == owner, "Only owner");
        require(bytes(_name).length > 0, "Name required");
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
        emit CandidateAdded(candidateCount, _name);
    }

    function vote(uint256 _id) public {
        require(!hasVoted[msg.sender], "Already voted");
        require(_id > 0 && _id <= candidateCount, "Invalid candidate");
        hasVoted[msg.sender] = true;
        candidates[_id].voteCount++;
        emit VoteCast(msg.sender, _id);
    }

    function getCandidate(uint256 _id) public view returns (uint256, string memory, uint256) {
        Candidate memory c = candidates[_id];
        return (c.id, c.name, c.voteCount);
    }
}
```

### 2. migrations/1_deploy.js

```javascript
const Voting = artifacts.require("Voting");
module.exports = (deployer) => deployer.deploy(Voting);
```

**3.** `truffle compile`, then `truffle migrate --reset --network development` → copy the address. The first account (the deployer) is the owner and can add candidates.

### 4. frontend/index.html

```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>Voting DApp</title>
    </head>
    <body>
        <h2>Voting DApp</h2>
        <ul id="list"></ul>
        <input id="name" placeholder="Candidate name" />
        <button id="addBtn">Add Candidate</button>
        <p id="status"></p>
        <script src="https://cdn.jsdelivr.net/npm/web3@4.16.0/dist/web3.min.js"></script>
        <script src="app.js"></script>
    </body>
</html>
```

### 5. frontend/app.js

```javascript
const ADDRESS = "PASTE_DEPLOYED_ADDRESS";
const ABI = [
    {
        type: "function",
        name: "candidateCount",
        stateMutability: "view",
        inputs: [],
        outputs: [{ type: "uint256" }],
    },
    {
        type: "function",
        name: "addCandidate",
        stateMutability: "nonpayable",
        inputs: [{ name: "_name", type: "string" }],
        outputs: [],
    },
    {
        type: "function",
        name: "vote",
        stateMutability: "nonpayable",
        inputs: [{ name: "_id", type: "uint256" }],
        outputs: [],
    },
    {
        type: "function",
        name: "getCandidate",
        stateMutability: "view",
        inputs: [{ name: "_id", type: "uint256" }],
        outputs: [{ type: "uint256" }, { type: "string" }, { type: "uint256" }],
    },
];

let contract, user;
const $ = (id) => document.getElementById(id);

async function load() {
    // list candidates with vote counts
    const n = Number(await contract.methods.candidateCount().call());
    $("list").innerHTML = "";
    for (let i = 1; i <= n; i++) {
        const c = await contract.methods.getCandidate(i).call();
        const li = document.createElement("li");
        li.innerHTML = `${c[1]} – ${c[2]} votes `;
        const b = document.createElement("button");
        b.textContent = "Vote";
        b.onclick = () => run(contract.methods.vote(i), "Vote cast!");
        li.appendChild(b);
        $("list").appendChild(li);
    }
}
async function run(txn, ok) {
    // send tx, report, reload
    try {
        await txn.send({ from: user });
        $("status").innerText = ok;
        await load();
    } catch (e) {
        $("status").innerText = "Error: " + e.message;
    }
}
$("addBtn").onclick = () =>
    run(contract.methods.addCandidate($("name").value), "Candidate added!");

(async () => {
    [user] = await ethereum.request({ method: "eth_requestAccounts" });
    contract = new new Web3(ethereum).eth.Contract(ABI, ADDRESS);
    load();
})();
```

**6.** Open with Live Server → connect MetaMask (owner account) → add candidates → switch to another account and click **Vote**. Voting twice from the same account fails with `Already voted`; adding a candidate from a non-owner fails with `Only owner`.

**Output** the list shows each candidate with a live vote count (e.g. `Alice – 1 votes`), and the status line shows `Candidate added!` / `Vote cast!`.

## Practical 15 – Solidity Inheritance & Payments (Remix IDE)

**Aim:** Write contracts that use inheritance, payable functions, events and `require` (online store, vehicle rental, doctor appointments).

**Steps (all programs):** open remix.ethereum.org → new file → paste code → _Solidity compiler_ tab → Compile → _Deploy & Run_ tab, environment _Remix VM_. Deploy the **derived** (child) contract; to send Ether set the _VALUE_ box (use Wei) before pressing a payable function.

### Q1. Online store

Base contract `product` holds the item; `onlineStore` inherits it and sells stock.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract product {
    uint productId;
    string productName;
    uint price;
    uint stock;

    constructor(uint _id, string memory _name, uint _price, uint _stock) {
        productId = _id; productName = _name; price = _price; stock = _stock;
    }
    function displayProduct() public view returns (uint, string memory, uint, uint) {
        return (productId, productName, price, stock);
    }
}

contract onlineStore is product {
    constructor(uint _id, string memory _name, uint _price, uint _stock) product(_id, _name, _price, _stock) {}

    function purchase(uint q) public payable {
        require(stock >= q, "Product out of stock");
        require(msg.value == q * price, "Wrong Payment");
        stock -= q;
    }
}
```

**Run:** deploy `onlineStore` with `1001, "water", 10, 20` → `displayProduct` gives `1001, water, 10, 20`. Set VALUE = `30` wei, call `purchase(3)` → `displayProduct` now gives stock `17`. `purchase(3)` with a wrong VALUE reverts with `Wrong Payment`; asking for more than the stock reverts with `Product out of stock`.

### Q2. Vehicle rental

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vehicle {
    string public vehicleRegistration;
    string public vehicleBrand;
    uint public vehicleRent;          // rent per day (wei)

    constructor(string memory _reg, string memory _brand, uint _rent) {
        vehicleRegistration = _reg; vehicleBrand = _brand; vehicleRent = _rent;
    }
}

contract CarRental is Vehicle {
    address public renter;
    bool public available = true;
    uint public dueTime;

    event VehicleRented(address indexed renter, uint rentalDays, uint amount);
    event VehicleReturned(address indexed renter, uint penalty);

    constructor(string memory _reg, string memory _brand, uint _rent) Vehicle(_reg, _brand, _rent) {}

    function rentVehicle(uint _days) public payable {
        require(available, "Vehicle not available");
        require(_days > 0 && msg.value >= vehicleRent * _days, "Insufficient payment");
        (available, renter, dueTime) = (false, msg.sender, block.timestamp + _days * 1 minutes);   // 1 day = 1 minute for testing
        emit VehicleRented(msg.sender, _days, msg.value);
    }

    function calculatePenalty() public view returns (uint) {
        if (available || block.timestamp <= dueTime) return 0;
        return ((block.timestamp - dueTime) / 1 minutes + 1) * vehicleRent / 2;   // half the rent per late day
    }

    function returnVehicle() public payable {
        require(!available && msg.sender == renter, "Not the renter");
        uint penalty = calculatePenalty();
        require(msg.value >= penalty, "Pay the penalty");
        available = true;
        emit VehicleReturned(msg.sender, penalty);
    }
}
```

**Run:** deploy `CarRental` with `"1", "audi", 5000`. `rentVehicle(1)` with VALUE `5000` wei → `available` = false, `renter` = your account. Wait about 2 minutes (past `dueTime`) → `calculatePenalty` returns `2500`. Call `returnVehicle` with VALUE `2500` → `available` = true again and `VehicleReturned` is emitted. Returning on time gives penalty `0`.

### Q3. Doctor appointments

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Doctor {
    string public name;
    string public specialization;
    uint public fee;
    address public immutable owner;

    constructor(string memory _name, string memory _spec, uint _fee) {
        name = _name; specialization = _spec; fee = _fee; owner = msg.sender;
    }
}

contract Hospital is Doctor {
    struct Booking { address patient; uint paid; }
    mapping(uint => Booking) public bookings;      // slot (unix time) => booking

    event AppointmentBooked(address indexed patient, uint slot, uint paid);
    event AppointmentCancelled(address indexed patient, uint slot, uint refund);

    constructor(string memory _name, string memory _spec, uint _fee) Doctor(_name, _spec, _fee) {}

    function bookAppointment(uint slot) external payable {
        require(slot > block.timestamp, "Slot in the past");
        require(bookings[slot].patient == address(0), "Slot taken");
        require(msg.value == fee, "Wrong fee");
        bookings[slot] = Booking(msg.sender, msg.value);
        emit AppointmentBooked(msg.sender, slot, msg.value);
    }

    function cancelAppointment(uint slot) external {
        Booking memory b = bookings[slot];
        require(b.patient == msg.sender, "Not your booking");
        require(slot > block.timestamp, "Slot already passed");
        uint refund = slot - block.timestamp >= 1 days ? b.paid : b.paid / 2;   // full refund if 1+ day away, else 50%
        delete bookings[slot];
        (bool ok, ) = msg.sender.call{value: refund}("");
        require(ok, "Refund failed");
        emit AppointmentCancelled(msg.sender, slot, refund);
    }

    function updateFee(uint _fee) external {
        require(msg.sender == owner, "Only owner");
        fee = _fee;
    }
}
```

**Run:** deploy `Hospital` with `"Dr Ishita", "Cardiothoracic", 67`. With VALUE `67` wei call `bookAppointment(44030725067)` (a future unix time) → `bookings(44030725067)` shows your address and `67`. `updateFee(69)` from the owner account → `fee` = `69`. `cancelAppointment(44030725067)` → the slot is more than a day away, so the full `67` wei is refunded and the booking is cleared. A different account calling `updateFee` reverts with `Only owner`.
