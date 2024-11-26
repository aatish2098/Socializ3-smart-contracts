async function main() {
    const [deployer] = await ethers.getSigners();

    const socTokenAddress = "YOUR_SOC_TOKEN_CONTRACT_ADDRESS";
    const advertiserAccount = "0x0035BA744A3e304c88040Ce6D5D1619881c4cbd5";

    const RewardDistributor = await ethers.getContractFactory("RewardDistributor");
    const rewardDistributor = await RewardDistributor.deploy(socTokenAddress, advertiserAccount);

    await rewardDistributor.deployed();

    console.log("RewardDistributor deployed to:", rewardDistributor.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("Error:", error);
        process.exit(1);
    });
