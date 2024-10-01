// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

// Import OpenZeppelin Libraries
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract DegenGaming is ERC20 {

    // State Variables
    string private _name = "Degen Gaming";
    string private _symbol = "Degen";
    uint8 private _decimals = 10;
    address public owner;

    // Mapping for Store Items
    mapping(uint256 => string) public ItemName;
    mapping(uint256 => uint256) public Itemprice;
    mapping(address => mapping(uint256 => bool)) public redeemedItems;
    mapping(address => uint256) public redeemedItemCount;

    // Events for Redeeming Items
    event Redeem(address indexed user, string itemName);

    // Constructor to Initialize ERC20 and Sample Items in Store
    constructor() ERC20(_name, _symbol) {
        owner = msg.sender;
        // Initialize some sample items in the store
        GameStore(0, "Bag", 500);
        GameStore(1, "Tablet", 1000);
        GameStore(2, "Air Mac", 20000);
        GameStore(3, "Monkey NFT", 25000);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner Can Execute!");
        _;
    }

    // Mint Tokens (Only Owner)
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Burn Tokens (Anyone Can Burn Their Own Tokens)
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Store Function to Set Item Name and Price
    function GameStore(uint256 itemId, string memory _itemName, uint256 _itemPrice) public {
        ItemName[itemId] = _itemName;
        Itemprice[itemId] = _itemPrice;
    }

    // Redeem Item from Store
    function Itemredeem(uint256 accId) external returns (string memory) {
        require(Itemprice[accId] > 0, "Invalid item ID.");
        uint256 redemptionAmount = Itemprice[accId];
        require(balanceOf(msg.sender) >= redemptionAmount, "Insufficient balance to redeem the item.");

        _burn(msg.sender, redemptionAmount);
        redeemedItems[msg.sender][accId] = true;
        redeemedItemCount[msg.sender]++;
        emit Redeem(msg.sender, ItemName[accId]);

        return ItemName[accId];
    }

    // Get Redeemed Item Count
    function getRedeemedItemCount(address user) external view returns (uint256) {
        return redeemedItemCount[user];
    }
}
