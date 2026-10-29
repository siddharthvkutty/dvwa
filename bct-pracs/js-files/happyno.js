const crypto = require("crypto");

class Block {
    constructor(index, data, prevHash = "") {
        this.index = index;
        this.timestamp = Date.now();
        this.data = data;
        this.prevHash = prevHash;
        const text = `${index}${this.timestamp}${JSON.stringify(data)}${prevHash}`;
        this.hash = crypto.createHash("sha256").update(text).digest("hex");
    }
}

class Blockchain {
    constructor() {
        this.chain = [new Block(0, "Genesis")];
    }

    add(data) {
        const prev = this.chain[this.chain.length - 1];
        this.chain.push(new Block(this.chain.length, data, prev.hash));
    }

    display() {
        for (const b of this.chain) {
            console.log("Block:", b.index);
            console.log("Data:", b.data);
            console.log("Hash:", b.hash);
            console.log("Previous Hash:", b.prevHash);
            console.log();
        }
    }

    checkHappy(n) {
        const start = n,
            seen = new Set();
        while (n !== 1 && !seen.has(n)) {
            seen.add(n);
            n = String(n)
                .split("")
                .reduce((s, d) => s + d * d, 0);
        }
        this.add({ number: start, happy: n === 1 });
    }
}

module.exports = Blockchain;
