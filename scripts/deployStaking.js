const hre = require("hardhat");

async function main() {
    // Get the contract factory
    const SOCStaking = await hre.ethers.getContractFactory("SOCStaking");

    // Parameters for the constructor
    const socTokenAddress = "0x09D381010cc370b6a6Be35a6EdD2Ecb725e2c875"; // Replace with your deployed SOCToken address
    const rewardRate = 5; // Example: 5% annual reward rate

    console.log("Deploying SOCStaking contract...");

    // Deploy the contract
    const socStaking = await SOCStaking.deploy(socTokenAddress, rewardRate);

    // Wait for the deployment to complete
    await socStaking.waitForDeployment();

    console.log("SOCStaking deployed to:", socStaking.target);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
