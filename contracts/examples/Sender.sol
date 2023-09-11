// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// example on how to use msg.sender and tx.origin to check if the sender is an EOA or a contract

contract SenderExample {
    function isContract() external view returns (bool) {
        return msg.sender != tx.origin;
    }
}
