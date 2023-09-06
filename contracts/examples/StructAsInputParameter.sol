// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0

// Example of struct as input parameter

library LibraryExample {
    struct Position {
        uint256 collateral;
        int256 entryPrice;
    }
}

contract StructAsInputParameter {
    mapping(uint256 => LibraryExample.Position) positions;
    uint256 nextId;

    function openPosition(LibraryExample.Position memory position) external {
        positions[++nextId] = position;
    }
}
