// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {UnstoppableLender} from "../../../src/Dacian/flashloanDos/UnstoppableLender.sol";
import {ReceiverUnstoppable} from "../../../src/Dacian/flashloanDos/ReceiverUnstoppable.sol";
import {BaseSetup} from "@chimera/BaseSetup.sol";
import {ERC20Mock} from "./ERC20Mock.sol";
import {vm} from "@chimera/Hevm.sol";

abstract contract Setup is BaseSetup {
    // contracts being tested
    ERC20Mock token;
    UnstoppableLender pool;
    ReceiverUnstoppable receiver;

    // test users
    address owner = address(0x1111);
    address user1 = address(0x2222);
    address user2 = address(0x3333);
    address[] users;

    // initial values
    uint256 constant INITIAL_TOKEN_SUPPLY = 1_000_000 ether;
    uint256 constant INITIAL_POOL_DEPOSIT = 100_000 ether;

    function setup() internal virtual override {
        // Setup users
        users.push(owner);
        users.push(user1);
        users.push(user2);

        vm.prank(owner);

        // Deploy mock token
        token = new ERC20Mock(
            "Damn Valuable Token",
            "DVT",
            owner,
            INITIAL_TOKEN_SUPPLY
        );
        vm.prank(owner);

        // Deploy pool and receiver
        pool = new UnstoppableLender(address(token));

        vm.prank(owner);

        receiver = new ReceiverUnstoppable(address(pool));

        vm.prank(owner);

        // Initial deposit to the pool
        token.approve(address(pool), INITIAL_POOL_DEPOSIT);

        vm.prank(owner);

        pool.depositTokens(INITIAL_POOL_DEPOSIT);

        vm.prank(owner);

        // Distribute some tokens to users
        token.transfer(user1, 10_000 ether);

        vm.prank(owner);

        token.transfer(user2, 10_000 ether);
    }
}
