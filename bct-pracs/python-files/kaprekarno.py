#Demonstrate a Blockchain to identify if the given number is Kaprekar’s Number or not.\
import hashlib, time, json

class Block:
    def __init__(self, i, n, ph=""):
        self.i, self.t, self.n, self.ph = i, int(time.time()*1000), n, ph
        self.kaprekar = self.checkKaprekar()
        self.h = self.callHash()

    def checkKaprekar(self):
        if self.n == 1:
            return True
        if self.n <= 0:
            return False
        s = str(self.n ** 2)
        for i in range(1, len(s)):
            if int(s[:i]) + int(s[i:]) == self.n:
                return True
        return False

    def callHash(self):
        data = f"{self.i}{self.t}{self.n}{self.ph}{self.kaprekar}"
        return hashlib.sha256(data.encode()).hexdigest()

class Blockchain:
    def __init__(self):
        self.chain = [Block(0, 2)]

    def addBlock(self, b):
        b.ph = self.chain[-1].h
        b.h = b.callHash()
        if b.kaprekar:
            self.chain.append(b)

    def validateBlock(self):
        return all(self.chain[i].ph == self.chain[i-1].h
                   for i in range(1, len(self.chain)))

sm = Blockchain()
print("Developed by Mona Mourya")

for i, n in enumerate([145, 45, 9, 0], 1):
    sm.addBlock(Block(i, n))

print(json.dumps([b.__dict__ for b in sm.chain], indent=3))
print("Validation:", sm.validateBlock())
