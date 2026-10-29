// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InventoryManagement {
	address public owner;
	uint256 public nextProductId;

	struct Product {
		string name;
		uint256 price;
		uint256 quantity;
		bool exists;
	}

	mapping(uint256 => Product) private products;

	event ProductAdded(uint256 indexed productId, string name, uint256 price, uint256 quantity);
	event StockUpdated(uint256 indexed productId, uint256 quantity);
	event ProductRemoved(uint256 indexed productId);

	modifier onlyOwner() {
		require(msg.sender == owner, "Only the owner can perform this action");
		_;
	}

	constructor() {
		owner = msg.sender;
	}

	function addProduct(string calldata name, uint256 price, uint256 quantity)
		external
		onlyOwner
		returns (uint256 productId)
	{
		require(bytes(name).length > 0, "Product name is required");
		require(price > 0, "Price must be greater than 0");

		productId = nextProductId++;
		products[productId] = Product(name, price, quantity, true);
		emit ProductAdded(productId, name, price, quantity);
	}

	function updateStock(uint256 productId, uint256 quantity) external onlyOwner {
		require(products[productId].exists, "Product does not exist");

		products[productId].quantity = quantity;
		emit StockUpdated(productId, quantity);
	}

	function updatePrice(uint256 productId, uint256 price) external onlyOwner {
		require(products[productId].exists, "Product does not exist");
		require(price > 0, "Price must be greater than 0");

		products[productId].price = price;
	}

	function removeProduct(uint256 productId) external onlyOwner {
		require(products[productId].exists, "Product does not exist");

		delete products[productId];
		emit ProductRemoved(productId);
	}

	function getProduct(uint256 productId)
		external
		view
		returns (string memory name, uint256 price, uint256 quantity, bool exists)
	{
		Product memory product = products[productId];
		return (product.name, product.price, product.quantity, product.exists);
	}
}
