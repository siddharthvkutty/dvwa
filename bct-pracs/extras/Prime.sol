// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Prime {
    function isPrime(int number) public pure returns (string memory) {
        if (number <= 1) {
            return "Not Prime";
        }
        for (int i = 2; i * i <= number; i++) {
            if (number % i == 0) {
                return "Not Prime";
            }
        }
        return "Prime";
    }
}