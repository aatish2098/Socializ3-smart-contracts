const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    const balance = await deployer.provider.getBalance(deployer.address);
    console.log("Account balance:", ethers.formatEther(balance));

    // Deploy the SOCToken contract
    const SOCToken = await ethers.getContractFactory("SOCToken");
    const contract = await SOCToken.deploy();

    await contract.waitForDeployment();

    console.log("SOCToken deployed to:", contract.target);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
