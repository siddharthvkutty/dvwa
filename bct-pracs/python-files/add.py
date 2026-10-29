#Question 01 - Demonstration of a Blockchain for adding two numbers 

import hashlib
import time
import json

class Block:
    def __init__(self, i, n1, n2, ph=""):
        self.i, self.t = i, int(time.time() * 1000)
        self.n1, self.n2 = n1, n2
        self.sum, self.ph = n1 + n2, ph
        self.h = self.hash()

    def hash(self):
        data = f"{self.i}{self.t}{self.sum}{self.ph}"
        return hashlib.sha256(data.encode()).hexdigest()


class Blockchain:
    def __init__(self):
        self.chain = [Block(0, 0, 0)]

    def addBlock(self, b):
        b.ph = self.chain[-1].h
        b.h = b.hash()
        self.chain.append(b)


sm = Blockchain()
print("Developed by Mona Mourya")

sm.addBlock(Block(1, 12, 24))
sm.addBlock(Block(2, 58, 9))

print(json.dumps([b.__dict__ for b in sm.chain], indent=3))
