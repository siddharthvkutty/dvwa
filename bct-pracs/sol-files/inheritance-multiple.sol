// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract StudentData {
    string name;
    string rollNo;
    constructor(string memory _name, string memory _rollNo) { name = _name; rollNo = _rollNo; }
    function displayStudent() public view returns (string memory) { return name; }
    function displayRollNo() public view returns (string memory) { return rollNo; }
}

contract Marks {
    uint public marks;
    constructor(uint m) { marks = m; }
    function displayMarks() public view returns (uint) { return marks; }
}

contract Grade is StudentData, Marks {
    constructor(string memory _name, string memory _rollNo, uint m) StudentData(_name, _rollNo) Marks(m) {}

    function calculateGrade() public view returns (string memory) {
        if (marks >= 80) return "O";
        if (marks >= 70) return "A";
        if (marks >= 60) return "B";
        if (marks >= 50) return "C";
        return "F";
    }
    function displayGrade() public view returns (string memory) {
        return string.concat("Name: ", displayStudent(), " Roll No: ", displayRollNo(), " Grade: ", calculateGrade());
    }
}
