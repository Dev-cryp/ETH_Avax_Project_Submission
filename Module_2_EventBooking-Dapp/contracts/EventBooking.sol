// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract EventBooking {
    // Owner and contract balance
    address payable public owner;
    uint256 public contractBalance;

    // Mapping to track balances of users and ticket ownership
    mapping(address => uint256) public userBalances;
    mapping(address => uint256) public ticketsOwned;

    // Event for deposit, withdrawal, and ticket purchase
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event TicketPurchased(address indexed buyer, uint256 quantity);

    // Event ticket management variables
    string public eventName;
    uint256 public ticketPrice;
    uint256 public totalTickets;
    uint256 public ticketsSold;

    // Constructor to initialize contract and event details
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

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Function to deposit Ether into the contract
    function deposit(uint256 _amount) public payable {
        require(_amount >= 0, "Incorrect Ether amount sent");
        
        userBalances[msg.sender] += _amount;
        contractBalance += _amount;
        emit Deposit(msg.sender, _amount);
    }

    // Custom error for insufficient balance
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public {
        require(userBalances[msg.sender] >= _withdrawAmount, "Insufficient balance to withdraw");

        uint _previousBalance = userBalances[msg.sender];
        userBalances[msg.sender] -= _withdrawAmount;
        contractBalance -= _withdrawAmount;


        assert(userBalances[msg.sender] == (_previousBalance - _withdrawAmount));
        emit Withdraw(msg.sender, _withdrawAmount);
    }

    // ---- Event Ticket Management Functions ----

    // Function to purchase tickets
    function purchaseTickets(uint256 quantity) public payable {
        uint256 totalCost = quantity * ticketPrice;
        require(userBalances[msg.sender] >= totalCost, "Insufficient balance to purchase tickets");
        require(ticketsSold + quantity <= totalTickets, "Not enough tickets available");

    
        ticketsOwned[msg.sender] += quantity;
        ticketsSold += quantity;
        userBalances[msg.sender] -= totalCost;
        emit TicketPurchased(msg.sender, quantity);
    }


    // Function to refund tickets (Only the owner can refund)
    function refundTickets(address attendee, uint256 quantity) public payable onlyOwner {
        require(ticketsOwned[attendee] >= quantity, "Attendee does not own enough tickets");

        ticketsOwned[attendee] -= quantity;
        ticketsSold -= quantity;
        userBalances[attendee] += quantity * ticketPrice;
    }

    // Function to transfer tickets to another person
    function transferTickets(address to, uint256 quantity) public {
        require(ticketsOwned[msg.sender] >= quantity, "You do not own enough tickets");

        ticketsOwned[msg.sender] -= quantity;
        ticketsOwned[to] += quantity;
    }

    // Function to view available tickets
    function getAvailableTickets() public view returns (uint256) {
        return totalTickets - ticketsSold;
    }
    
    // Function to change ticket price (Only the owner can change)
    function changeTicketPrice(uint256 newPrice) public onlyOwner {
        require(newPrice > 0, "Price must be greater than zero");
        ticketPrice = newPrice;
    }

    // Function to get the contract balance
    function getContractBalance() public view returns (uint256) {
        return contractBalance;
    }
    
    // Function to get the balance of a user
    function getBalance(address user) public view returns (uint256) {
        return userBalances[user];
    }
}
