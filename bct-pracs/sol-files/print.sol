// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MessageContract {
    string public ms = "Hello MSc CS Students";
    function setMessage(string memory nm) public { ms = nm; }
}
