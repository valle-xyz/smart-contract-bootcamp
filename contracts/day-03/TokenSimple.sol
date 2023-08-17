// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "contracts/day-02/Owned.sol";

contract SimpleToken is Owned {
    mapping(address => uint256) public balanceOf;

    function mint(address receiver, uint256 amount) external onlyOwner {
        balanceOf[receiver] += amount;
    }

    function transfer(address receiver, uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "must have enough funds");
        balanceOf[msg.sender] -= amount;
        balanceOf[receiver] += amount;
    }
}
