// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// example on how to use interface and call other contracts from a contract

interface ExampleInterface {
    function getNumber() external view returns (uint256);
}

contract ExampleContract {
    ExampleInterface exampleContract;

    constructor(address _exampleContract) {
        exampleContract = ExampleInterface(_exampleContract);
    }

    function getNumberFromOtherContract() external view returns (uint256) {
        return exampleContract.getNumber();
    }
}
