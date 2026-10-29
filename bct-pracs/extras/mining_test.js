const{Block,Blockchain} = require("./pal");
let sm = new Blockchain();

console.log('Developed by Aditya');
sm.addBlock(new Block(1, Date.now(), 242));
sm.addBlock(new Block(2, Date.now(), 67));
sm.addBlock(new Block(3, Date.now(), 121));
console.log(JSON.stringify(sm, null, 3));

const isValid = sm.validateChain();
console.log(`Is the blockchain valid? ${isValid}`);

// const mine = sm.getCBlock().mineBlock(1);
// console.log(`Mined block: ${JSON.stringify(mine, null, 3)}`);