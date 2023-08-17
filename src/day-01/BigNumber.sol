// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

contract BigNumber {
    uint256 public biggestNumber;

    function setBiggerNumber(uint256 newNumber) external {
        if (newNumber > biggestNumber) {
            biggestNumber = newNumber;
        }
    }
}
