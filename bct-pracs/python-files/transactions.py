import hashlib
import datetime

class Block:
    def __init__(self, i, op, bal, ph):
        self.i = i
        self.t = str(datetime.datetime.now())
        self.op = op
        self.bal = bal
        self.ph = ph
        self.h = self.calHash()

    def calHash(self):
        data = (
            str(self.i) + self.t + self.op
            + str(self.bal) + self.ph
        )
        return hashlib.sha256(data.encode()).hexdigest()


class Blockchain:
    def __init__(self):
        self.chain = []
        self.createGenesisBlock()

    def createGenesisBlock(self):
        genesis = Block(0, "d", 1000, "0")
        self.chain.append(genesis)

    def addBlock(self, op, m):
        pb = self.chain[-1].bal
        op = op.lower()

        if op == "d":
            pb += m
        elif op == "w":
            if pb < m:
                print("Error: The withdrawn balance is greater than the money.")
                return
            pb -= m
        else:
            print("Error: Invalid operation.")
            return

        ph = self.chain[-1].h
        b = Block(len(self.chain), op, pb, ph)
        self.chain.append(b)

    def display(self):
        print("Developed by xyz")

        for b in self.chain:
            print("=" * 50)
            print("Block:", b.i)
            print("Timestamp:", b.t)
            print("Balance:", b.bal)
            print("Operation:", b.op)
            print("Hash:", b.h)
            print("Previous Hash:", b.ph)

    def validate(self):
        for i in range(1, len(self.chain)):
            if self.chain[i].ph != self.chain[i - 1].h:
                return False

            if self.chain[i].h != self.chain[i].calHash():
                return False

        return True


p = Blockchain()

p.addBlock("d", 100)
p.addBlock("w", 200)

p.display()

if p.validate():
    print("Blockchain is valid.")
else:
    print("Blockchain is not valid.")
