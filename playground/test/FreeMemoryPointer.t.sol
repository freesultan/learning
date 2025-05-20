// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";

// separate contracts accessed via interfaces
// prevents the optimizer from being "too smart", helping
// to better approximate real-world execution
interface IInfoRetriever {
    function getVal() external returns(uint256);
}

// this contract gets used to return additional
// values required by the primary computation
contract InfoRetriever is IInfoRetriever {
    uint256 returnVal = 3;

    function setVal(uint256 newVal) public {
        returnVal = newVal;
    }

    function getVal() external view returns(uint256) {
       return returnVal;
    }
}

interface IHasher {
    function hashInputs(uint256 a, uint256 b, uint256 additionalInputCount) external returns(bytes32 result);
}

// actual implementation that computes a hash of
// two primary inputs and an optional number of
// secondary inputs
contract HasherImpl is IHasher {

    // used to retrieve optional number of secondary inputs
    IInfoRetriever infoRetriever;

    constructor(IInfoRetriever _infoRetriever) {
        infoRetriever = _infoRetriever;
    }

    function _getSecondaryInputs(uint256 dataPtr, uint256 inputsToFetch) private returns(uint256) {
        for(uint256 i; i<inputsToFetch; i++) {
            // make external call to retrieve the data
            uint256 input = infoRetriever.getVal();

            assembly {
                // for each additional input, store it into memory
                // at next free memory address
                mstore(dataPtr, input)

                // update pointer to subsequent next free memory address
                dataPtr := add(dataPtr, 0x20)
            }
        }

        // returns updated dataPtr
        return dataPtr;
    }

    function hashInputs(uint256 a, uint256 b, uint256 additionalInputCount) external returns(bytes32 result) {
        uint256 dataPtr;

        assembly {
            // read free memory pointer to find next free memory address
            dataPtr := mload(0x40)

            // store `a` in memory at next free memory address
            mstore(dataPtr, a)

            // update pointer to subsequent next free memory address
            dataPtr := add(dataPtr, 0x20)

            // store `b` in memory at next free memory address
            mstore(dataPtr, b)

            // update pointer to subsequent next free memory address
            dataPtr := add(dataPtr, 0x20)
        }

        // get the additional input from the info retriever, passing the updated
        // `dataPtr` so any new elements will be saved in subsequent free memory
        // addresses
        dataPtr = _getSecondaryInputs(dataPtr, additionalInputCount);

        // compute hash of all inputs
        assembly {
            let startPtr := mload(0x40)
            result := keccak256(startPtr, sub(dataPtr, startPtr))
        }
    }
}

// test harness
contract HasherTest is Test {

    IInfoRetriever infoRetriever = new InfoRetriever();
    IHasher hasher = new HasherImpl(infoRetriever);
    uint256 a = 1;
    uint256 b = 2;

    function test_HashWithoutAdditionalInput() external {
        // works great
        bytes32 result = hasher.hashInputs(a, b, 0);

        assertEq(result, keccak256(abi.encode(1, 2)));
    }

    function test_HashWithAdditionalInput() external {
        // fails due to calculating incorrect hash
        bytes32 result = hasher.hashInputs(a, b, 1);

        assertEq(result, keccak256(abi.encode(1, 2, 3)));   
    }
}
