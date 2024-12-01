const {ethers} = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    // Get deployer's balance using the provider
    const balance = await deployer.provider.getBalance(deployer.address);
    console.log("Account balance:", ethers.formatEther(balance), "ETH");

    const socTokenAddress = "0x09D381010cc370b6a6Be35a6EdD2Ecb725e2c875"; // SOC token address
    const advertiserPool = "0x0035BA744A3e304c88040Ce6D5D1619881c4cbd5"; //advertiser pool address

    const RewardDistributor = await ethers.getContractFactory("RewardDistributor");

    const rewardDistributor = await RewardDistributor.deploy(
        socTokenAddress,
        advertiserPool,
        deployer.address // Pass the deployer's address as the initial owner
    );

    console.log("Deploying RewardDistributor contract...");
    await rewardDistributor.waitForDeployment();

    console.log("RewardDistributor deployed to:", rewardDistributor.target);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
