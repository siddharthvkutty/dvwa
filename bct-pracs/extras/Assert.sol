// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Assert {
    uint public total;
    function assertExample(uint value) external returns (string memory) {
        require(value > 0, "Must add value greater than zero");
        uint previousTotal = total;
        total += value;
        assert(total > previousTotal);
        return "Value added successfully";
    }
}