# Event Management DApp - Module 2 Smart Contact Management

## Overview

This repository contains the code for a decentralized application (DApp) that facilitates event management through Ethereum smart contracts. Users can deposit Ether, purchase event tickets, transfer tickets, and request refunds for tickets they own. The DApp is developed using Solidity for the backend smart contract and React for the frontend, with Hardhat as the development environment.

## Features

- **Ticket Purchase**: Users can purchase tickets for a specified event using Ether.
- **Ticket Transfer**: Users can transfer purchased tickets to another account.
- **Ticket Refund**: Event owners can refund tickets for users.
- **Balance Management**: Users can deposit and withdraw Ether from their balances.
- **Owner Privileges**: Only the contract owner can change ticket prices and refund tickets.

## Smart Contract: `EventBooking`

### Contract Explanation

The `EventBooking` smart contract facilitates the core functionality of the event management DApp. Below is a detailed explanation of the contract:

### 1. **Variables**:
   - `owner`: The address of the owner (deployer) of the contract. Only the owner has the authority to change ticket prices and issue refunds.
   - `contractBalance`: Tracks the total Ether balance within the contract.
   - `userBalances`: A mapping that tracks how much Ether each user has deposited into the contract.
   - `ticketsOwned`: A mapping that tracks how many tickets each user has purchased.
   - `eventName`: The name of the event for which the tickets are being sold.
   - `ticketPrice`: The price of a single ticket in Ether.
   - `totalTickets`: The total number of tickets available for the event.
   - `ticketsSold`: Tracks the number of tickets that have been sold.

### 2. **Modifiers**:
   - `onlyOwner()`: Ensures that only the contract owner can execute certain functions, such as changing the ticket price or issuing refunds.

### 3. **Events**:
   - `Deposit`: Emitted whenever a user deposits Ether into the contract.
   - `Withdraw`: Emitted whenever a user withdraws Ether from their balance.
   - `TicketPurchased`: Emitted when a user successfully purchases tickets.

### 4. **Constructor**:
   The contract constructor initializes the event details such as the event name, ticket price, and the total number of tickets. The constructor also sets the contract owner and initial contract balance.

```solidity
constructor(
    uint initBalance, 
    string memory _eventName, 
    uint256 _ticketPrice, 
    uint256 _totalTickets
) payable {
    owner = payable(msg.sender);
    contractBalance = initBalance;
    eventName = _eventName;
    ticketPrice = _ticketPrice;
    totalTickets = _totalTickets;
}
```

### 5. **Functions**:

#### `deposit(uint256 _amount)`:
Allows users to deposit Ether into the contract, which will be credited to their `userBalances`. 

```solidity
function deposit(uint256 _amount) public payable {
    require(_amount >= 0, "Incorrect Ether amount sent");
    
    userBalances[msg.sender] += _amount;
    contractBalance += _amount;
    emit Deposit(msg.sender, _amount);
}
```

#### `withdraw(uint256 _withdrawAmount)`:
Allows users to withdraw Ether from their balance, ensuring they have sufficient balance before performing the withdrawal.

```solidity
function withdraw(uint256 _withdrawAmount) public {
    require(userBalances[msg.sender] >= _withdrawAmount, "Insufficient balance to withdraw");
    ...
    emit Withdraw(msg.sender, _withdrawAmount);
}
```

#### `purchaseTickets(uint256 quantity)`:
Allows users to purchase tickets by deducting the equivalent Ether from their `userBalances`. It ensures that the user has enough balance and that the requested number of tickets is available.

```solidity
function purchaseTickets(uint256 quantity) public payable {
    uint256 totalCost = quantity * ticketPrice;
    require(userBalances[msg.sender] >= totalCost, "Insufficient balance to purchase tickets");
    require(ticketsSold + quantity <= totalTickets, "Not enough tickets available");
    ...
    emit TicketPurchased(msg.sender, quantity);
}
```

#### `refundTickets(address attendee, uint256 quantity)`:
Allows the contract owner to refund tickets for a user by crediting their balance. This function can only be called by the contract owner.

```solidity
function refundTickets(address attendee, uint256 quantity) public payable onlyOwner {
    require(ticketsOwned[attendee] >= quantity, "Attendee does not own enough tickets");
    ...
}
```

#### `transferTickets(address to, uint256 quantity)`:
Allows users to transfer tickets they own to another Ethereum address.

```solidity
function transferTickets(address to, uint256 quantity) public {
    require(ticketsOwned[msg.sender] >= quantity, "You do not own enough tickets");
    ...
}
```

#### `getAvailableTickets()`:
Returns the number of tickets that are still available for purchase.

```solidity
function getAvailableTickets() public view returns (uint256) {
    return totalTickets - ticketsSold;
}
```

#### `changeTicketPrice(uint256 newPrice)`:
Allows the owner to update the ticket price. Only the contract owner can perform this action.

```solidity
function changeTicketPrice(uint256 newPrice) public onlyOwner {
    require(newPrice > 0, "Price must be greater than zero");
    ticketPrice = newPrice;
}
```

## Frontend

The frontend is built using **React** and interacts with the Ethereum blockchain through **ethers.js**. It provides users with the following functionalities:
- **Deposit and Withdraw Ether**: Allows users to manage their balance.
- **View Available Tickets**: Users can check how many tickets are available.
- **Purchase Tickets**: Users can buy tickets if they have enough balance.
- **Transfer Tickets**: Allows users to send tickets to another Ethereum address.
- **Refund Tickets**: Lets the contract owner refund tickets to users.

## Setup and Deployment

### Prerequisites
- Node.js
- MetaMask extension for interacting with the blockchain.
- Ethereum development environment like Hardhat.

### Installation

1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd event-management-dapp
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Compile the smart contract using Hardhat:
   ```bash
   npx hardhat compile
   ```

4. Deploy the contract to a local network:
   ```bash
   npx hardhat run scripts/deploy.js --network localhost
   ```

5. Start the frontend development server:
   ```bash
   npm run dev
   ```

6. Interact with the DApp by connecting MetaMask.
