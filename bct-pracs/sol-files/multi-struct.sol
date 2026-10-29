// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract StudInfo {
    struct Student { int id; string name; string addr; int age; uint[] marks; }
    Student[] students;

    function addStudent(int i, string memory n, string memory a, int ag, uint[] memory m) public {
        students.push(Student(i, n, a, ag, m));
    }
    function totalStudents() public view returns (uint) { return students.length; }
    function allStudentDetails() public view returns (Student[] memory) { return students; }

    function getAllGrade() public view returns (string[] memory names, string[] memory grades) {
        names = new string[](students.length);
        grades = new string[](students.length);
        for (uint i; i < students.length; i++) {
            names[i] = students[i].name;
            uint sum;
            for (uint j; j < students[i].marks.length; j++) sum += students[i].marks[j];
            uint p = sum / students[i].marks.length;
            if (p >= 95) grades[i] = "Special Grade";
            else if (p >= 80) grades[i] = "Grade 1";
            else if (p >= 75) grades[i] = "Semi Grade 1";
            else grades[i] = "You are the Potential Man";
        }
    }
}
