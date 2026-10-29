# Coding Logic Cheat Sheet – Python & JavaScript

Just the check or algorithm from each practical (Part A), plus common programs asked in coding exams (Part B). To use one in a practical, make it a method of the `Blockchain` class and pass its result to `self.add(...)`. Every snippet was run in both languages and gives the output shown in its comments.

## Part A – Logic from the practicals

### 1. Addition of two numbers

Practical 1 Q1 – the check stored in the block.

**Python**

```python
def add(a, b):
    return a + b

print(add(24, 12))   # 36
```

**JavaScript**

```javascript
function add(a, b) {
    return a + b;
}

console.log(add(24, 12)); // 36
```

### 2. Prime number

Practical 1 Q2. A number is prime if no number from 2 up to its square root divides it.

**Python**

```python
def is_prime(n):
    if n < 2:
        return False
    for i in range(2, int(n ** 0.5) + 1):
        if n % i == 0:
            return False
    return True

print(is_prime(7), is_prime(6))   # True False
```

**JavaScript**

```javascript
function isPrime(n) {
    if (n < 2) return false;
    for (let i = 2; i * i <= n; i++) {
        if (n % i === 0) return false;
    }
    return true;
}

console.log(isPrime(7), isPrime(6)); // true false
```

### 3. Krishnamurthy (strong) number

Practical 1 Q3. Sum of the factorials of the digits equals the number (145 = 1! + 4! + 5!).

**Python**

```python
import math

def is_krishnamurthy(n):
    return sum(math.factorial(int(d)) for d in str(n)) == n

print(is_krishnamurthy(145), is_krishnamurthy(12))   # True False
```

**JavaScript**

```javascript
function fact(n) {
    return n <= 1 ? 1 : n * fact(n - 1);
}

function isKrishnamurthy(n) {
    let sum = 0;
    for (const d of String(n)) sum += fact(Number(d));
    return sum === n;
}

console.log(isKrishnamurthy(145), isKrishnamurthy(12)); // true false
```

### 4. Armstrong number

Practical 2 Q1. Sum of each digit raised to the number of digits equals the number (153 = 1³ + 5³ + 3³).

**Python**

```python
def is_armstrong(n):
    power = len(str(n))
    return sum(int(d) ** power for d in str(n)) == n

print(is_armstrong(153), is_armstrong(123))   # True False
print([n for n in range(1, 1000) if is_armstrong(n)])   # all below 1000
```

**JavaScript**

```javascript
function isArmstrong(n) {
    const power = String(n).length;
    let sum = 0;
    for (const d of String(n)) sum += Number(d) ** power;
    return sum === n;
}

console.log(isArmstrong(153), isArmstrong(123)); // true false
const list = [];
for (let n = 1; n < 1000; n++) if (isArmstrong(n)) list.push(n);
console.log(list); // all below 1000
```

### 5. Happy number

Practical 2 Q2. Repeatedly replace the number by the sum of the squares of its digits; it is happy if you reach 1, otherwise you loop forever (detect the loop with a set).

**Python**

```python
def is_happy(n):
    seen = set()
    while n != 1 and n not in seen:
        seen.add(n)
        n = sum(int(d) ** 2 for d in str(n))
    return n == 1

print(is_happy(19), is_happy(4))   # True False
```

**JavaScript**

```javascript
function isHappy(n) {
    const seen = new Set();
    while (n !== 1 && !seen.has(n)) {
        seen.add(n);
        let sum = 0;
        for (const d of String(n)) sum += d * d;
        n = sum;
    }
    return n === 1;
}

console.log(isHappy(19), isHappy(4)); // true false
```

### 6. Kaprekar number

Practical 2 Q3. Square the number, split the square into a left and right part at every position; if left + right equals the number (right part not 0) it is Kaprekar (45² = 2025, 20 + 25 = 45).

**Python**

```python
def is_kaprekar(n):
    if n == 1:
        return True
    square = str(n * n)
    for i in range(1, len(square)):
        left, right = int(square[:i]), int(square[i:])
        if right > 0 and left + right == n:
            return True
    return False

print(is_kaprekar(45), is_kaprekar(10), is_kaprekar(297))   # True False True
```

**JavaScript**

```javascript
function isKaprekar(n) {
    if (n === 1) return true;
    const square = String(n * n);
    for (let i = 1; i < square.length; i++) {
        const left = Number(square.slice(0, i));
        const right = Number(square.slice(i));
        if (right > 0 && left + right === n) return true;
    }
    return false;
}

console.log(isKaprekar(45), isKaprekar(10), isKaprekar(297)); // true false true
```

### 7. Anagram check

Practical 3. Two words are anagrams if their letters sorted (ignoring case) are equal.

**Python**

```python
def is_anagram(a, b):
    return sorted(a.lower()) == sorted(b.lower())

print(is_anagram("listen", "silent"), is_anagram("hello", "tests"))   # True False
```

**JavaScript**

```javascript
function isAnagram(a, b) {
    const sort = (s) => s.toLowerCase().split("").sort().join("");
    return sort(a) === sort(b);
}

console.log(isAnagram("listen", "silent"), isAnagram("hello", "tests")); // true false
```

### 8. Deposit and withdraw

Practical 3. Withdraw only if the balance is enough.

**Python**

```python
balance = 0

def deposit(amount):
    global balance
    balance += amount

def withdraw(amount):
    global balance
    if amount > balance:
        return "Insufficient balance"
    balance -= amount
    return "OK"

deposit(500)
print(withdraw(200), balance)   # OK 300
print(withdraw(1000), balance)  # Insufficient balance 300
```

