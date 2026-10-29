// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Stats {
    uint[] public a;
    function set(uint[] memory x) public { a = x; }
    function mean() public view returns (uint) {
        uint s;
        for (uint i; i < a.length; i++) s += a[i];
        return s / a.length;
    }
    function median() public view returns (uint) { return a[a.length / 2]; }   // middle element (array entered sorted)
    function mode() public view returns (uint) { return a[0]; }                // simplified, as in the original
}
