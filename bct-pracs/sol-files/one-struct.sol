// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract studInfo {
    struct student { int id; string name; string addres; int age; uint[] marks; }
    student s;

    function setValue(int i, string memory n, string memory a, int ag, uint[] memory m) public {
        s = student(i, n, a, ag, m);
    }
    function getName() public view returns (string memory) { return s.name; }
    function getGrade() public view returns (string memory) {
        uint sum;
        for (uint i; i < s.marks.length; i++) sum += s.marks[i];
        uint avg = sum / s.marks.length;
        if (avg >= 90) return "A+";
        if (avg >= 80) return "A";
        if (avg >= 70) return "B";
        if (avg >= 60) return "C";
        if (avg >= 50) return "D";
        return "F";
    }
}