**JavaScript**

```javascript
let balance = 0;

function deposit(amount) {
    balance += amount;
}

function withdraw(amount) {
    if (amount > balance) return "Insufficient balance";
    balance -= amount;
    return "OK";
}

deposit(500);
console.log(withdraw(200), balance); // OK 300
console.log(withdraw(1000), balance); // Insufficient balance 300
```

### 9. Mean, median and mode

Practical 4 (Solidity version) – same logic on an array.

**Python**

```python
def mean(a):
    return sum(a) / len(a)

def median(a):
    a = sorted(a)
    mid = len(a) // 2
    return a[mid] if len(a) % 2 else (a[mid - 1] + a[mid]) / 2

def mode(a):
    return max(a, key=a.count)

nums = [4, 1, 2, 2, 3]
print(mean(nums), median(nums), mode(nums))   # 2.4 2 2
```

**JavaScript**

```javascript
const mean = (a) => a.reduce((s, x) => s + x, 0) / a.length;

function median(a) {
    a = [...a].sort((x, y) => x - y);
    const mid = Math.floor(a.length / 2);
    return a.length % 2 ? a[mid] : (a[mid - 1] + a[mid]) / 2;
}

function mode(a) {
    const count = {};
    for (const x of a) count[x] = (count[x] || 0) + 1;
    return Number(
        Object.keys(count).reduce((best, k) =>
            count[k] > count[best] ? k : best,
        ),
    );
}

const nums = [4, 1, 2, 2, 3];
console.log(mean(nums), median(nums), mode(nums)); // 2.4 2 2
```

## Part B – Common coding-exam programs

### 10. Palindrome (number and string)

Reads the same forwards and backwards.

**Python**

```python
def is_palindrome(x):
    s = str(x)
    return s == s[::-1]

print(is_palindrome(121), is_palindrome("madam"), is_palindrome(123))   # True True False
```

**JavaScript**

```javascript
function isPalindrome(x) {
    const s = String(x);
    return s === s.split("").reverse().join("");
}

console.log(isPalindrome(121), isPalindrome("madam"), isPalindrome(123)); // true true false
```

### 11. Perfect number

Sum of the proper divisors equals the number (6 = 1 + 2 + 3).

**Python**

```python
def is_perfect(n):
    return n > 1 and sum(i for i in range(1, n) if n % i == 0) == n

print(is_perfect(6), is_perfect(28), is_perfect(12))   # True True False
```

**JavaScript**

```javascript
function isPerfect(n) {
    let sum = 0;
    for (let i = 1; i < n; i++) if (n % i === 0) sum += i;
    return n > 1 && sum === n;
}

console.log(isPerfect(6), isPerfect(28), isPerfect(12)); // true true false
```

### 12. Factorial

n! = n × (n−1) × … × 1, and 0! = 1.

**Python**

```python
def factorial(n):
    result = 1
    for i in range(2, n + 1):
        result *= i
    return result

print(factorial(5))   # 120
```

**JavaScript**

```javascript
function factorial(n) {
    let result = 1;
    for (let i = 2; i <= n; i++) result *= i;
    return result;
}

console.log(factorial(5)); // 120
```

### 13. Fibonacci series

Each term is the sum of the previous two: 0, 1, 1, 2, 3, 5, …

**Python**

```python
def fibonacci(n):
    series, a, b = [], 0, 1
    for _ in range(n):
        series.append(a)
        a, b = b, a + b
    return series

print(fibonacci(8))   # [0, 1, 1, 2, 3, 5, 8, 13]
```

**JavaScript**

```javascript
function fibonacci(n) {
    const series = [];
    let a = 0,
        b = 1;
    for (let i = 0; i < n; i++) {
        series.push(a);
        [a, b] = [b, a + b];
    }
    return series;
}

console.log(fibonacci(8)); // [0, 1, 1, 2, 3, 5, 8, 13]
```

### 14. Reverse a number and sum of digits

Peel digits off with % 10 and // 10 (the pattern behind most digit problems).

**Python**

```python
def reverse_number(n):
    rev = 0
    while n > 0:
        rev = rev * 10 + n % 10
        n //= 10
    return rev

def digit_sum(n):
    total = 0
    while n > 0:
        total += n % 10
        n //= 10
    return total

print(reverse_number(1234), digit_sum(1234))   # 4321 10
```

**JavaScript**

```javascript
function reverseNumber(n) {
    let rev = 0;
    while (n > 0) {
        rev = rev * 10 + (n % 10);
        n = Math.floor(n / 10);
    }
    return rev;
}

function digitSum(n) {
    let total = 0;
    while (n > 0) {
        total += n % 10;
        n = Math.floor(n / 10);
    }
    return total;
}

console.log(reverseNumber(1234), digitSum(1234)); // 4321 10
```

### 15. GCD and LCM

Euclid's algorithm; LCM = a × b / GCD.

**Python**

```python
def gcd(a, b):
    while b:
        a, b = b, a % b
    return a

def lcm(a, b):
    return a * b // gcd(a, b)

print(gcd(12, 18), lcm(12, 18))   # 6 36
```

**JavaScript**

```javascript
function gcd(a, b) {
    while (b) [a, b] = [b, a % b];
    return a;
}

const lcm = (a, b) => (a * b) / gcd(a, b);

console.log(gcd(12, 18), lcm(12, 18)); // 6 36
```
