// File: test/InsufficientAllocation.t.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;
import "forge-std/Test.sol";
import {InsufficientAllocation} from "../src/assembly/InsufficientAllocation.sol";

contract InsufficientAllocationTest is Test {
    InsufficientAllocation target = new InsufficientAllocation();
    function test_corruption() public {
        uint256 badLen = target.breakIt();
        assertEq(badLen, 1); // FAILS – should be 1, is huge
    }
}