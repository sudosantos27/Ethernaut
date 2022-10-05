// Claim ownership of the contract below to complete this level.


// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Telephone {

  address public owner;

  constructor() public {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}

/** Here the vulnerability can only be in the changeOwner function. More specifically, in the tx.origin function.

tx.origin and msg.sender sometimes can be the same. But, tx.origin is the first person that call the function of a contract, 

despite using an intermediary contract.

If we create a contract to interact with this function, msg.sender will be the attacker contract and tx.origin will be 

the one who calls the attacker contract. (it does not matter the address, it just needs to be different, and be have to 

pass our address to change the owner) */