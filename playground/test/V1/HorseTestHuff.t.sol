// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

 
import {BaseTest, HorseStore} from "./HorseStoreBase.t.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

contract HorseTestHuff is BaseTest {
         string public constant HORSE_STORE_HUFF_LOCATION = "HorseStore"; //scr address
   function setUp() public override {

    horsestore = HorseStore(HuffDeployer.config().deploy(HORSE_STORE_HUFF_LOCATION));
 
  }
}