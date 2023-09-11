// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// example on how to use constructor

contract ConstructorExample {
    uint256 public number;

    constructor(uint256 _number) {
        number = _number;
    }
}
