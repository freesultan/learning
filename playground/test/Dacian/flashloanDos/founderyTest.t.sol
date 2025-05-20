// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { TargetFunctions } from "./TargetFunctions.sol";
import { FoundryAsserts } from "@chimera/FoundryAsserts.sol";
import { Test } from "forge-std/Test.sol";

contract UnstoppableLenderTest is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
        setup();

        // Target the fuzzer on this contract as it contains the handler functions
        targetContract(address(this));

        // Handler functions to target during invariant tests
        bytes4[] memory selectors = new bytes4[](3);
        selectors[0] = this.handler_depositTokens.selector;
        selectors[1] = this.handler_directTokenTransfer.selector;
        selectors[2] = this.handler_executeFlashLoan.selector;

        targetSelector(FuzzSelector({ addr: address(this), selectors: selectors }));
    }

    // Wrap every "property_*" invariant function into a Foundry-style "invariant_*" function
    function invariant_receiver_can_take_flash_loan() public {
        assertTrue(property_receiver_can_take_flash_loan());
    }
    
    function invariant_pool_bal_equal_token_pool_bal() public {
        assertTrue(property_pool_bal_equal_token_pool_bal());
    }
}