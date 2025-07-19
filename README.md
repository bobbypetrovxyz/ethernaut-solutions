## The Ethernaut Solutions with Foundry

**https://ethernaut.openzeppelin.com/**

- **src** folder contains the source code of all levels
- **script** folder contains the source code of all exploits


## Setup

Create .env file with the following parameters:
```
PRIVATE_KEY=<private key of your wallet>
MY_ADDRESS=<your wallet address>

SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/7999ca4086074afea3bd7f0822bfad63
ETHERSCAN_API_KEY=ZSMG235NY762RBAICZVARPXI9C3GQED9860x698c300C435a6827dA6465c62424abDB854cFFf4
```

## Run the exploit and broadcast to Sepolia testnet

In each solution file (e.g. Level1Solution.s.sol), at the end in the comment there is a forge script execution command ready to be executed in the terminal.

Example:
```shell
$forge script script/Level1Solution.s.sol:Level1Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
```
