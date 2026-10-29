// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentFeePayment {
    address public owner = msg.sender;
    uint256 public totalFeesCollected;
    mapping(address => uint256) private feesPaid;

    function payFee() public payable {
        require(msg.value > 0, "Fee must be greater than 0");
        feesPaid[msg.sender] += msg.value;
        totalFeesCollected += msg.value;
    }
    function viewMyFee() public view returns (uint256) { return feesPaid[msg.sender]; }
    function viewTotalFeesCollected() public view returns (uint256) { return totalFeesCollected; }
    function getContractBalance() public view returns (uint256) { return address(this).balance; }
}
