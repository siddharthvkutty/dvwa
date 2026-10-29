// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmployeeSalary {
	address public owner;

	struct SalaryDetails {
		uint256 basicSalary;
		uint256 allowances;
		uint256 deductions;
		bool exists;
	}

	mapping(address => SalaryDetails) private employeeSalaries;

	event SalaryUpdated(address indexed employee, uint256 basicSalary, uint256 allowances, uint256 deductions);

	modifier onlyOwner() {
		require(msg.sender == owner, "Only the owner can perform this action");
		_;
	}

	constructor() {
		owner = msg.sender;
	}

	function setSalary(
		address employee,
		uint256 basicSalary,
		uint256 allowances,
		uint256 deductions
	) external onlyOwner {
		require(employee != address(0), "Invalid employee address");
		require(basicSalary + allowances >= deductions, "Deductions exceed salary");

		employeeSalaries[employee] = SalaryDetails(basicSalary, allowances, deductions, true);
		emit SalaryUpdated(employee, basicSalary, allowances, deductions);
	}

	function calculateSalary(address employee) external view returns (uint256) {
		SalaryDetails memory salary = employeeSalaries[employee];
		require(salary.exists, "Employee salary does not exist");

		return salary.basicSalary + salary.allowances - salary.deductions;
	}

	function getSalaryDetails(address employee)
		external
		view
		returns (uint256 basicSalary, uint256 allowances, uint256 deductions, bool exists)
	{
		SalaryDetails memory salary = employeeSalaries[employee];
		return (salary.basicSalary, salary.allowances, salary.deductions, salary.exists);
	}
}
