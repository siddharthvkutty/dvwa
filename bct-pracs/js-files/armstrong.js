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

    checkArmstrong(n) {
        const power = String(n).length;
        const total = String(n)
            .split("")
            .reduce((s, d) => s + Number(d) ** power, 0);
        if (total === n) this.add({ number: n, armstrong: true }); // only Armstrong numbers are added
    }
}

module.exports = Blockchain;
