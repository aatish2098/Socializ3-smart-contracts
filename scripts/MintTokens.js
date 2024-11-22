const { ethers } = require("hardhat");

async function main() {
    const [owner] = await ethers.getSigners();
    const tokenAddress = "0xYourDeployedContractAddress"; // Replace with your contract address

    const SOCToken = await ethers.getContractAt("SOCToken", tokenAddress);

    const recipient = "0xRecipientAddressHere"; // Address to receive new tokens
    const amount = ethers.parseUnits("5000", 18); // Amount to mint (e.g., 5,000 tokens)

    console.log(`Minting ${ethers.formatEther(amount)} SOC to ${recipient}...`);
    const tx = await SOCToken.mint(recipient, amount);
    await tx.wait();

    console.log(`Successfully minted ${ethers.formatEther(amount)} SOC to ${recipient}`);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
