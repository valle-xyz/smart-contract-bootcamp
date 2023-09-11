// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// Now an example with a library that uses storage

library LibraryExample {
    struct Position {
        uint256 collateral;
        int256 entryPrice;
    }

    function addCollateral(Position storage self_, uint256 amount) external {
        self_.collateral += amount;
    }
}

contract LibraryUser {
    LibraryExample.Position public position;

    using LibraryExample for LibraryExample.Position;

    function addCollateral(uint256 amount) external {
        position.addCollateral(amount);
    }
}
