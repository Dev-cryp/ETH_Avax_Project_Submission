# Metacrafters Project Submission: ERC20 Token Contract

This is a ERC20 token smart contract built using OpenZeppelin's ERC20 implementation. The contract allows minting and burning of tokens, with an initial supply allocated to the contract deployer.

## Features
- **Minting:** New tokens can be created by calling the `mint` function, which allows an authorized user to specify the recipient and the amount.
- **Burning:** Users can destroy (burn) their own tokens by calling the `burn` function, which reduces the total supply.
- **Initial Supply:** Upon deployment, 1,000,000 tokens are automatically minted and assigned to the deployer.

## Contract Details

- **Solidity Version:** 0.8.26
- **License:** MIT
- **Dependencies:** OpenZeppelin ERC20 Library

## Contract Explanation 

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Cust_ERC20 is ERC20 {
    
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

 
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

   
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}
```

### Constructor
```solidity
constructor(string memory name, string memory symbol) ERC20(name, symbol)
```
- Initializes the token with a name and symbol provided during deployment.
- Mints an initial supply of 1,000,000 tokens to the deployer.

### `mint(address to, uint256 amount)`
- Allows minting of new tokens.
- Only callable by authorized users (for now, public).
- Parameters:
  - `to`: The address that will receive the minted tokens.
  - `amount`: The number of tokens to be minted.

### `burn(uint256 amount)`
- Allows users to burn their own tokens, reducing the total supply.
- Parameters:
  - `amount`: The number of tokens to be burned.

## Getting Started

### Prerequisites
- Solidity 0.8.26 or compatible version
- Node.js and npm (for local development)
- Truffle/Hardhat (for deployment)
- OpenZeppelin Contracts

### Installation

1. Clone the repository:
   ```bash
   git clone <repository_url>
   ```
2. Install the required dependencies:
   ```bash
   npm install @openzeppelin/contracts
   ```

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
