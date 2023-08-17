// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "contracts/day-02/INumbersGame.sol";

contract NumberRepeater {
    INumbersGame number;

    constructor(address numberAddress) {
        number = INumbersGame(numberAddress);
    }

    function repeat() external returns (uint256) {
        return INumbersGame(number).letsSeeYourNumber();
    }

    function setNumber(address newAddress) external {
        number = INumbersGame(newAddress);
    }

    function repeat(address numberAddress) external returns (uint256) {
        return INumbersGame(numberAddress).letsSeeYourNumber();
    }
}
