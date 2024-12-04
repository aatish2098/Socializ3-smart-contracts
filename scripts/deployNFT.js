const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying the contract with account:", deployer.address);

    const initialOwner = deployer.address; // Set the initial owner
    const KWall = await ethers.getContractFactory("contracts/KWall.sol:KWall");

    const contract = await KWall.deploy(initialOwner);

    await contract.waitForDeployment();

    console.log("KWall deployed to:", contract.target);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
