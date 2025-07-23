// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IAlienCodex {
    function owner() external view returns (address);

    function makeContact() external;

    function record(bytes32 _content) external;

    function retract() external;

    function revise(uint256 i, bytes32 _content) external;
}

// pragma solidity ^0.5.0;

// import "../helpers/Ownable-05.sol";

// contract AlienCodex is Ownable {
//     bool public contact;
//     bytes32[] public codex;

//     modifier contacted() {
//         assert(contact);
//         _;
//     }

//     function makeContact() public {
//         contact = true;
//     }

//     function record(bytes32 _content) public contacted {
//         codex.push(_content);
//     }

//     function retract() public contacted {
//         codex.length--;
//     }

//     function revise(uint256 i, bytes32 _content) public contacted {
//         codex[i] = _content;
//     }
// }
