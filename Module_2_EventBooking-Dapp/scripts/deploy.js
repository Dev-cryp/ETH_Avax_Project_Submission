// Import the Hardhat Runtime Environment
const hre = require("hardhat");

async function main() {
  // Initial balance to set for the contract (in Ether)
  const initBalance = hre.ethers.utils.parseEther("1"); // Initial balance of 1 ETH
  const TicketsPrice = 100; // Initial number of tickets available in the contract
  const eventName = "Blockchain Conference 2024"; // The event name
  const totaltickets = 1000;


  const Assessment = await hre.ethers.getContractFactory("EventBooking");
  const assessment = await Assessment.deploy(initBalance, eventName,TicketsPrice, totaltickets );


  await assessment.deployed();

  console.log(`Contract for ${eventName} with balance of ${hre.ethers.utils.formatEther(initBalance)} ETH and ${totaltickets} tickets deployed to: ${assessment.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
