// File: src/MemoryCorruptionExternalCall.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

interface IInfoRetriever { function getVal() external returns (uint256); }

contract InfoRetriever is IInfoRetriever { uint256 public returnVal = 3; function setVal(uint256 v) external { returnVal = v; } function getVal() external view returns (uint256) { return returnVal; } }

contract MemoryCorruptionExternalCall {
    IInfoRetriever public immutable info;
    constructor(IInfoRetriever _info) { info = _info; }

    function hashInputs(uint256 a, uint256 b, uint256 extra) external returns (bytes32 h) {
        uint256 ptr;
        uint256 startPtr; // we'll need this after the call
        assembly {
            ptr := mload(0x40)
            startPtr := ptr            // save start
            mstore(ptr, a)
            ptr := add(ptr, 0x20)
            mstore(ptr, b)
            ptr := add(ptr, 0x20)
            // TODO: update free‑memory pointer so external call cannot overwrite
            mstore(0x40,ptr)
        }
        for (uint256 i; i < extra; ++i) {
            uint256 x = info.getVal();//external call 
            assembly {
                mstore(ptr, x)
                ptr := add(ptr, 0x20)
            }
        }
        assembly {
            // TODO: use startPtr (not mload(0x40)) so hashing range is correct
            //h := keccak256(/* offset */, sub(ptr, /* offset */))
            h := keccak256(startPtr, sub(ptr, startPtr))
        }
    }
}