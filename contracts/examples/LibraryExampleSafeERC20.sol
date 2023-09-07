// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// an example on how to use SafeERC20

contract SafeERC20Example {
    using SafeERC20 for IERC20;

    IERC20 public token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function transfer(address to, uint256 amount) external {
        token.safeTransfer(to, amount);
    }
}
