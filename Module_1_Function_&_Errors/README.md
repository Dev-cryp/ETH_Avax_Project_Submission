# Subscription Contract

```markdown

## Overview

The `Subscription` contract is a smart contract designed for managing subscriptions with a fixed monthly fee. It allows users to subscribe by paying the required fee, provides methods to check subscription status, and calculates time-related metrics. The contract also includes functionality for the contract owner to withdraw accumulated funds.

## Features

- **Subscription Management**: Users can subscribe by paying the exact monthly fee.
- **Subscription Status**: Check if a user’s subscription is currently active.
- **Time Calculations**: Retrieve the number of days until the next payment or the days since the last payment.
- **Funds Withdrawal**: Allows the contract owner to withdraw the contract's balance.
```

## Contract Details

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Subscription {
    
    // '@info Struct data structure  
    struct Subscriber {
        uint lastPayment;
        uint nextDue;
    }

    // @info State Variable 
    mapping(address => Subscriber) public subscribers;
    address public owner;
    uint public monthlyFee;

 
    constructor(uint _monthlyFee) {
        owner = msg.sender;
        monthlyFee = _monthlyFee;
    }


    // Contract 'Main Function'

    function subscribe() external payable {
        require(msg.value == monthlyFee, "Incorrect fee."); 

        Subscriber storage subscriber = subscribers[msg.sender];

        
        assert(subscriber.nextDue < block.timestamp); 

        subscriber.lastPayment = block.timestamp;
        subscriber.nextDue = block.timestamp + 30 days;
    }

    function checkSubscription(address subscriber) public view returns (bool) {
        return subscribers[subscriber].nextDue > block.timestamp;
    }


    function getDaysUntilNextDue(address subscriber) public view returns (int) {
        Subscriber storage sub = subscribers[subscriber];

        if (sub.nextDue > block.timestamp) {
            return int((sub.nextDue - block.timestamp) / 1 days);
        } else {
            return 0;
        }
    }

    function getDaysSinceLastPayment(address subscriber) public view returns (int) {
        Subscriber storage sub = subscribers[subscriber];

        if (block.timestamp > sub.lastPayment) {
            return int((block.timestamp - sub.lastPayment) / 1 days); 
        } else {
            return 0; 
        }
    }

    // Withdraw Deposited Tokens 

    function withdrawFunds() external {
        require(msg.sender == owner, "Only the owner can withdraw.");

        uint balance = address(this).balance;
        require(balance > 0, "No funds to withdraw."); 

        payable(owner).transfer(balance); 
    }
}
```

### State Variables

- `mapping(address => Subscriber) public subscribers`: Maps user addresses to their subscription details.
- `address public owner`: Address of the contract owner.
- `uint public monthlyFee`: The fixed monthly subscription fee.

### Structs

- `struct Subscriber`: Contains subscription details for each user.
  - `uint lastPayment`: Timestamp of the last payment made by the subscriber.
  - `uint nextDue`: Timestamp when the next payment is due.

### Constructor

```solidity
constructor(uint _monthlyFee)
```

- Initializes the contract with a specified monthly fee.
- Sets the contract deployer as the owner.

### Functions

#### `subscribe`

```solidity
function subscribe() external payable
```

- Allows users to subscribe by sending the exact monthly fee.
- Requires the sent value to match the `monthlyFee`.
- Updates the subscription details with the current timestamp and sets the next payment due date.

#### `checkSubscription`

```solidity
function checkSubscription(address subscriber) public view returns (bool)
```

- Checks if the subscription for a given address is active.
- Returns `true` if the next due date is in the future; otherwise, returns `false`.

#### `getDaysUntilNextDue`

```solidity
function getDaysUntilNextDue(address subscriber) public view returns (int)
```

- Returns the number of days until the next payment is due.
- Returns `0` if the subscription is not active.

#### `getDaysSinceLastPayment`

```solidity
function getDaysSinceLastPayment(address subscriber) public view returns (int)
```

- Returns the number of days since the last payment was made.
- Returns `0` if the last payment timestamp is not set.

#### `withdrawFunds`

```solidity
function withdrawFunds() external
```

- Allows the contract owner to withdraw all funds from the contract.
- Requires the caller to be the owner of the contract.

## Error Handling

- **Incorrect Fee**: If the amount sent with the `subscribe` function does not match the `monthlyFee`, the transaction reverts with the message "Incorrect fee."
- **Subscription Not Due**: In the `subscribe` function, an `assert` statement ensures that the subscription is due before updating payment details.
- **Unauthorized Access**: The `withdrawFunds` function restricts access to only the contract owner.

## License

This contract is licensed under the MIT License. See the ([LICENSE](https://github.com/ethereum/solidity-examples/blob/master/LICENSE)) file for more information.

## Usage

1. **Deploy the Contract**: Deploy the `Subscription` contract with the desired monthly fee.
2. **Subscribe**: Call the `subscribe` function and send the exact monthly fee to create a subscription.
3. **Check Subscription Status**: Use `checkSubscription` to determine if a user’s subscription is still active.
4. **Get Time Metrics**: Use `getDaysUntilNextDue` and `getDaysSinceLastPayment` to retrieve time-related metrics.
5. **Withdraw Funds**: If you are the contract owner, call `withdrawFunds` to withdraw the contract balance.
