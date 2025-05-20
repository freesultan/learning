// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Properties } from "./properties.sol";
import { BaseTargetFunctions } from "@chimera/BaseTargetFunctions.sol";
import { vm } from "@chimera/Hevm.sol";

abstract contract TargetFunctions is BaseTargetFunctions, Properties {

    // Handler for depositing tokens to the lending pool
    function handler_depositTokens(uint256 userIndex, uint256 amount) public {
        userIndex = between(userIndex, 0, users.length - 1);
        address user = users[userIndex];
        
        // Get user's current token balance
        uint256 userBalance = token.balanceOf(user);
        if (userBalance == 0) return;
        
        // Bound the amount to something reasonable
        amount = between(amount, 1, userBalance);
        
        vm.prank(user);
        token.approve(address(pool), amount);
          vm.prank(user);

        pool.depositTokens(amount);
     }
    
    // Handler for direct token transfer (potential attack vector)
    function handler_directTokenTransfer(uint256 userIndex, uint256 amount) public {
        userIndex = between(userIndex, 0, users.length - 1);
        address user = users[userIndex];
        
        // Get user's current token balance
        uint256 userBalance = token.balanceOf(user);
        if (userBalance == 0) return;
        
        // Bound the amount to something reasonable
        amount = between(amount, 1, userBalance);
        
        vm.prank(user);
        token.transfer(address(pool), amount);
        // Note: This transfers tokens directly without updating poolBalance
    }
    
    // Handler for flash loan execution
    function handler_executeFlashLoan(uint256 amount) public {
        // Bound the amount to something reasonable
        uint256 poolBalance = token.balanceOf(address(pool));
        if (poolBalance == 0) return;
        
        amount = between(amount, 1, poolBalance);
        
        // Execute flash loan as the owner
        vm.prank(owner);
        try receiver.executeFlashLoan(amount) {
            // Flash loan succeeded
        } catch {
            // Flash loan failed
        }
    }
}