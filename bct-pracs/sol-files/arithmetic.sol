// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AdditionContract {
    function AddNumbers(int n1, int n2) public pure returns (int) { return n1 + n2; }
    function SubNumbers(int n1, int n2) public pure returns (int) { return n1 - n2; }
    function MultiplyNumbers(int n1, int n2) public pure returns (int) { return n1 * n2; }
    function DivideNumbers(int n1, int n2) public pure returns (int) { return n1 / n2; }
}
