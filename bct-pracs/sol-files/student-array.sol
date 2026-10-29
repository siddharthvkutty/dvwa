// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract StudentCount {
    string[] public StudentArray;
    function addStudent(string memory name) public { StudentArray.push(name); }
    function getCount() public view returns (uint) { return StudentArray.length; }
}
