# Demonstration of a Blockchain for checking whether a number is a prime number or not

import hashlib
import time
import json

class Block:
    def __init__(self, i, n, ph=""):
        self.i, self.t, self.n, self.ph = i, int(time.time()*1000), n, ph
        self.prime = self.checkPrime(n)
        self.h = self.callHash()

    def checkPrime(self, n):
        if n < 2:
            return False
        for i in range(2, int(n**0.5) + 1):
            if n % i == 0:
                return False
        return True

    def callHash(self):
        data = f"{self.i}{self.t}{self.prime}{self.ph}"
        return hashlib.sha256(data.encode()).hexdigest()


class Blockchain:
    def __init__(self):
        self.chain = [Block(0, 3)]

    def addBlock(self, b):
        b.ph = self.chain[-1].h
        b.h = b.callHash()
        self.chain.append(b)


sm = Blockchain()
print("Developed by Mona Mourya")

sm.addBlock(Block(1, 24))
sm.addBlock(Block(2, 67))

print(json.dumps([b.__dict__ for b in sm.chain], indent=3))
