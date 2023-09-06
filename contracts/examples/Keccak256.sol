// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

contract Keccak256 {
    bytes32 public hash;

    function set(string memory message) external {
        hash = keccak256(abi.encode(message));
    }

    function verify(string memory message) external view returns (bool) {
        return hash == keccak256(abi.encode(message));
    }
}
