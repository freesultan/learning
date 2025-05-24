// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;
 
 import {tokensaleSetUp} from "./setup.sol";
import "forge-std/Test.sol";

contract foundryTest is Test, tokensaleSetUp  {


 
    // two possible invariants in order of importance:
    //
    // 1) the amount of tokens bought (received by this contract)
    //    should equal the amount of tokens sold as the exchange
    //    rate is 1:1, when accounted for precision difference
    function invariant_tokens_bought_eq_tokens_sold() public view {
        uint256 soldAmount = tokenSale.getSellTokenSoldAmount();
        uint256 boughtBal  = buyToken.balanceOf(address(this));

        // scale up `boughtBal` by the precision difference
        boughtBal *= 10 ** (SELL_DECIMALS - BUY_DECIMALS);

        // assert the equality; if this breaks that means something
        // has gone wrong with the buying and selling. In our private
        // audit there was a precision miscalculation that allowed
        // an attacker to buy the sale tokens without paying due to
        // rounding down to zero
        assert(boughtBal == soldAmount);
    }

    function invariant_buyer_bought_lt_max() public view {

        for (uint256 i; i <buyers.length; ++i) {
                address buyer = buyers[i];

                assert(sellToken.balanceOf(buyer) <= MAX_TOKENS_PER_BUYER);
        }
    }

}