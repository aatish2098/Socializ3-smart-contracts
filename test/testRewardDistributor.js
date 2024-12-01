const { ethers } = require("hardhat");

async function main() {
    const rewardDistributorAddress = "0xEaEF30792Ff3Fb4Fe6a960FE0354D5eFcee0472E";
    const socTokenAddress = "0x09D381010cc370b6a6Be35a6EdD2Ecb725e2c875";
    const advertiserPool = "0x0035BA744A3e304c88040Ce6D5D1619881c4cbd5"; // Must hold SOC tokens
    const recipients = [
        "0x304B92f1e51746bdDb24BEB2396626D023B133f8", // User 2
    ];
    const engagementScores = [50];
    const totalEngagementScore = 50;

    const SOCToken = await ethers.getContractAt("SOCToken", socTokenAddress);
    const RewardDistributor = await ethers.getContractAt("RewardDistributor", rewardDistributorAddress);
    const [owner] = await ethers.getSigners();

    console.log(`Using account: ${owner.address}`);

    // Check advertiser pool balance
    const advertiserBalance = await SOCToken.balanceOf(advertiserPool);
    console.log(`Advertiser pool balance: ${ethers.formatUnits(advertiserBalance, 18)} SOC`);

    // Check allowance
    let allowance;
    try {
        allowance = await SOCToken.allowance(advertiserPool, rewardDistributorAddress);
        allowance = ethers.BigNumber.from(allowance); // Ensure it is a BigNumber
        console.log(`Raw allowance from contract: ${allowance.toString()}`);
        console.log(`Allowance for RewardDistributor: ${ethers.formatUnits(allowance, 18)} SOC`);
    } catch (err) {
        console.error("Error fetching allowance:", err.message);
        return;
    }

    // Approve RewardDistributor if allowance is insufficient
    if (allowance.isZero()) {
        console.log("Approving RewardDistributor...");
        const approveTx = await SOCToken.connect(owner).approve(rewardDistributorAddress, advertiserBalance);
        const approveReceipt = await approveTx.wait();
        console.log(`RewardDistributor approved in ${approveReceipt.gasUsed.toString()} gas.`);
    } else {
        console.log("RewardDistributor already approved.");
    }

    // Rest of your code...
}

main().catch(console.error);
