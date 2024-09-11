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