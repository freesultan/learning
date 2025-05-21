// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Proposal} from "../../../src/Dacian/proposal/proposal.sol";
import {Test, console} from "forge-std/Test.sol";

/**
 * @title ProposalBugTest
 * @notice Direct test to demonstrate the fund distribution bug
 */
contract ProposalBugTest is Test {
    Proposal proposal;
    address[] voters;
    address creator;
    uint256 reward = 3 ether;
    
    function setUp() public {
        // Create 5 voters
        voters = new address[](5);
        for (uint i=0; i<5; i++) {
            voters[i] = address(uint160(i+1));
            vm.deal(voters[i], 1 ether); // Give them some ETH
        }
        
        creator = address(0x1234);
        vm.deal(creator, 10 ether); // Give creator some ETH
        
        // Create proposal
        vm.prank(creator);
        proposal = new Proposal{value: reward}(voters);
    }

    function test_rewardsBug() public {
        // Record initial balances
        uint256 initialContractBalance = address(proposal).balance;
        uint256[] memory initialVoterBalances = new uint256[](5);
        for (uint i=0; i<5; i++) {
            initialVoterBalances[i] = voters[i].balance;
        }
        
        // Have 3 people vote FOR and 2 vote AGAINST
        vm.prank(voters[0]);
        proposal.vote(true); // FOR
        
        vm.prank(voters[1]);
        proposal.vote(true); // FOR
        
        vm.prank(voters[4]);
        proposal.vote(false); // AGAINST
        
        // At this point, voting is complete, and rewards should be distributed
        
        // Check proposal state
        assertFalse(proposal.isActive(), "Proposal should be inactive");
        
        // Check contract balance - THIS WILL FAIL because of the bug!
        // assertEq(address(proposal).balance, 0, "Contract should have 0 balance after distribution");
        console.log("proposal balance: ", address(proposal).balance);
        // Calculate how much each FOR voter should receive (the bug causes incorrect distribution)
        uint256 expectedPerVoter = reward / 3;
        
        // Check balances of FOR voters
        for (uint i=0; i<3; i++) {
            uint256 balanceChange = voters[i].balance - initialVoterBalances[i];
            console.log("Voter", i, "received", balanceChange);
            // This will fail because of the bug!
            //assertEq(balanceChange, expectedPerVoter, "FOR voter did not receive correct reward");
        }
    }
}