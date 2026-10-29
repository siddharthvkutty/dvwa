import hashlib
import datetime

class Block:
    def __init__(self, i, n, a, ph):
        self.i = i
        self.t = str(datetime.datetime.now())
        self.n = n
        self.a = a
        self.ph = ph
        self.h = self.calHash()

    def calHash(self):
        data = (
            str(self.i) + self.t + self.n
            + str(self.a) + self.ph
        )
        return hashlib.sha256(data.encode()).hexdigest()


class Blockchain:
    def __init__(self):
        self.chain = []
        self.createGenesisBlock()

    def createGenesisBlock(self):
        genesis = Block(0, "Genesis", "p", "0")
        self.chain.append(genesis)

    def addBlock(self, n, status):
        ph = self.chain[-1].h
        b = Block(len(self.chain), n, status, ph)
        self.chain.append(b)

    def display(self):
        print("Developed by xyz")

        for b in self.chain:
            print("=" * 50)
            print("Block:", b.i)
            print("Timestamp:", b.t)
            print("Student Name:", b.n)
            print("Status:", b.a)
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
p.addBlock("Atharv", "p")
p.addBlock("Parth", "a")

print("=" * 50)
print("Is the blockchain valid?:", p.isValid())
p.display()
