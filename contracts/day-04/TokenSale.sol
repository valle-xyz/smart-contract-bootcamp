// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "contracts/day-02/Owned.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSale is Owned {
    uint256 public price;
    uint256 public tokensRemaining;
    IERC20 public collateral;
    IERC20 public asset;
    uint8 public assetDecimals;
    uint40 public start = type(uint40).max;
    uint40 public end;

    constructor(IERC20 collateral_, IERC20 asset_, uint8 assetDecimals_) Owned() {
        collateral = collateral_;
        asset = asset_;
        assetDecimals = assetDecimals_;
    }

    /**
     * @dev price_ is the price of 1 token in collateral tokens; has to be in the same decimals as collateral
     */
    function setSale(uint256 price_, uint40 start_, uint40 end_, uint256 amount_) external onlyOwner {
        require(block.timestamp < start, "Sale has already started");
        require(start < end, "Start must be before end");
        price = price_;
        start = start_;
        end = end_;
        tokensRemaining = amount_;
        asset.transferFrom(owner, address(this), amount_);
    }

    function buyTokens(uint256 amount) external {
        require(block.timestamp >= start, "Sale has not started");
        require(block.timestamp <= end, "Sale has ended");
        require(tokensRemaining >= amount, "Not enough tokens remaining");
        require(
            collateral.transferFrom(msg.sender, address(this), amount * price / assetDecimals),
            "Collateral Transfer failed"
        );
        require(asset.transfer(msg.sender, amount), "Asset Transfer failed");
        tokensRemaining -= amount;
    }

    function withdraw() external onlyOwner {
        require(block.timestamp > end, "Sale has not ended");
        asset.transfer(owner, asset.balanceOf(address(this)));
        collateral.transfer(owner, collateral.balanceOf(address(this)));
    }
}
