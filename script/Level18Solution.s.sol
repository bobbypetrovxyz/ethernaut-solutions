// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level18MagicNum.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: To solve this level, you only need to provide the Ethernaut with a Solver,
// a contract that responds to whatIsTheMeaningOfLife() with 42.
// The solver's code needs to be really tiny: 10 bytes at most.

// The runtime bytecode of the Solver contract must be exactly 10 bytes long.
// # (bytes)  |	OPCODE	  | Stack  | bytecode  | Meaning
// 00	      | PUSH1 2a  |		   | 602a      | push 2a (hexadecimal) = 42 (decimal) to the stack
// 02	      | PUSH1 00  |	2a	   | 6000      | push 00 to the stack
// 05	      | MSTORE	  | 00, 2a | 52        | mstore(0, 2a), store 2a = 42 at memory position 0
// 06	      | PUSH1 20  |		   | 6020      | push 20 (hexadecimal) = 32 (decimal) to the stack (for 32 bytes of data)
// 08	      | PUSH1 00  |	20	   | 6000      | push 00 to the stack
// 10	      | RETURN	  | 00, 20 | f3        | return(memory position, number of bytes), return 32 bytes stored in memory position 0

// The assembly of these 10 bytes of OPCODES results in the following bytecode: 602a60005260206000f3

// The creation bytecode must return the runtime bytecode of the Solver contract - 0x602a60005260206000f3
// # (bytes)  |	OPCODE	                    | Stack                    | bytecode               | Meaning
// 00	      | PUSH10 602a60005260206000f3 |                          | 69602a60005260206000f3 | push the 10 bytes of runtime bytecode to the stack
// 03         | PUSH1 00	                | 602a60005260206000f3     | 6000                   | push 0 to the stack
// 05	      | MSTORE	                    | 00, 602a60005260206000f3 | 52                     | mstore(0, 602a60005260206000f3), store the runtime bytecode at memory position 0
// 06	      | PUSH1 a	                    |                          | 600a                   | push a = 10 (decimal) to the stack
// 08	      | PUSH1 16	                | a                        | 6016                   | push 16 = 22 (decimal) to the stack
// 10	      | RETURN	                    | 16, a                    | f3                     | return(0x16, 0x0a) returns the 10 bytes of runtime bytecode stored at memory position 0

// The complete contract creation bytecode is then 69602a60005260206000f3600052600a6016f3

// contract Solver: more than 10 bytes of runtime bytecode will not work, so use assembly to deploy the contract with the exact bytecode.
contract Solver {
    function whatIsTheMeaningOfLife() external pure returns (uint256) {
        return 42;
    }
}

contract Level18Solution is Script {
    MagicNum public magicNum =
        MagicNum(0x38dc236Ed82b3d21D21dE1bAe24DfA90b9022872);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";
        address solverAddress;

        assembly {
            // Deploy the Solver contract
            // create(value, offset, size)
            // - value: 0 (no ether sent)
            // - offset: add(bytecode, 0x20) skips the first 32 bytes
            // - size: 0x13 (19 bytes, the length of the bytecode)
            solverAddress := create(0, add(bytecode, 0x20), 0x13)
        }

        magicNum.setSolver(solverAddress);

        vm.stopBroadcast();
    }
}

// forge script script/Level18Solution.s.sol:Level18Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
