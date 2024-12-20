// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SOCStaking is Ownable {
    IERC20 public socToken;

    struct Stake {
        uint256 amount;       // Amount of SOC tokens staked
        uint256 rewardDebt;   // Reward already calculated for the staker
        uint256 startTime;    // When the staking started
    }

    mapping(address => Stake) public stakes;
    uint256 public rewardRate; // Reward rate in percentage (e.g., 5% = 5)

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount, uint256 reward);
    event RewardRateUpdated(uint256 newRate);

    constructor(address _socTokenAddress, uint256 _rewardRate) Ownable(msg.sender) {
        require(_socTokenAddress != address(0), "Invalid token address");
        socToken = IERC20(_socTokenAddress);
        rewardRate = _rewardRate;
    }

    // Stake SOC tokens
    function stake(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(socToken.balanceOf(msg.sender) >= _amount, "Insufficient balance");

        // Calculate pending rewards if the user has an existing stake
        if (stakes[msg.sender].amount > 0) {
            uint256 pendingReward = calculateReward(msg.sender);
            stakes[msg.sender].rewardDebt += pendingReward;
        }

        // Transfer SOC tokens to the contract
        require(socToken.transferFrom(msg.sender, address(this), _amount), "Token transfer failed");

        // Update user's stake
        stakes[msg.sender].amount += _amount;
        stakes[msg.sender].startTime = block.timestamp;

        emit Staked(msg.sender, _amount);
    }

    // Unstake SOC tokens and claim rewards
    function unstake() external {
        Stake storage stakeInfo = stakes[msg.sender];
        require(stakeInfo.amount > 0, "No tokens staked");

        uint256 pendingReward = calculateReward(msg.sender) + stakeInfo.rewardDebt;
        uint256 stakedAmount = stakeInfo.amount;

        // Reset user's stake
        stakeInfo.amount = 0;
        stakeInfo.rewardDebt = 0;

        // Transfer staked tokens back to the user
        require(socToken.transfer(msg.sender, stakedAmount), "Token transfer failed");

        // Transfer rewards to the user
        if (pendingReward > 0) {
            require(socToken.transfer(msg.sender, pendingReward), "Reward transfer failed");
        }

        emit Unstaked(msg.sender, stakedAmount, pendingReward);
    }

    // View pending reward for a user
    function viewPendingReward(address _user) external view returns (uint256) {
        return calculateReward(_user) + stakes[_user].rewardDebt;
    }

    // Admin function to update the reward rate
    function setRewardRate(uint256 _newRate) external onlyOwner {
        require(_newRate > 0, "Reward rate must be greater than 0");
        rewardRate = _newRate;
        emit RewardRateUpdated(_newRate);
    }

    // Internal function to calculate rewards for a user
    function calculateReward(address _user) internal view returns (uint256) {
        Stake storage stakeInfo = stakes[_user];
        uint256 timeElapsed = block.timestamp - stakeInfo.startTime;
        return (stakeInfo.amount * rewardRate * timeElapsed) / (100 * 365 days);
    }

    // Admin function to withdraw leftover SOC tokens
    function withdrawTokens(uint256 _amount) external onlyOwner {
        require(socToken.balanceOf(address(this)) >= _amount, "Insufficient contract balance");
        require(socToken.transfer(owner(), _amount), "Token transfer failed");
    }
}
