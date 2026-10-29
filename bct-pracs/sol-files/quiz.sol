// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Quiz {
    struct Question { string Qtext; string CA; }   // question text, correct answer
    Question[] public q;
    uint public tc;                                // total correct
    uint public tw;                                // total wrong
    event AnswerEv(string qu, string uans, bool isc);

    function addQ(string memory qt, string memory cans) public { q.push(Question(qt, cans)); }
    function ansQ(uint i, string memory uans) public {
        require(i < q.length, "Invalid Question Index");
        bool ok = keccak256(bytes(uans)) == keccak256(bytes(q[i].CA));   // strings can't be compared with ==
        if (ok) tc++; else tw++;
        emit AnswerEv(q[i].Qtext, uans, ok);
    }
    function getCAns() public view returns (uint) { return tc; }
}
