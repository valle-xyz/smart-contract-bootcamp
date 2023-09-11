// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// Example on how to use mapping and nested mapping

contract MappingExample {
    // Mapping from address to uint
    mapping(address => uint256) public addressToUint;

    // Nested mapping
    mapping(address => mapping(uint256 => bool)) public nestedMapping;

    // Set the value of the mapping
    function setMappingValue(uint256 _value) public {
        addressToUint[msg.sender] = _value;
    }

    // Set the value of the nested mapping
    function setNestedMappingValue(uint256 _value) public {
        nestedMapping[msg.sender][_value] = true;
    }
}
