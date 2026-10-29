// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Bank {
    mapping(address => uint) public balance;

    function deposit() public payable { balance[msg.sender] += msg.value; }

    function withdraw(uint amount) public {
        require(balance[msg.sender] >= amount, "Insufficient Balance");
        balance[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
    function transfer(address receiver, uint amount) public {
        require(balance[msg.sender] >= amount, "Insufficient Balance");
        balance[msg.sender] -= amount;
        balance[receiver] += amount;
    }
    function showBalance() public view returns (uint) { return balance[msg.sender]; }
}
