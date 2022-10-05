// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.3.0/contracts/math/SafeMath.sol";


contract CoinFlip {

  using SafeMath for uint256;
  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor() public {
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue.div(FACTOR);
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}

/**To complete this level you'll need to use your psychic abilities to guess the correct outcome 10 times in a row.

This is way more complex than the previous one, we need to create a second contract to attack this one.

The point of failure is the variable blockValue, which is the blockhash of of the current block. This variable determines 

the side of the coin. We need to get this variable before using this contract.

To get the variable before, we need a second contract that uses the same logic and gets the blockValue and therefore, 

the side of the coin. Once we have the side, we pass it to the original contract */