// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// example on how to use require statements

contract RequireExample {
    uint256 public number;

    constructor(uint256 _number) {
        require(_number > 0, "number has to be greater than 0");
        number = _number;
    }
}
