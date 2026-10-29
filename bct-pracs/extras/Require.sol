// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Require {
    function requireExample(uint age) public pure returns (string memory) {
        require(age >= 18, "You are not Eligible.");
        return "You are Eligible.";
    }
}