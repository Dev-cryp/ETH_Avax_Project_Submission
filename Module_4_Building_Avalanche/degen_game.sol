// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

contract DegenGaming {

    // State Variable 

    address public owner;
    string public name = "Degen Gaming";
    string public symbol = "Degen";
    uint8 public decimals = 10;
    uint256 public totalSupply = 0;

    // Mapping

    mapping(uint256 => string) public ItemName;
    mapping(uint256 => uint256) public Itemprice;
    mapping(address => uint256) public balance;
    mapping(address => mapping(uint256 => bool)) public redeemedItems;
    mapping(address => uint256) public redeemedItemCount;

    // Use 'Constructor' to initialize values

    constructor() {
        owner = msg.sender;

        // Initialize some sample items in the store
        GameStore(0, "Bag", 500);
        GameStore(1, "Tablet", 1000);
        GameStore(2, "Air Mac", 20000);
        GameStore(3, "Monkey NFT", 25000);
    }

    // Modifier to Control Access

    modifier onlyOwner() {
        require(msg.sender == owner, "This function can only be used by the owner.");
        _;
    }

    // Taking Record of Transactions

    event Mint(address indexed to, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Redeem(address indexed user, string itemName);

    
    // Store Function 

    function GameStore(uint256 itemId, string memory _itemName, uint256 _itemPrice) public onlyOwner {
        ItemName[itemId] = _itemName;
        Itemprice[itemId] = _itemPrice;
    }

    // Mint Functions

    function mint(address to, uint256 amount) external onlyOwner {
        totalSupply += amount;
        balance[to] += amount;
        emit Mint(to, amount);
        emit Transfer(address(0), to, amount);
    }
    
    // Get Balance

    function balanceOf(address accountAddress) external view returns (uint256) {
        return balance[accountAddress];
    }

    // Transfer Token

    function transfer(address receiver, uint256 amount) external returns (bool) {
        require(balance[msg.sender] >= amount, "Insufficient balance.");
        balance[msg.sender] -= amount;
        balance[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    // Burn Function 

    function burn(uint256 amount) external {
        require(amount <= balance[msg.sender], "Insufficient balance.");
        balance[msg.sender] -= amount;
        totalSupply -= amount;
        emit Burn(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }

    // Redeem Item from store

    function Itemredeem(uint256 accId) external returns (string memory) {
        require(Itemprice[accId] > 0, "Invalid item ID.");
        uint256 redemptionAmount = Itemprice[accId];
        require(balance[msg.sender] >= redemptionAmount, "Insufficient balance to redeem the item.");

        balance[msg.sender] -= redemptionAmount;
        redeemedItems[msg.sender][accId] = true;
        redeemedItemCount[msg.sender]++;
        emit Redeem(msg.sender, ItemName[accId]);

        return ItemName[accId];
    }

    // Get Redeemed Item Information

    function getRedeemedItemCount(address user) external view returns (uint256) {
        return redeemedItemCount[user];
    }
}