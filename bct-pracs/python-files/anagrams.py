import hashlib
import datetime

class Block:
    def __init__(self, i, w1, w2, r, ph):
        self.i = i
        self.t = str(datetime.datetime.now())
        self.w1 = w1
        self.w2 = w2
        self.r = r
        self.ph = ph
        self.h = self.calHash()

    def calHash(self):
        data = (
            str(self.i) + self.t + self.w1 +
            self.w2 + str(self.r) + self.ph
        )
        return hashlib.sha256(data.encode()).hexdigest()


class Blockchain:
    def __init__(self):
        self.chain = []
        self.createGenesisBlock()

    def createGenesisBlock(self):
        genesis = Block(0, "Genesis", "Genesis", True, "0")
        self.chain.append(genesis)

    def addBlock(self, w1, w2):
        s1 = w1.lower()
        s2 = w2.lower()
        r = sorted(s1) == sorted(s2)
        ph = self.chain[-1].h
        b = Block(len(self.chain), w1, w2, r, ph)
        self.chain.append(b)

    def display(self):
        print("Developed by XYZ")
        for b in self.chain:
            print("=" * 50)
            print("Block:", b.i)
            print("Timestamp:", b.t)
            print("Word 1:", b.w1)
            print("Word 2:", b.w2)
            print("Anagram:", b.r)
            print("Hash:", b.h)
            print("Previous Hash:", b.ph)

    def isValid(self):
        for i in range(1, len(self.chain)):
            current_block = self.chain[i]
            previous_block = self.chain[i - 1]

            if current_block.h != current_block.calHash():
                return False

            if current_block.ph != previous_block.h:
                return False

        return True


p = Blockchain()
p.addBlock("bread", "apple")
p.addBlock("welcome", "guest")
p.addBlock("listen", "silent")

print("=" * 50)
print("Is the blockchain valid?:", p.isValid())
p.display()
