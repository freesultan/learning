// File: test/MemoryCorruptionExternalCall.t.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;
import "forge-std/Test.sol";
import {MemoryCorruptionExternalCall, InfoRetriever} from "../src/assembly/MemoryCorruptionExternalCall.sol";

contract MemoryCorruptionExternalCallTest is Test {
    InfoRetriever info = new InfoRetriever();
    MemoryCorruptionExternalCall target;
    function setUp() public { target = new MemoryCorruptionExternalCall(info); }

    function test_noExtra() public {
        bytes32 got = target.hashInputs(1, 2, 0);
        assertEq(got, keccak256(abi.encode(1, 2)));
    }

    function test_extra() public {
        bytes32 got = target.hashInputs(1, 2, 1);
        assertEq(got, keccak256(abi.encode(1, 2, 3))); // currently FAILS
    }
}