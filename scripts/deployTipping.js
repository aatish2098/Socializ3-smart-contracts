// Import Hardhat dependencies
const hre = require("hardhat");

async function main() {
    const tokenAddress = "0x09D381010cc370b6a6Be35a6EdD2Ecb725e2c875";

    if (!tokenAddress) {
        throw new Error("Please set the SOCToken contract address in the script.");
    }

    console.log("Deploying SOCTipping contract...");

    // Get the contract factory for SOCTipping
    const SOCTipping = await hre.ethers.getContractFactory("SOCTipping");

    // Deploy the contract with the token address
    const socTipping = await SOCTipping.deploy(tokenAddress);

    // Wait for the deployment to complete
    await socTipping.waitForDeployment();

    console.log("SOCToken deployed to:", socTipping.target);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
