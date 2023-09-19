// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "./AggregatorV3Interface.sol";

contract PriceFeedReader {
    AggregatorV3Interface internal dataFeed;

    constructor() {
        dataFeed = AggregatorV3Interface(0x5fb1616F78dA7aFC9FF79e0371741a747D2a7F22);
    }

    function getPrice() public view returns (int256) {
        (, int256 price,,,) = dataFeed.latestRoundData();
        return price;
    }
}
