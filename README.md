# Socializ3-smart-contracts
Smart Contracts deployed for supporting functionalities of Socializ3

```Package.json```dev-dependencies:

+-- @nomicfoundation/hardhat-toolbox@5.0.0
+-- @openzeppelin/contracts@5.1.0
+-- ethers@6.13.4
+-- hardhat-gas-reporter@1.0.10
`-- hardhat@2.22.16

Command: ```npm install```

### Instructions to run:

1. A ```secrets.json``` file needs to be added containing ```privateKey```, ```zkEvmRpcUrl``` and ```zkEvmExplorerApiKe```.
2. Add ```hardhat.config.js``` where solidity version and other parameters are defined for deploying.
3. Then compile the contracts using ```npx hardhat clean``` and ```npx hardhat compile```.
4. Now, run script for poiting towards the blockchain network where the contract is to be deployed.
```npx hardhat run scripts/deploySOCToken.js --network polygonZkEvmCardonaTestnet ```
5. Get the flattened code and use it to verify and publish the contract on the blockchain.
Flattend code: ```npx hardhat flatten .\contracts\SOCToken.sol  ```


Contracts deployed and verified:

Token: 0x09D381010cc370b6a6Be35a6EdD2Ecb725e2c875
RewardDistributionContract: 0xeaef30792ff3fb4fe6a960fe0354d5efcee0472e
For testing the reward Distribution mechanism, SOCToken needs to be approved by the advertiserPool wallet, and then allowance needs to be checked, which is a read contract function, and doesn't need to be connected to any wallet, the rewardDistributor should be connected to the owner of the wallet as the function is OwnerOnly accessible.


NOTE: Keep tract of contract addresses and always verify and publish them so that other clients like django and react can access the functions exposed by the ERC-20 token.

Solidity version: ^0.8.20