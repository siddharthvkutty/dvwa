// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract payex {
    uint public b;
    function deposit() public payable { b += msg.value; }
    function transferE(address payable r) public payable {
        require(address(this).balance >= msg.value, "Insufficient balance");
        r.transfer(msg.value);
    }
}
