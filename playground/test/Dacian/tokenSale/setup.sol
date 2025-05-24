// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;
import {TestToken} from "./testToken.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import {TokenSale} from "../../../src/Dacian/tokenSale/tokenSale.sol";
import "forge-std/Test.sol";

 contract tokensaleSetUp is Test {  

   
    uint8  constant SELL_DECIMALS = 18;
    uint8  constant BUY_DECIMALS  = 6;

    // total tokens to sell
    uint256  constant SELL_TOKENS = 1000e18;

    // buy tokens to give each buyer
    uint256  constant BUY_TOKENS  = 500e6;

    // number of buyers allowed in the token sale
    uint8  constant NUM_BUYERS    = 5;

    // max each buyer can buy
    uint256  constant MAX_TOKENS_PER_BUYER = 200e18;

    // allowed buyers
    address[] buyers;

    ERC20 sellToken;
    ERC20 buyToken;
    TokenSale tokenSale;


    function setUp() public  {

            sellToken = new TestToken(SELL_TOKENS, SELL_DECIMALS);
            buyToken  = new TestToken(BUY_TOKENS*NUM_BUYERS, BUY_DECIMALS);


        // setup the allowed list of buyers
        buyers.push(address(0x1));
        buyers.push(address(0x2));
        buyers.push(address(0x3));
        buyers.push(address(0x4));
        buyers.push(address(0x5));

        assert(buyers.length == NUM_BUYERS);

                // setup contract to be tested
        tokenSale = new TokenSale(buyers,
                                  address(sellToken),
                                  address(buyToken),
                                  MAX_TOKENS_PER_BUYER,
                                  SELL_TOKENS);

        // fund the contract
        sellToken.transfer(address(tokenSale), SELL_TOKENS);


        // verify setup
        //
        // token sale tokens & parameters
        assert(sellToken.balanceOf(address(tokenSale)) == SELL_TOKENS);
        assert(tokenSale.getSellTokenTotalAmount() == SELL_TOKENS);
        assert(tokenSale.getSellTokenAddress() == address(sellToken));
        assert(tokenSale.getBuyTokenAddress() == address(buyToken));
        assert(tokenSale.getMaxTokensPerBuyer() == MAX_TOKENS_PER_BUYER);
        assert(tokenSale.getTotalAllowedBuyers() == NUM_BUYERS);


        // no tokens have yet been sold
        assert(tokenSale.getRemainingSellTokens() == SELL_TOKENS);

        // this contract is the creator
        assert(tokenSale.getCreator() == address(this));

        // constrain fuzz test senders to the set of allowed buying addresses
        for(uint256 i; i<buyers.length; ++i) {
            address buyer = buyers[i];

            // add buyer to sender list
            targetSender(buyer);

            // distribute buy tokens to buyer
            buyToken.transfer(buyer, BUY_TOKENS);
            assert(buyToken.balanceOf(buyer) == BUY_TOKENS);

            // buyer approves token sale contract to prevent reverts
            vm.prank(buyer);
            buyToken.approve(address(tokenSale), type(uint256).max);
        }

        // no buy tokens yet received, all distributed to buyers
          assert(buyToken.balanceOf(address(this)) == 0);



    }
}