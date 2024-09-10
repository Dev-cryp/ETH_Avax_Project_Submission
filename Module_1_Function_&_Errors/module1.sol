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