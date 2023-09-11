// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

contract OverloadingForDefaultParameters {
    function foo(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    function foo(uint256 a) external pure returns (uint256) {
        return foo(a, 0);
    }
}
