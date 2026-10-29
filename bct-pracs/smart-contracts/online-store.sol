// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract product {
    uint productId;
    string productName;
    uint price;
    uint stock;

    constructor(uint _id, string memory _name, uint _price, uint _stock) {
        productId = _id; productName = _name; price = _price; stock = _stock;
    }
    function displayProduct() public view returns (uint, string memory, uint, uint) {
        return (productId, productName, price, stock);
    }
}

contract onlineStore is product {
    constructor(uint _id, string memory _name, uint _price, uint _stock) product(_id, _name, _price, _stock) {}

    function purchase(uint q) public payable {
        require(stock >= q, "Product out of stock");
        require(msg.value == q * price, "Wrong Payment");
        stock -= q;
    }
}
