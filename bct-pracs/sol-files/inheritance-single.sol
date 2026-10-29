// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Vehicle {
    string vehTyp;
    string vehNum;
    constructor(string memory typ, string memory num) { vehTyp = typ; vehNum = num; }
    function display() public view returns (string memory) { return vehTyp; }
}

contract Car is Vehicle {
    string color;
    string brand;
    constructor(string memory typ, string memory num, string memory col, string memory bnd) Vehicle(typ, num) {
        color = col;
        brand = bnd;
    }
    function displayCar() public view returns (string memory) { return brand; }
}
