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
    int256 direction; // 1 for long, -1 for short
}

contract Perps {
    using SafeERC20 for IERC20;

    mapping(uint256 => Position) positions;
    uint256 nextId;
    IERC20 public collateralToken;
    AggregatorV3Interface public priceFeed;
    int256 borrowRate = 0.00001 * 1e6; // 0.001% per hour
    uint256 liquidatorReward = 1 * 1e8; // Same decimals as collateral

    constructor(address _collateralToken, address _priceFeed) {
        collateralToken = IERC20(_collateralToken);
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function openPosition(uint256 collateral, uint256 leverage, int8 direction) external {
        int256 entryPrice = _getPrice();
        positions[++nextId] = Position(collateral, entryPrice, block.timestamp, leverage, msg.sender, direction);
        collateralToken.safeTransferFrom(msg.sender, address(this), collateral);
    }

    function closePosition(uint256 id) external {
        Position storage position = positions[id];
        require(position.owner == msg.sender, "Only the owner can close the position");
        uint256 value = _getValue(id);
        delete positions[id];
        if (value > 0) {
            collateralToken.safeTransfer(msg.sender, value);
        }
    }

    function liquidatePosition(uint256 id) external {
        Position storage position = positions[id];
        require(position.owner != address(0), "Position does not exist");
        require(_getValue(id) <= 0, "Position is not liquidatable");
        delete positions[id];
        collateralToken.safeTransfer(msg.sender, liquidatorReward);
    }

    function _getValue(uint256 id) internal view returns (uint256) {
        Position storage position = positions[id];
        int256 currentPrice = _getPrice();
        int256 profit = (currentPrice - position.entryPrice) * int256(position.leverage) * int256(position.collateral)
            * position.direction / position.entryPrice / 1e6;
        int256 fee = int256(block.timestamp - position.entryTimestamp) * borrowRate * int256(position.collateral)
            * int256(position.leverage) / 1e12 / 1 hours;
        int256 value = int256(position.collateral) + profit - fee;
        if (value < 0) {
            return 0;
        }
        return uint256(value);
    }

    function _getPrice() internal view returns (int256) {
        (, int256 price,,,) = priceFeed.latestRoundData();
        require(price > 0, "TradePair::_getCurrentPrice: Failed to fetch the current price.");
        return price;
    }
}
