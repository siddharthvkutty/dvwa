const Blockchain = require("./happy");

const bc = new Blockchain();
bc.checkHappy(24);
bc.checkHappy(13);
bc.checkHappy(19);
bc.display();
