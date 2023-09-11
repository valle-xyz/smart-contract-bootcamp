// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

library LibraryExample {
    function add(uint256 a, uint256 b) external pure returns (uint256) {
        return a + b;
    }
}

contract LibraryUser {
    function useLibrary() external pure returns (uint256) {
        return LibraryExample.add(1, 2);
    }
}
