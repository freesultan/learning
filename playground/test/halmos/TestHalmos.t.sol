// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {SymTest} from "halmos-cheatcodes/SymTest.sol";
import {Test} from "forge-std/Test.sol";
import {MyToken} from "../../src/basicERCtoken.sol";
import {Multiply} from "../../src/multiply.sol";


contract MyTokenTest is SymTest, Test {
    MyToken token;
    Multiply multiply;
    function setUp() public {
        //uint256 initialSupply = svm.createUint256("initialSupply");
        uint256 initialSupply = 10000000000000;
        token = new MyToken(initialSupply);
        multiply = new Multiply();
    }

    function test_multiply(uint96 price, uint32 quantity) public {
        
        uint128 total = multiply.totalPriceBuggy(price, quantity);

        assert(quantity == 0 || total >= price);
    }

    function check_multiply() public {
       // Use the svm.create* methods since your version of Halmos uses this API
        uint96 price = uint96(svm.createUint256("price"));
        uint32 quantity = uint32(svm.createUint256("quantity"));

        uint128 total = multiply.totalPriceBuggy(price, quantity);

        assert(quantity == 0 || total >= price);
    }



    function check_transfer() public {

        address sender = svm.createAddress("sender");
        address receiver= svm.createAddress("receiver");
        uint256 amount = svm.createUint256("amount");


        // specify input conditions
        vm.assume(receiver != address(0)); //@> always use vm.assume() instead of bound()
        vm.assume(token.balanceOf(sender) >= amount);
        vm.assume(sender != receiver);
        
        // record the current balance of sender and receiver
        uint256 balanceOfSender = token.balanceOf(sender);
        uint256 balanceOfReceiver = token.balanceOf(receiver);



        // call target contract
        vm.prank(sender);
        token.transfer(receiver, amount);

        //@> If your goal is to check whether the target contract reverts under the expected conditions, a low-level call should be used

        /* 
        vm.prank(sender);
        (bool succes,) = address(token).call(abi.encodeWithSelector(token.transfer.selector, receiver, amount));
        if (!sucess) {
        
        }

        */
        // check output state
        assert(token.balanceOf(sender) == balanceOfSender - amount);
        assert(token.balanceOf(receiver) == balanceOfReceiver + amount);
    }
}
