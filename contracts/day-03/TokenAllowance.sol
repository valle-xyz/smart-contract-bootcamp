// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "contracts/day-02/Owned.sol";

contract AllowanceToken is Owned {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) private _allowances;

    function mint(address receiver, uint256 amount) external onlyOwner {
        balanceOf[receiver] += amount;
    }

    function transfer(address receiver, uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "must have enough funds");
        balanceOf[msg.sender] -= amount;
        balanceOf[receiver] += amount;
    }

    function setAllowance(address spender, uint256 amount) external {
        _allowances[msg.sender][spender] = amount;
    }

    function transferFrom(address from, address to, uint256 amount) external {
        require(_allowances[from][to] >= amount, "must have enough allowance");
        require(balanceOf[from] >= amount, "must have enough balance");
        _allowances[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
    }
}
