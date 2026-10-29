#Demonstrate a Blockchain to identify if the given number is a Happy Number or not.
import hashlib, time, json

class Block:
    def __init__(self, i, n, ph=""):
        self.i, self.t, self.n, self.ph = i, int(time.time()*1000), n, ph
        self.H = self.checkHappy(n)
        self.h = self.hash()

    def checkHappy(self, n):
        seen = set()
        while n != 1 and n not in seen:
            seen.add(n)
            n = sum(int(d)**2 for d in str(n))
        return "Happy Number" if n == 1 else "Not a Happy Number"

    def hash(self):
        data = f"{self.i}{self.t}{self.n}{self.H}{self.ph}"
        return hashlib.sha256(data.encode()).hexdigest()

class Blockchain:
    def __init__(self):
        self.chain = [Block(0, 0)]

    def addBlock(self, b):
        b.ph = self.chain[-1].h
        b.h = b.hash()
        self.chain.append(b)

sm = Blockchain()
print("Developed by Mona Mourya")

sm.addBlock(Block(1, 24))
sm.addBlock(Block(2, 13))

print(json.dumps([b.__dict__ for b in sm.chain], indent=3))
