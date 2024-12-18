// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./SOCToken.sol";
contract SOCTipping {
    IERC20 public socToken; // ERC20 Token interface
    address public owner;   // Owner of the tipping contract

    constructor(address _tokenAddress) {
        require(_tokenAddress != address(0), "Token address cannot be zero");
        socToken = IERC20(_tokenAddress);
        owner = msg.sender;
    }

    /**
     * @dev Allows a user to tip another address with SOCTokens.
     * @param recipient The address to receive the tip.
     * @param amount The amount of SOCTokens to send as a tip.
     */
    function tip(address recipient, uint256 amount) external {
        require(recipient != address(0), "Invalid recipient address");
        require(amount > 0, "Tip amount must be greater than zero");
        require(socToken.balanceOf(msg.sender) >= amount, "Insufficient token balance");

        // Transfer SOCTokens from the sender to the recipient
        bool success = socToken.transferFrom(msg.sender, recipient, amount);
        require(success, "Token transfer failed");
    }

    /**
     * @dev Allows the owner to withdraw any tokens mistakenly sent to the contract.
     * @param amount The amount of tokens to withdraw.
     */
    function withdrawTokens(uint256 amount) external {
        require(msg.sender == owner, "Only owner can withdraw tokens");
        require(socToken.balanceOf(address(this)) >= amount, "Insufficient contract balance");

        socToken.transfer(owner, amount);
    }
}
