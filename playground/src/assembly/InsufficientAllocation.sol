// File: src/InsufficientAllocation.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

library Buffer {
    struct buffer { bytes buf; uint256 capacity; }

    function init(buffer memory b, uint256 cap) internal pure returns (buffer memory) {
        if (cap % 32 != 0) cap += 32 - (cap % 32);
        b.capacity = cap;
        assembly {
            let ptr := mload(0x40)
            mstore(b, ptr) // set b.buf pointer
            mstore(ptr, 0) // length = 0
            // TODO: FLAW – pointer advance ignores 32‑byte length slot
            mstore(0x40, add(ptr, cap))
        }
        return b;
    }

    function append(buffer memory b, bytes memory data) internal pure {
        uint256 off = b.buf.length;
        uint256 len = data.length;
        uint256 mask = 256 ** len - 1;
        bytes32 word;
        assembly { word := mload(add(data, 32)) }
        assembly {
            let bufptr := mload(b)
            let dest := add(add(bufptr, off), len)
            mstore(dest, or(and(mload(dest), not(mask)), word))
            if gt(add(off, len), mload(bufptr)) { mstore(bufptr, add(off, len)) }
        }
    }
}

contract InsufficientAllocation {
    using Buffer for Buffer.buffer;
    function breakIt() external pure returns (uint256 fooLen) {
        Buffer.buffer memory buff;
         buff.init(1);
        bytes memory foo = new bytes(1); // neighbour variable
        buff.append("A");                // corrupts foo.length
        return foo.length;
    }
}