// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RealToken is ERC20 {
    constructor() ERC20("CoolToken", "CT") {
        _mint(msg.sender, 1_000_000 * 1e18);
    }
}
