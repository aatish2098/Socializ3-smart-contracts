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


NOTE: Keep tract of contract addresses and always verify and publish them so that other clients like django and react can access the functions exposed by the ERC-20 token.

Solidity version: ^0.8.20