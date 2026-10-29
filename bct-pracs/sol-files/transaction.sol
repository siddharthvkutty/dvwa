// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract BankAccount {
    struct User { int accNo; string name; uint balance; }
    User u;

    function createAccount(int acc, string memory n, uint bal) public { u = User(acc, n, bal); }
    function deposit(uint amount) public { u.balance += amount; }
    function withdraw(uint amount) public returns (string memory) {
        if (u.balance < amount) return "Insufficient Balance";
        u.balance -= amount;
        return "Transaction Successful";
    }
    function getBalance() public view returns (uint) { return u.balance; }
}
