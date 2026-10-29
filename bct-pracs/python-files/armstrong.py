#Demonstration of a Blockchain for identifying if a number is an Armstrong Number or not.
import hashlib, time, json

class Block:
    def __init__(self, i, num, ph=""):
        self.i, self.t, self.num, self.ph = i, int(time.time()*1000), num, ph
        self.armStrong = self.checkArmStrong()
        self.h = self.callHash()

    def checkArmStrong(self):
        n = str(self.num)
        return sum(int(d)**len(n) for d in n) == self.num

    def callHash(self):
        data = f"{self.i}{self.t}{self.num}{self.armStrong}{self.ph}"
        return hashlib.sha256(data.encode()).hexdigest()

class BlockChain:
    def __init__(self):
        self.chain = [Block(0, 3)]

    def getCBlock(self):
        return self.chain[-1]

    def addBlock(self, b):
        b.ph = self.getCBlock().h
        b.h = b.callHash()
        if b.armStrong:
            self.chain.append(b)

    def validateBlock(self):
        return all(self.chain[i].ph == self.chain[i-1].h
                   for i in range(1, len(self.chain)))

sm = BlockChain()
print("Developed by Mona Mourya")

for i, n in enumerate([145, 45, 153, 0], 1):
    sm.addBlock(Block(i, n))

print(json.dumps([b.__dict__ for b in sm.chain], indent=3))
print("Validation:", sm.validateBlock())
