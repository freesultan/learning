// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.23;

import { Setup } from "./setup.sol";
import { Asserts } from "@chimera/Asserts.sol";
import { vm } from "@chimera/Hevm.sol";


abstract contract Properties is Setup, Asserts {
   
    
    function property_proposal_finish_reward_distributed() public returns(bool result) {
        uint256 proposalBalance = address(proposal).balance;

        result = (proposal.isActive() && proposalBalance > 0) || (!proposal.isActive() && proposalBalance ==0);

        return result;
    }

}