// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

contract ERC20 {
    string public name;
    string public symbol;

    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    function _mint(address account, uint256 amount) internal virtual {
        // omitted for brevity
    }
}

contract RealToken is ERC20 {
    constructor() ERC20("CoolToken", "CT") {
        _mint(msg.sender, 1_000_000 * 1e18);
    }
}
