// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Multiply {
     function totalPriceBuggy(uint96 price, uint32 quantity) external pure returns (uint128) {
        unchecked {
            return uint120(price) * quantity; // buggy type casting: uint120 vs uint128
        }
    }
}
