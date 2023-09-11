// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// Example to show the difference in gas coast between pure and view functions

contract PureVsView {
    uint256 public counter;

    function increment() external {
        counter++;
    }

    function getCounter() external view returns (uint256) {
        return counter;
    }

    function getCounterPure() external pure returns (uint256) {
        return 0;
    }

    function getCounterAndVariable() external view returns (uint256) {
        return counter + 0;
    }
}
