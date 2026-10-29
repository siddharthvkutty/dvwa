// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract voting {
    mapping(string => uint) public ct;       // votes per candidate
    mapping(address => bool) public voters;  // who has voted
    mapping(string => bool) isC;             // valid candidate names
    string[] public cn;                      // candidate list

    constructor(string[] memory cdn) {
        cn = cdn;
        for (uint i; i < cdn.length; i++) isC[cdn[i]] = true;
    }
    function vote(string memory c) public {
        require(!voters[msg.sender], "You have already voted.");
        require(isC[c], "Candidate does not exist.");
        ct[c]++;
        voters[msg.sender] = true;
    }
    function getWinner() public view returns (string memory w) {
        uint t;
        for (uint i; i < cn.length; i++) if (ct[cn[i]] > t) { t = ct[cn[i]]; w = cn[i]; }
    }
}
