// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ElectricityBill {
    uint256 public constant FREE_UNITS = 100;
    uint256 public constant RATE_101_TO_200 = 2;
    uint256 public constant RATE_201_TO_300 = 4;
    uint256 public constant RATE_301_TO_400 = 6;
    uint256 public constant RATE_401_TO_500 = 8;
    uint256 public constant RATE_ABOVE_500 = 10;

    struct Bill {
        uint256 unitsConsumed;
        uint256 chargeableUnits;
        uint256 amount;
    }

    mapping(address => Bill) private bills;

    event BillGenerated(
        address indexed user,
        uint256 unitsConsumed,
        uint256 chargeableUnits,
        uint256 amount
    );

    function generateBill(uint256 unitsConsumed) external returns (uint256 amount) {
        uint256 chargeableUnits = unitsConsumed > FREE_UNITS
            ? unitsConsumed - FREE_UNITS
            : 0;

        amount = _calculateBill(unitsConsumed);
        bills[msg.sender] = Bill({
            unitsConsumed: unitsConsumed,
            chargeableUnits: chargeableUnits,
            amount: amount
        });

        emit BillGenerated(msg.sender, unitsConsumed, chargeableUnits, amount);
    }

    function getBill(address user) external view returns (Bill memory) {
        return bills[user];
    }

    function calculateBill(uint256 unitsConsumed) external pure returns (uint256) {
        return _calculateBill(unitsConsumed);
    }

    function _calculateBill(uint256 unitsConsumed) private pure returns (uint256 amount) {
        if (unitsConsumed <= FREE_UNITS) {
            return 0;
        }

        if (unitsConsumed <= 200) {
            return (unitsConsumed - 100) * RATE_101_TO_200;
        }

        amount = 100 * RATE_101_TO_200;
        if (unitsConsumed <= 300) {
            return amount + (unitsConsumed - 200) * RATE_201_TO_300;
        }

        amount += 100 * RATE_201_TO_300;
        if (unitsConsumed <= 400) {
            return amount + (unitsConsumed - 300) * RATE_301_TO_400;
        }

        amount += 100 * RATE_301_TO_400;
        if (unitsConsumed <= 500) {
            return amount + (unitsConsumed - 400) * RATE_401_TO_500;
        }

        return amount + 100 * RATE_401_TO_500
            + (unitsConsumed - 500) * RATE_ABOVE_500;
    }
}
