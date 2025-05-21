// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.23;

import {BaseSetup} from "@chimera/BaseSetup.sol";
import { vm } from "@chimera/hevm.sol";

import {Proposal} from "../../../src/Dacian/proposal/proposal.sol";

abstract contract Setup is BaseSetup {
   
    Proposal proposal;
    address[] voters;

    address creator = address("creator");
    uint256 reward = 3 eth;


    function setup() internal virtual override {

        for(uint i=0;i<5;i++){
            voters[i] = address(i+1);
        }
        vm.prank(creator);
        proposal = new Proposal{value: reward }(voters);

        vm.prank(voters[0]);
        proposal.vote(1);


        vm.prank(voters[1]);
        proposal.vote(1);



        vm.prank(voters[2]);
        proposal.vote(1);

    }
}