const Blockchain = require("./arm");

const bc = new Blockchain();
bc.checkArmstrong(24);
bc.checkArmstrong(123);
bc.checkArmstrong(153);
bc.checkArmstrong(407);
bc.display();
