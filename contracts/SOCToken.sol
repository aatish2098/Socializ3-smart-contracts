// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SOCToken is ERC20, Ownable {
    /**
     * @dev Constructor that mints exactly 1,000,000 tokens to the deployer.
     */
    constructor() ERC20("Socializ3 Token", "SOC") Ownable(msg.sender) {
        uint256 initialSupply = 1_000_000 * (10 ** decimals()); // 1,000,000 tokens with 18 decimals
        _mint(msg.sender, initialSupply); // Mint to deployer
    }

    /**
     * @dev Mint new tokens. Only the owner can mint.
     * @param to The address to receive the minted tokens.
     * @param amount The number of tokens to mint (in base units).
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
