// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Quiz {
    struct Question { string Qtext; string[4] O; uint8 cO; }   // text, 4 options, correct option index
    Question[] public q;
    uint public tc;
    uint public tw;
    event AnswerRes(string Qtext, string ans, bool isc);

    function addQ(string memory _q, string[4] memory _O, uint8 _cO) public {
        require(_cO < 4, "Invalid option");
        q.push(Question(_q, _O, _cO));
    }
    function ansQ(uint i, uint8 sO) public {
        require(i < q.length, "Invalid question");
        require(sO < 4, "Invalid option");
        bool isc = sO == q[i].cO;
        if (isc) tc++; else tw++;
        emit AnswerRes(q[i].Qtext, q[i].O[sO], isc);
    }
    function getQ(uint i) public view returns (string memory, string[4] memory, uint8) {
        require(i < q.length, "Invalid question");
        return (q[i].Qtext, q[i].O, q[i].cO);
    }
    function getS() public view returns (uint cor, uint wro) { return (tc, tw); }
}
