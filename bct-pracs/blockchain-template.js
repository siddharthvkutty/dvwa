const crypto = require('crypto');

class Block {
    constructor(i, data, ph = "") {
        this.i = i;
        this.t = Date.now();
        this.data = data;
        this.ph = ph;
        this.h = crypto.createHash('sha256').update(`${this.i}${this.t}${JSON.stringify(this.data)}${this.ph}`).digest('hex');
    }
}

class Blockchain {
    constructor() {
        this.chain = [new Block(0, "Genesis")];
    }

    add(data) {
        this.chain.push(new Block(this.chain.length, data, this.chain[this.chain.length - 1].h));
    }

    // Define your custom functions here:
    myCustomFunction(value) {
        this.add(value);
    }
}

const bc = new Blockchain();
bc.myCustomFunction("Hello Blockchain");
console.log(JSON.stringify(bc.chain, null, 2));
