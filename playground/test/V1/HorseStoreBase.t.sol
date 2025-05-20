// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;


import {Test, console2} from "forge-std/Test.sol";
import {HorseStore} from "../../src/HorseStore.sol";


abstract  contract BaseTest is Test {

    HorseStore public horsestore;

    function setUp() public virtual {
        horsestore = new HorseStore(); 
    }


    function testReadHorse() public {
        uint256 horseCounts = horsestore.readNumberOfHorses();
        assertEq(horseCounts, 0);
    }

    function testWriteHorse() public {
     uint256 count = 777; 
     horsestore.updateHorseNumber(count);
     assertEq(count, horsestore.readNumberOfHorses());
    }

    // function testfuzzWriteHorse (uint256 count) public {
    //     horsestore.updateHorseNumber(count);
    //  assertEq(count, horsestore.readNumberOfHorses());
    // }

}