import { useState, useEffect } from "react";
import { ethers } from "ethers";
import atm_abi from "../artifacts/contracts/EventBooking.sol/EventBooking.json";

export default function HomePage() {
  const [ethWallet, setEthWallet] = useState(undefined);
  const [account, setAccount] = useState(undefined);
  const [atm, setATM] = useState(undefined);
  const [balance, setBalance] = useState(undefined);
  const [availableTickets, setAvailableTickets] = useState(undefined);
  const [ticketsOwned, setTicketsOwned] = useState(undefined);
  const [ticketQuantity, setTicketQuantity] = useState(1);
  const [recipient, setRecipient] = useState("");
  const [refundQuantity, setRefundQuantity] = useState(1);

  const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const atmABI = atm_abi.abi;

  const getWallet = async () => {
    if (window.ethereum) {
      setEthWallet(window.ethereum);
    }

    if (ethWallet) {
      const accounts = await ethWallet.request({ method: "eth_accounts" });
      handleAccount(accounts);
    }
  };

  const handleAccount = (accounts) => {
    if (accounts.length > 0) {
      console.log("Account connected: ", accounts[0]);
      setAccount(accounts[0]);
    } else {
      console.log("No account found");
    }
  };

  const connectAccount = async () => {
    if (!ethWallet) {
      alert("MetaMask wallet is required to connect");
      return;
    }

    const accounts = await ethWallet.request({ method: "eth_requestAccounts" });
    handleAccount(accounts);
    getATMContract();
  };

  const getATMContract = () => {
    const provider = new ethers.providers.Web3Provider(ethWallet);
    const signer = provider.getSigner();
    const atmContract = new ethers.Contract(contractAddress, atmABI, signer);
    setATM(atmContract);
  };

  const getBalance = async () => {
    if (atm) {
      const balance = await atm.getContractBalance();
      setBalance(balance);
    }
  };

  const getAvailableTickets = async () => {
    if (atm) {
      const available = await atm.getAvailableTickets();
      setAvailableTickets(available);
    }
  };

  const getTicketsOwned = async () => {
    if (atm && account) {
      const owned = await atm.ticketsOwned(account);
      setTicketsOwned(owned);
    }
  };

  const deposit = async () => {
    if (atm) {
      try {
        const tx = await atm.deposit(ethers.utils.parseEther("1"));
        await tx.wait();
        alert("Successfully deposited 1 ETH!");
        getBalance();
      } catch (error) {
        console.error("Deposit Error:", error);
      }
    }
  };

  const withdraw = async () => {
    if (atm) {
      try {
        const tx = await atm.withdraw(ethers.utils.parseEther("1"));
        await tx.wait();
        alert("Successfully withdrew 1 ETH!");
        getBalance();
      } catch (error) {
        console.error("Withdraw Error:", error);
      }
    }
  };

  const purchaseTickets = async () => {
    if (atm && ticketQuantity > 0) {
      try {
        const totalCost = ethers.utils.parseEther("1").mul(ticketQuantity);
        let tx = await atm.purchaseTickets(ticketQuantity, { value: totalCost });
        await tx.wait();
        alert(`Successfully purchased ${ticketQuantity} ticket(s)!`);
        getBalance();
        getTicketsOwned();
        getAvailableTickets();
      } catch (error) {
        console.error("Purchase Error:", error);
      }
    } else {
      alert("Please enter a valid ticket quantity.");
    }
  };

  const transferTickets = async () => {
    if (atm && recipient && ticketQuantity > 0) {
      try {
        let tx = await atm.transferTickets(recipient, ticketQuantity);
        await tx.wait();
        alert(`Successfully transferred ${ticketQuantity} ticket(s) to ${recipient}!`);
        getTicketsOwned();
      } catch (error) {
        console.error("Transfer Error:", error);
      }
    } else {
      alert("Please enter a valid recipient address and ticket quantity.");
    }
  };

  const refundTickets = async () => {
    if (atm && refundQuantity > 0) {
      try {
        let tx = await atm.refundTickets(account, refundQuantity);
        await tx.wait();
        alert(`Successfully refunded ${refundQuantity} ticket(s)!`);
        getBalance();
        getTicketsOwned();
        getAvailableTickets();
      } catch (error) {
        console.error("Refund Error:", error);
      }
    } else {
      alert("Please enter a valid quantity to refund.");
    }
  };

  const initUser = () => {
    if (!ethWallet) {
      return <p>Please install Metamask in order to use this app.</p>;
    }

    if (!account) {
      return <button onClick={connectAccount}>Please connect your Metamask wallet</button>;
    }

    if (balance === undefined) {
      getBalance();
    }

    if (availableTickets === undefined) {
      getAvailableTickets();
    }

    if (ticketsOwned === undefined) {
      getTicketsOwned();
    }

    return (
      <div>
        <p>Your Account: {account}</p>
        <p>Your Balance: {ethers.utils.formatEther(balance || "0")} ETH</p>
        <p>Available Tickets: {availableTickets ? availableTickets.toString() : "Loading..."}</p>
        <p>Your Tickets: {ticketsOwned ? ticketsOwned.toString() : "Loading..."}</p>

        <input
          type="number"
          value={ticketQuantity}
          onChange={(e) => setTicketQuantity(Number(e.target.value))}
          min="1"
        />
        <button onClick={purchaseTickets}>Purchase {ticketQuantity} Tickets</button>
        
        <div>
          <h3>Transfer Tickets</h3>
          <input
            type="text"
            value={recipient}
            onChange={(e) => setRecipient(e.target.value)}
            placeholder="Recipient Address"
          />
          <input
            type="number"
            value={ticketQuantity}
            onChange={(e) => setTicketQuantity(Number(e.target.value))}
            min="1"
            placeholder="Quantity"
          />
          <button onClick={transferTickets}>Transfer Tickets</button>
        </div>

        <div>
          <h3>Refund Tickets</h3>
          <input
            type="number"
            value={refundQuantity}
            onChange={(e) => setRefundQuantity(Number(e.target.value))}
            min="1"
            placeholder="Quantity to Refund"
          />
          <button onClick={refundTickets}>Refund Tickets</button>
        </div>

        <div>
          <h3>Manage ETH</h3>
          <button onClick={deposit}>Deposit 1 ETH</button>
          <button onClick={withdraw}>Withdraw 1 ETH</button>
        </div>
      </div>
    );
  };

  useEffect(() => {
    getWallet();
  }, []);

  return (
    <main className="container">
      <header>
        <h1>Welcome to the Event Management System!</h1>
      </header>
      {initUser()}
      <style jsx>{`
        .container {
          text-align: center;
        }
      `}</style>
    </main>
  );
}
