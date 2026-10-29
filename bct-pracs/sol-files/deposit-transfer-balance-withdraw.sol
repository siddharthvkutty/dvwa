// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract SimpleBank {
    mapping(address => uint) public balance;
    function deposit() public payable { balance[msg.sender] += msg.value; }
    function transfer(address to, uint amt) public {
        require(balance[msg.sender] >= amt, "Insufficient balance");
        balance[msg.sender] -= amt;
        balance[to] += amt;
    }
    function showBalance() public view returns (uint) { return balance[msg.sender]; }
    function withdraw(uint amt) public {
        require(balance[msg.sender] >= amt, "Insufficient balance");
        balance[msg.sender] -= amt;
        payable(msg.sender).transfer(amt);
    }
}
