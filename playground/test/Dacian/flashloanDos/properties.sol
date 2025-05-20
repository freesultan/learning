// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Setup } from "./setup.sol";
import { Asserts } from "@chimera/Asserts.sol";
import { vm } from "@chimera/Hevm.sol";

abstract contract Properties is Setup, Asserts {

//Regular, black list
    function property_receiver_can_take_flash_loan() public returns (bool result) {
        try this.attempt_flash_loan() {
            result = true;
        } catch {
            result = false;
        }
    }

    function attempt_flash_loan() public {
        vm.prank(owner);
        receiver.executeFlashLoan(10);
    }
     //Regular, white list
    function property_pool_bal_equal_token_pool_bal() public view returns(bool result) {
        result = pool.poolBalance() == token.balanceOf(address(pool));
    }
}