const c = require('crypto');

class Block{
    constructor(i,t,n,nonce,ph=""){
        this.i = i;
        this.t = t;
        this.ph = ph;
        this.n = n;
        this.nonce = nonce;
        this.pal = this.checkPalindrome(n);
        this.h = this.calHash();
    };

    calHash(){
        return c.createHash('sha256').update(this.i+this.t+this.pal+this.ph+this.nonce).digest('hex');
    };

    checkPalindrome(n){
        const str = n.toString();
        const reversed = str.split('').reverse().join('');
        return str === reversed;
    };

    mineBlock(difficulty){
        let target = "0".repeat(difficulty);
        while(this.h.substring(0,difficulty) !== target){
            this.nonce++;
            this.h = this.calHash();
        };
    };
};

class Blockchain{
    constructor(){
        this.chain = [this.createGBlock()];
    };

    createGBlock(){
        return new Block(0, Date.now(), 0, "");
    };

    getCBlock(){
        return this.chain[this.chain.length-1];
    };

    addBlock(b){
        b.ph = this.getCBlock().h;
        b.h = b.calHash();
        if (b.pal) {
            this.chain.push(b);
        };
    };

    validateChain(){
        for(let i = 1; i < this.chain.length; i++){
            const currentBlock = this.chain[i];
            const previousBlock = this.chain[i - 1];

            if(currentBlock.h !== currentBlock.calHash()){
                return false;
            };

            if(currentBlock.ph !== previousBlock.h){
                return false;
            };
        };
        return true;
    };
};

module.exports.Block = Block;
module.exports.Blockchain = Blockchain;