// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "contracts/day-02/INumbersGame.sol";

contract NumberRepeater {
    INumbersGame numbersGame;

    constructor(address numberAddress) {
        numbersGame = INumbersGame(numberAddress);
    }

    function repeat() external returns (uint256) {
        return INumbersGame(numbersGame).letsSeeYourNumber();
    }

    function setNumbersGame(address newAddress) external {
        numbersGame = INumbersGame(newAddress);
    }

    function repeat(address numberAddress) external returns (uint256) {
        return INumbersGame(numberAddress).letsSeeYourNumber();
    }
}
