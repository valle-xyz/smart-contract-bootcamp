// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// Example on how to use a modifier with code executed before and after the actual function call.

contract ModifierExample {
    uint256 public number;

    modifier addNumber(uint256 _number) {
        number += _number;
        _;
        number += _number;
    }

    function addNumberAndReturn(uint256 _number) external addNumber(_number) returns (uint256) {
        return number;
    }
}
