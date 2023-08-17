// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

contract OwnedSimple {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address newOwner) external {
        require(msg.sender == owner, "must be owner");
        owner = newOwner;
    }
}
