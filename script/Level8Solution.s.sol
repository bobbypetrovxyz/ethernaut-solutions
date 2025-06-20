// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level8Vault.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: Unlock the vault to pass the level!

// to extract the password, we can use the the following steps:
// 1. Run "forge inspect Vault storageLayout" to find the storage slot for the password, which is at slot 1
// 2. Run "cast storage 0xa8A65bfE150020a6b81E38DFfAD110c799CE681D 1 --rpc-url sepolia" to read the password from the contract's storage
// 3. Run "cast to-ascii 0x412076657279207374726f6e67207365637265742070617373776f7264203a29" to convert the password from bytes32 to a human-readable string
// 4. The password is "A very strong secret password :)" in bytes32 format
// 5. Use the password in the script to unlock the vault

contract Level8Solution is Script {
    Vault public vault = Vault(0xa8A65bfE150020a6b81E38DFfAD110c799CE681D);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Vault locked:", vault.locked());
        bytes32 password = bytes32("A very strong secret password :)");
        vault.unlock(password);
        console.log("Vault locked:", vault.locked());

        vm.stopBroadcast();
    }
}
// forge script script/Level8Solution.s.sol:Level8Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
