// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "contracts/day-02/Owned.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DutchTokenSale is Owned {
    uint256 public startPrice;
    uint256 public endPrice;
    uint256 public tokensRemaining;
    IERC20 public collateral;
    IERC20 public asset;
    uint8 public assetDecimals;
    uint40 public startTime = type(uint40).max;
    uint40 public endTime;

    constructor(IERC20 collateral_, IERC20 asset_, uint8 assetDecimals_) Owned() {
        collateral = collateral_;
        asset = asset_;
        assetDecimals = assetDecimals_;
    }

    /**
     * @dev price_ is the price of 1 token in collateral tokens; has to be in the same decimals as collateral
     */
    function setSale(uint256 startPrice_, uint256 endPrice_, uint40 startTime_, uint40 endTime_, uint256 amount_)
        external
        onlyOwner
    {
        require(block.timestamp < startTime, "Sale has already started");
        require(startTime < endTime, "Start must be before end");
        startPrice = startPrice_;
        endPrice = endPrice_;
        startTime = startTime_;
        endTime = endTime_;
        tokensRemaining = amount_;
        asset.transferFrom(owner, address(this), amount_);
    }

    function buyTokens(uint256 amount) external {
        require(block.timestamp >= startTime, "Sale has not started");
        require(block.timestamp <= endTime, "Sale has ended");
        require(tokensRemaining >= amount, "Not enough tokens remaining");
        require(
            collateral.transferFrom(msg.sender, address(this), amount * _getPrice() / assetDecimals),
            "Collateral Transfer failed"
        );
        require(asset.transfer(msg.sender, amount), "Asset Transfer failed");
        tokensRemaining -= amount;
    }

    function currentPrice() external view returns (uint256) {
        return _getPrice();
    }

    function _getPrice() internal view returns (uint256) {
        if (block.timestamp >= endTime) {
            return endPrice;
        }
        if (block.timestamp <= startTime) {
            return startPrice;
        }
        return endPrice - (startPrice - endPrice) * (endTime - block.timestamp) / (endTime - startTime);
    }

    function withdraw() external onlyOwner {
        require(block.timestamp > endTime, "Sale has not ended");
        asset.transfer(owner, asset.balanceOf(address(this)));
        collateral.transfer(owner, collateral.balanceOf(address(this)));
    }
}
