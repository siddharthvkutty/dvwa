// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PatientRegistry {
    struct Patient {
        uint256 id;
        string name;
        string homeAddress;
        uint8 age;
        uint16 weight;
        uint16 height;
        string preExistingConditions;
        string currentDisease;
    }

    mapping(uint256 => Patient) public patients;

    function registerPatient(
        uint256 id,
        string memory name,
        string memory homeAddress,
        uint8 age,
        uint16 weight,
        uint16 height,
        string memory preExistingConditions,
        string memory currentDisease
    ) public {
        patients[id] = Patient(
            id,
            name,
            homeAddress,
            age,
            weight,
            height,
            preExistingConditions,
            currentDisease
        );
    }

    function getPatient(uint256 id) public view returns (Patient memory) {
        return patients[id];
    }
}
