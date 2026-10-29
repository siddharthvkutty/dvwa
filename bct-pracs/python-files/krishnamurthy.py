#Demonstrating a Blockchain Program to test whether a number is a KrishnaMurthy Number or not.

import hashlib
import time
import json

class Block:
    def __init__(self, i, n, ph=""):
        self.i, self.t, self.n, self.ph = i, int(time.time()*1000), n, ph
        self.km = self.checkKm(n)
        self.h = self.callHash()

    def calFact(self, n):
        fact = 1
        for i in range(1, n + 1):
            fact *= i
        return fact

    def checkKm(self, n):
        return sum(self.calFact(int(d)) for d in str(n)) == n

    def callHash(self):
        data = f"{self.i}{self.t}{self.km}{self.ph}"
        return hashlib.sha256(data.encode()).hexdigest()


class Blockchain:
    def __init__(self):
        self.chain = [Block(0, 0)]

    def addBlock(self, b):
        b.ph = self.chain[-1].h
        b.h = b.callHash()
        self.chain.append(b)


sm = Blockchain()
print("Developed by Mona Mourya")

sm.addBlock(Block(1, 145))
sm.addBlock(Block(2, 67))

print(json.dumps([b.__dict__ for b in sm.chain], indent=3))
