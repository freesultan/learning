// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { TargetFunctions } from "./targetFunctions.sol";
import { FoundryAsserts } from "@chimera/FoundryAsserts.sol";
import { Test } from "forge-std/Test.sol";

contract ProposalInvariantTest is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
        setup();

        // Target the fuzzer on this contract as it contains the handler functions
        targetContract(address(this));

        // Handler functions to target during invariant tests
        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = this.handler_vote.selector;
        

        targetSelector(FuzzSelector({ addr: address(this), selectors: selectors }));
    }

    // Wrap every "property_*" invariant function into a Foundry-style "invariant_*" function
    function invariant_proposal_finish_reward_distributed() public {
        assertTrue(property_proposal_finish_reward_distributed());
    }
    
    
}