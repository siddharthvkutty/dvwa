const Blockchain = require("./prime");

const bc = new Blockchain();
bc.checkPrime(6);
bc.checkPrime(7);
bc.checkPrime(11);
bc.display();
