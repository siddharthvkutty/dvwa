// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vehicle {
    string public vehicleRegistration;
    string public vehicleBrand;
    uint public vehicleRent;          // rent per day (wei)

    constructor(string memory _reg, string memory _brand, uint _rent) {
        vehicleRegistration = _reg; vehicleBrand = _brand; vehicleRent = _rent;
    }
}

contract CarRental is Vehicle {
    address public renter;
    bool public available = true;
    uint public dueTime;

    event VehicleRented(address indexed renter, uint rentalDays, uint amount);
    event VehicleReturned(address indexed renter, uint penalty);

    constructor(string memory _reg, string memory _brand, uint _rent) Vehicle(_reg, _brand, _rent) {}

    function rentVehicle(uint _days) public payable {
        require(available, "Vehicle not available");
        require(_days > 0 && msg.value >= vehicleRent * _days, "Insufficient payment");
        (available, renter, dueTime) = (false, msg.sender, block.timestamp + _days * 1 minutes);   // 1 day = 1 minute for testing
        emit VehicleRented(msg.sender, _days, msg.value);
    }

    function calculatePenalty() public view returns (uint) {
        if (available || block.timestamp <= dueTime) return 0;
        return ((block.timestamp - dueTime) / 1 minutes + 1) * vehicleRent / 2;   // half the rent per late day
    }

    function returnVehicle() public payable {
        require(!available && msg.sender == renter, "Not the renter");
        uint penalty = calculatePenalty();
        require(msg.value >= penalty, "Pay the penalty");
        available = true;
        emit VehicleReturned(msg.sender, penalty);
    }
}
