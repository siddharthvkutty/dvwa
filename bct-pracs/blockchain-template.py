import hashlib, time, json

class Block:
    def __init__(self, i, data, ph=""):
        self.i, self.t, self.data, self.ph = i, int(time.time()*1000), data, ph
        self.h = hashlib.sha256(f"{i}{self.t}{data}{ph}".encode()).hexdigest()

class Blockchain:
    def __init__(self): self.chain = [Block(0, "Genesis")]
    def add(self, data): self.chain.append(Block(len(self.chain), data, self.chain[-1].h))
    
    # Define your custom functions here:
    def my_custom_function(self, value):
        self.add(value)

bc = Blockchain()
bc.my_custom_function("Hello Blockchain")
print(json.dumps([b.__dict__ for b in bc.chain], indent=2))
