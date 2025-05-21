// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Properties } from "./properties.sol";
import { TargetFunctions } from "./targetFunctions.sol";
import { HalmosAsserts } from "@chimera/HalmosAsserts.sol";


contract HalmosProposalTest is HalmosAsserts,TargetFunctions {

   
    function prove_invariant(uint256 voterIndex, bool vote) public{

            setup();
            
            voterIndex = between(voterIndex, 2, voters.length - 1);
            handler_vote(voterIndex, vote);

            assertTrue(property_proposal_finish_reward_distributed());
    }
}