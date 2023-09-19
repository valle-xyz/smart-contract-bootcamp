// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "./INumbersGame.sol";

contract NumbersGame is INumbersGame {
    uint256 favouriteNumber = 42;

    function setNewFavouriteNumber(uint256 newNumber) external {
        favouriteNumber = newNumber;
    }

    function letsSeeYourNumber() external view returns (uint256) {
        return favouriteNumber;
    }
}
