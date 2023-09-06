// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// example of using signature verification

contract Signature {
    function verify(address signer, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s) external pure returns (bool) {
        return signer == ecrecover(messageHash, v, r, s);
    }
}
