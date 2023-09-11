// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// Example that clarifies decimals

contract Decimals {
    uint256 decimalsUSDC = 1e6;
    uint256 decimalsETHER = 1e18;

    uint256 priceOfEtherInUSDC = 2_000 * decimalsUSDC;

    uint256 usdcAmount = 4_000 * decimalsUSDC;

    uint256 etherAmount = usdcAmount * decimalsETHER / priceOfEtherInUSDC;

    uint256 repition = 4_000 * 1e6 * 1e18 / 2_000 * 1e6;
}
