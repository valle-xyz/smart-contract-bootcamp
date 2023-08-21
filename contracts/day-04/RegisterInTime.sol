// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

contract RegisterInTime {
    uint256 end;
    mapping(address => bool) public registered;

    constructor(uint256 end_) {
        end = end_;
    }

    function register() external {
        require(block.timestamp < end, "Registration has ended");
        registered[msg.sender] = true;
    }
}
