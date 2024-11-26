// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RewardDistributor is Ownable {
    IERC20 public socToken;
    address public advertiserAccount;

    /**
     * @dev Constructor that sets the SOCToken contract address and advertiser's account.
     * @param socTokenAddress Address of the deployed SOCToken contract.
     * @param advertiserAccountAddress Address of the advertiser's account holding the tokens.
     */
    constructor(address socTokenAddress, address advertiserAccountAddress) {
        socToken = IERC20(socTokenAddress);
        advertiserAccount = advertiserAccountAddress;
    }

    /**
     * @dev Distribute rewards to recipients based on engagement scores.
     * @param recipients Array of recipient addresses.
     * @param engagementScores Array of engagement scores corresponding to each recipient.
     */
    function distributeRewards(address[] calldata recipients, uint256[] calldata engagementScores) external onlyOwner {
        require(recipients.length == engagementScores.length, "Mismatched arrays");
        require(recipients.length > 0, "No recipients provided");

        uint256 totalEngagement = 0;
        for (uint256 i = 0; i < engagementScores.length; i++) {
            totalEngagement += engagementScores[i];
        }
        require(totalEngagement > 0, "Total engagement must be greater than zero");

        uint256 totalTokens = socToken.balanceOf(advertiserAccount);
        require(totalTokens > 0, "No tokens available for distribution");

        // The advertiser must approve this contract to spend tokens on their behalf
        for (uint256 i = 0; i < recipients.length; i++) {
            uint256 rewardAmount = (engagementScores[i] * totalTokens) / totalEngagement;
            if (rewardAmount > 0) {
                socToken.transferFrom(advertiserAccount, recipients[i], rewardAmount);
            }
        }
    }

    /**
     * @dev Update the advertiser's account address.
     * @param newAdvertiserAccount The new advertiser account address.
     */
    function setAdvertiserAccount(address newAdvertiserAccount) external onlyOwner {
        advertiserAccount = newAdvertiserAccount;
    }
}
