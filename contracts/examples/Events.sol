// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// Example to showcase how events are used

contract Events {
    uint256 nextPositionId;

    event PositionOpened(address indexed account, uint256 indexed positionId, uint256 amount);

    function openPosition(uint256 amount) external {
        // ... some logic

        emit PositionOpened(msg.sender, nextPositionId, amount);
    }
}
