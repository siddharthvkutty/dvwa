// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Palindrome {
    function IsPalindrome(int num) public pure returns (bool) {
        if (num < 10) return true;
        int temporary = num;
        int reversed;
        for (; num > 0; num /= 10) reversed = reversed * 10 + num % 10;
        return temporary == reversed;
    }
}
