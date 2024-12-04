// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SOCStaking {
    IERC20 public socToken;

    // Mapping from user address to staked amount
    mapping(address => uint256) public stakedBalance;

    // Mapping from user address to staking timestamp
    mapping(address => uint256) public stakingStartTime;

    // Annual reward rate in percentage (e.g., 10%)
    uint256 public annualRewardRate = 10;

    // Events
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount, uint256 reward);

    // Constructor to initialize the SOC token
    constructor(address _socTokenAddress) {
        socToken = IERC20(_socTokenAddress);
    }

    // Function to stake tokens
    function stake(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than zero");

        // Transfer SOCTokens from the user to this contract
        require(socToken.transferFrom(msg.sender, address(this), _amount), "Token transfer failed");

        // Update staked balance and start time
        stakedBalance[msg.sender] += _amount;
        stakingStartTime[msg.sender] = block.timestamp;

        emit Staked(msg.sender, _amount);
    }

    // Function to calculate rewards
    function calculateReward(address _user) public view returns (uint256) {
        uint256 stakedAmount = stakedBalance[_user];
        uint256 stakingDuration = block.timestamp - stakingStartTime[_user];
        uint256 reward = (stakedAmount * annualRewardRate * stakingDuration) / (100 * 365 days);
        return reward;
    }

    // Function to withdraw staked tokens and rewards
    function withdraw() external {
        uint256 stakedAmount = stakedBalance[msg.sender];
        require(stakedAmount > 0, "No staked tokens to withdraw");

        uint256 reward = calculateReward(msg.sender);
        uint256 totalAmount = stakedAmount + reward;

        // Reset staked balance and start time
        stakedBalance[msg.sender] = 0;
        stakingStartTime[msg.sender] = 0;

        // Transfer staked tokens and reward to the user
        require(socToken.transfer(msg.sender, totalAmount), "Token transfer failed");

        emit Withdrawn(msg.sender, stakedAmount, reward);
    }
}
