# Degen Gaming Token - ERC20 on Avalanche 

## Project Objective
The goal of this project is to create an ERC20 token and deploy it on the Avalanche network for **Degen Gaming**. The token will be used as a reward mechanism for players, allowing them to earn, transfer, and redeem tokens for in-game items. The smart contract includes the following functionality:

- **Minting new tokens**: Only the owner can mint new tokens and distribute them as rewards to players.
- **Transferring tokens**: Players can transfer tokens to other players.
- **Redeeming tokens**: Players can redeem tokens for in-game store items.
- **Checking token balance**: Players can view their token balance at any time.
- **Burning tokens**: Players can burn tokens they own that are no longer needed.

## Smart Contract Overview

```solidity
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
```

### Contract Details
- **Name**: Degen Gaming
- **Symbol**: Degen
- **Decimals**: 10
- **Total Supply**: Dynamically increases as tokens are minted.
  
### Functionality

1. **Minting Tokens**  
   The owner of the contract can mint new tokens and assign them to a specific player. This increases the total supply of tokens.

2. **Transferring Tokens**  
   Players can transfer tokens to other players as long as they have enough balance.

3. **Burning Tokens**  
   Players can burn tokens they no longer need, which decreases their balance and the total token supply.

4. **Redeeming Tokens for In-Game Items**  
   Players can use their tokens to redeem items from the in-game store. A set of predefined items is initialized with a price, and the player’s balance is deducted when they redeem an item.

5. **Checking Balance**  
   Players can check their token balance anytime by calling the `balanceOf` function.

### Store Items
The game store has predefined items available for purchase with tokens. The contract initializes the following items:
- **Bag**: 500 tokens
- **Tablet**: 1,000 tokens
- **Air Mac**: 20,000 tokens
- **Monkey NFT**: 25,000 tokens

## How to Deploy
1. Compile and deploy the `DegenGaming` contract on the Avalanche C-Chain.
2. Once deployed, use the contract's functions to mint tokens, transfer tokens, redeem items, and manage the token supply.

## How to Use
- **Minting Tokens**: Only the contract owner can call the `mint` function.
- **Transferring Tokens**: Players can call the `transfer` function to send tokens to another address.
- **Burning Tokens**: Call the `burn` function to destroy tokens from your balance.
- **Redeeming Items**: Call the `Itemredeem` function to redeem a specific item using its ID.
- **Check Balance**: Use `balanceOf` to view your token balance.
