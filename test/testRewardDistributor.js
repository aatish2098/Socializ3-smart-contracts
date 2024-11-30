const { ethers } = require("hardhat");

async function main() {
    // Replace with actual deployed contract addresses
    const rewardDistributorAddress = "0xYourRewardDistributorAddress";
    const socTokenAddress = "0xYourSOCTokenAddress";
    const advertiserPool = "0xAdvertiserPoolAddress"; // Must hold SOC tokens
    const recipients = [
        "0xRecipientAddress1",
        "0xRecipientAddress2",
    ];
    const engagementScores = [50, 100];
    const totalEngagementScore = 150; // Sum of engagement scores

    // Connect to deployed contracts
    const RewardDistributor = await ethers.getContractAt("RewardDistributor", rewardDistributorAddress);
    const SOCToken = await ethers.getContractAt("SOCToken", socTokenAddress);

    const [owner] = await ethers.getSigners();

    // Transfer some SOC tokens to the advertiser pool
    const amountToAdvertiserPool = ethers.parseUnits("1000", 18); // 1000 SOC tokens
    console.log("Funding advertiser pool...");
    let tx = await SOCToken.transfer(advertiserPool, amountToAdvertiserPool);
    await tx.wait();
    console.log("Advertiser pool funded.");

    // Approve RewardDistributor to spend advertiser's SOC tokens
    console.log("Approving RewardDistributor...");
    tx = await SOCToken.connect(owner).approve(rewardDistributorAddress, amountToAdvertiserPool);
    await tx.wait();
    console.log("RewardDistributor approved.");

    // Distribute rewards
    console.log("Distributing rewards...");
    tx = await RewardDistributor.distributeRewards(recipients, engagementScores, totalEngagementScore);
    await tx.wait();
    console.log("Rewards distributed!");

    // Check balances of recipients
    for (let i = 0; i < recipients.length; i++) {
        const balance = await SOCToken.balanceOf(recipients[i]);
        console.log(`Recipient ${i + 1} (${recipients[i]}) balance: ${ethers.formatUnits(balance, 18)} SOC`);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
