// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Voting {
    struct Candidate { uint256 id; string name; uint256 voteCount; }

    address public owner;
    uint256 public candidateCount;
    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public hasVoted;

    event CandidateAdded(uint256 id, string name);
    event VoteCast(address voter, uint256 candidateId);

    constructor() { owner = msg.sender; }

    function addCandidate(string memory _name) public {
        require(msg.sender == owner, "Only owner");
        require(bytes(_name).length > 0, "Name required");
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
        emit CandidateAdded(candidateCount, _name);
    }

    function vote(uint256 _id) public {
        require(!hasVoted[msg.sender], "Already voted");
        require(_id > 0 && _id <= candidateCount, "Invalid candidate");
        hasVoted[msg.sender] = true;
        candidates[_id].voteCount++;
        emit VoteCast(msg.sender, _id);
    }

    function getCandidate(uint256 _id) public view returns (uint256, string memory, uint256) {
        Candidate memory c = candidates[_id];
        return (c.id, c.name, c.voteCount);
    }
}
