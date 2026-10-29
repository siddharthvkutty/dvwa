const Blockchain = require("./kaprekar");

const bc = new Blockchain();
bc.checkKaprekar(45);
bc.checkKaprekar(10);
bc.checkKaprekar(297);
bc.display();
