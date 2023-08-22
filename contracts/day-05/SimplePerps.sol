// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./AggregatorV3Interface.sol";

struct Position {
    uint256 collateral;
    int256 entryPrice;
    uint256 entryTimestamp;
    uint256 leverage; // 1e6 = 1x,
    address owner;
}

contract SimplePerps {
    using SafeERC20 for IERC20;

    mapping(uint256 => Position) positions;
    uint256 nextId;
    IERC20 public collateralToken;
    AggregatorV3Interface public priceFeed;

    function openPosition(uint256 collateral, uint256 leverage) external {
        int256 entryPrice = _getPrice();
        collateralToken.safeTransferFrom(msg.sender, address(this), collateral);
        positions[++nextId] = Position(collateral, entryPrice, block.timestamp, leverage, msg.sender);
    }

    function closePosition(uint256 id) external {
        Position storage position = positions[id];
        require(position.owner == msg.sender, "Only the owner can close the position");
        int256 exitPrice = _getPrice();
        int256 profit = (exitPrice - position.entryPrice) * int256(position.leverage) * int256(position.collateral)
            / position.entryPrice / 1e6;
        int256 returnAmount = int256(position.collateral) + profit;
        delete positions[id];
        if (returnAmount > 0) {
            collateralToken.safeTransfer(msg.sender, uint256(returnAmount));
        }
    }

    function liquidatePosition(uint256 id) external {
        Position storage position = positions[id];
        require(position.owner != address(0), "Position does not exist");
        require(position.owner == msg.sender, "Only the owner can close the position");
        int256 exitPrice = _getPrice();
        int256 profit = (exitPrice - position.entryPrice) * int256(position.leverage) * int256(position.collateral)
            / position.entryPrice / 1e6;
        int256 returnAmount = int256(position.collateral) + profit;
        require(returnAmount <= 0, "Position is not liquidatable");
        delete positions[id];
    }

    function _getPrice() internal view returns (int256) {
        (, int256 price,,,) = priceFeed.latestRoundData();
        require(price > 0, "TradePair::_getCurrentPrice: Failed to fetch the current price.");
        return price;
    }
}
