// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Properties } from "./properties.sol";
import { TargetFunctions } from "./TargetFunctions.sol";
import { HalmosAsserts } from "@chimera/HalmosAsserts.sol";

contract HalmosUnstoppableLenderTest is TargetFunctions, HalmosAsserts {
    function prove_invariants(uint8 actionType, uint256 userIndex, uint256 amount) public {
        // Run setup first
        setup();
        
        // Normalize the userIndex to be within bounds of our users array
        // We use a helper function from TargetFunctions: between(min, max)
        userIndex = between(userIndex, 0, users.length - 1);
        
        // Choose action based on symbolic input
        if (actionType == 0) {
            // Important: Use the exact function signature from targetFunctions.sol
            handler_depositTokens(userIndex, amount);
        } else if (actionType == 1) {
            handler_directTokenTransfer(userIndex, amount);
        } else if (actionType == 2) {
            handler_executeFlashLoan(amount);
        }
        
        // Check invariants
        assertTrue(property_pool_bal_equal_token_pool_bal());
        assertTrue(property_receiver_can_take_flash_loan());
    }
}