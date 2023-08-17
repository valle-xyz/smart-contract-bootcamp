// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

contract Owned {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "must be owner");
        _;
    }
}
