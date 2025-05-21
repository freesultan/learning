// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;


import { Properties } from "./properties.sol";
import { BaseTargetFunctions } from "@chimera/BaseTargetFunctions.sol";
import { vm } from "@chimera/Hevm.sol";


abstract contract TargetFunctions is Properties, BaseTargetFunctions {
    

    function handler_vote(uint256 voterIndex, bool vote) public {
        voterIndex = between(voterIndex, 0 , voters.length -1);
        address voter = voters[voterIndex];

        vm.prank(voter);

        proposal.vote(vote);
    }
}