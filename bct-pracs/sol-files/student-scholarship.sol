// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract student {
    struct Details { uint id; string name; string course; uint marks; bool eligible; }
    mapping(uint => Details) public students;
    mapping(uint => bool) public isRegistered;
    address public owner = msg.sender;
    event StudentAdded(uint id, string name);

    modifier onlyOwner() {
        require(msg.sender == owner, "This Action can only be performed by the Owner!");
        _;
    }
    function addStudent(uint id, string memory name, string memory course, uint marks) public onlyOwner {
        require(!isRegistered[id], "Student ID already exists!");
        students[id] = Details(id, name, course, marks, marks > 75);   // eligible only if marks > 75
        isRegistered[id] = true;
        emit StudentAdded(id, name);
    }
    function getStudent(uint id) public view returns (uint, string memory, string memory, uint, bool) {
        require(isRegistered[id], "Student Record not Found!");
        Details memory s = students[id];
        return (s.id, s.name, s.course, s.marks, s.eligible);
    }
}

contract scholarship is student {
    uint public scholarshipAmount = 4;           // wei, fixed amount per student
    mapping(uint => bool) public hasClaimed;
    event FundsDeposited(uint amount);
    event ScholarshipClaimed(uint id, address to);

    function depositFunds() public payable onlyOwner { emit FundsDeposited(msg.value); }

    function claimScholarship(uint id) public {
        require(isRegistered[id], "Student Record not found!");
        require(students[id].eligible, "Student Not Eligible!");
        require(!hasClaimed[id], "Scholarship Already Claimed!");
        require(address(this).balance >= scholarshipAmount, "Insufficient Funds");
        hasClaimed[id] = true;
        payable(msg.sender).transfer(scholarshipAmount);
        emit ScholarshipClaimed(id, msg.sender);
    }
    function getTotalFunds() public view returns (uint) { return address(this).balance; }
}
