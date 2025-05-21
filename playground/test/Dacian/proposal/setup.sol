// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.23;

import {BaseSetup} from "@chimera/BaseSetup.sol";
import { vm } from "@chimera/Hevm.sol";

import {Proposal} from "../../../src/Dacian/proposal/proposal.sol";

abstract contract Setup is BaseSetup {
   
    Proposal proposal;
    address[] voters;

    address creator = address(0x1234);
    uint256 reward = 3 ether;


    function setup() internal virtual override {
      
        address voter01 = address(0x0001);
        address voter02 = address(0x0002);
        address voter03 = address(0x0003);
        address voter04 = address(0x0004);
        address voter05 = address(0x0005);
        voters.push(voter01);
        voters.push(voter02);
        voters.push(voter03);
        voters.push(voter04);
        voters.push(voter05);
            
        
        vm.prank(creator);
        proposal = new Proposal{value: reward }(voters);

        vm.prank(voters[0]);
        proposal.vote(true);

        vm.prank(voters[1]);
        proposal.vote(true);



    }
}