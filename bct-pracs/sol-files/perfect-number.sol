// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PerfectNumber {
    function isPerfect(uint num) public pure returns (string memory) {
        if (num <= 1) return "enter a number greater than 1";
        uint sum = 1;                                   // 1 divides every number
        for (uint i = 2; i <= num / 2; i++) if (num % i == 0) sum += i;
        if (sum == num) return "It is a perfect number"; return "It is not a perfect number";
    }
}
