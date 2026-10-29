// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Revert {
    function testRevert(uint age) public pure returns (string memory) {
        if (age <= 18 || age > 100) {
            revert("You are not Eligible.");
        }
        return "You are Eligible.";
    }
}