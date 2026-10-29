// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Prime {
    function isPrime(uint256 num) public pure returns (string memory) {
        if (num <= 1) return "Please enter a value above one!";
        for (uint256 i = 2; i * i <= num; i++)
            if (num % i == 0) return "The entered number is not a prime number.";
        return "The entered number is a prime number.";
    }
}
