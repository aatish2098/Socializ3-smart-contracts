// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./SOCToken.sol";

contract RewardDistributor is Ownable {
    SOCToken public socToken;
    address public advertiserPool;

    constructor(address socTokenAddress, address _advertiserPool, address initialOwner) Ownable(initialOwner) {
        socToken = SOCToken(socTokenAddress);
        advertiserPool = _advertiserPool;
    }

    /**
     * @dev Distribute rewards to users based on their engagement scores.
     * @param recipients Array of recipient addresses.
     * @param engagementScores Array of individual engagement scores.
     * @param totalEngagementScore Total engagement score across all users.
     */
    function distributeRewards(
        address[] calldata recipients,
        uint256[] calldata engagementScores,
        uint256 totalEngagementScore
    ) external onlyOwner {

        require(recipients.length == engagementScores.length, "Mismatched arrays");
        require(totalEngagementScore > 0, "Total engagement score must be > 0");

        // Calculate total tokens available for distribution
        uint256 totalTokens = socToken.balanceOf(advertiserPool);
        require(totalTokens > 0, "No tokens to distribute");

        // Transfer tokens from advertiserPool to this contract
        socToken.transferFrom(advertiserPool, address(this), totalTokens);

        // Distribute tokens to each recipient
        for (uint256 i = 0; i < recipients.length; i++) {
            uint256 reward = (totalTokens * engagementScores[i]) / totalEngagementScore;
            if (reward > 0) {
                socToken.transfer(recipients[i], reward);
            }
        }
    }
    function updateSocTokenAddress(address newSocToken) external onlyOwner {
        socToken = SOCToken(newSocToken);
    }

    function updateAdvertiserPool(address newAdvertiserPool) external onlyOwner {
        advertiserPool = newAdvertiserPool;
    }

}
