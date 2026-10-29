// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Doctor {
    string public name;
    string public specialization;
    uint public fee;
    address public immutable owner;

    constructor(string memory _name, string memory _spec, uint _fee) {
        name = _name; specialization = _spec; fee = _fee; owner = msg.sender;
    }
}

contract Hospital is Doctor {
    struct Booking { address patient; uint paid; }
    mapping(uint => Booking) public bookings;      // slot (unix time) => booking

    event AppointmentBooked(address indexed patient, uint slot, uint paid);
    event AppointmentCancelled(address indexed patient, uint slot, uint refund);

    constructor(string memory _name, string memory _spec, uint _fee) Doctor(_name, _spec, _fee) {}

    function bookAppointment(uint slot) external payable {
        require(slot > block.timestamp, "Slot in the past");
        require(bookings[slot].patient == address(0), "Slot taken");
        require(msg.value == fee, "Wrong fee");
        bookings[slot] = Booking(msg.sender, msg.value);
        emit AppointmentBooked(msg.sender, slot, msg.value);
    }

    function cancelAppointment(uint slot) external {
        Booking memory b = bookings[slot];
        require(b.patient == msg.sender, "Not your booking");
        require(slot > block.timestamp, "Slot already passed");
        uint refund = slot - block.timestamp >= 1 days ? b.paid : b.paid / 2;   // full refund if 1+ day away, else 50%
        delete bookings[slot];
        (bool ok, ) = msg.sender.call{value: refund}("");
        require(ok, "Refund failed");
        emit AppointmentCancelled(msg.sender, slot, refund);
    }

    function updateFee(uint _fee) external {
        require(msg.sender == owner, "Only owner");
        fee = _fee;
    }
}
