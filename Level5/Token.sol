// You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands 
// on any additional tokens. Preferably a very large amount of tokens.


// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Token {

  mapping(address => uint) balances;
  uint public totalSupply;

  constructor(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
}

/** First thing we see is the solidity version, below 0.8.0, we know we can exploit arithmetics functions.

Looking at the transfer function, we notice that the require will always be true, because the balances works 

with uint (unsigned integers), meaning above zero, no negatives numbers. The _value variable is also an uint. 

So, the result between these two will also be a uint, again, a number equal or greater than zero. 

We conclude that this logic does not make sense and we can exploit it by manipulating our balance. 

We have in our balance 20 tokens. If call the transfer function like this: 

await contract.transfer(”0x0000000000000000000000000000000000000000”, 21)

We send 21 tokens to the address zero, it does not matter where do we send it though, and the result of the 

require will be: 20 - 21 = maxUintNumber (which obviously is greater than zero). And the same will happen to our balance */