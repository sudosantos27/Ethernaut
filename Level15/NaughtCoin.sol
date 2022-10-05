/** NaughtCoin is an ERC20 token and you're already holding all of them. The catch is that you'll only 

be able to transfer them after a 10 year lockout period. Can you figure out how to get them out to another 

address so that you can transfer them freely? Complete this level by getting your token balance to 0. */


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";


contract NaughtCoin is ERC20 {

  // string public constant name = 'NaughtCoin';
  // string public constant symbol = '0x0';
  // uint public constant decimals = 18;
  uint public timeLock = block.timestamp + 10 * 365 days;
  uint256 public INITIAL_SUPPLY;
  address public player;

  constructor(address _player) 
  ERC20("NaughtCoin", "0x0")
  public {
    player = _player;
    INITIAL_SUPPLY = 1000000 * (10**uint256(decimals()));
    // _totalSupply = INITIAL_SUPPLY;
    // _balances[player] = INITIAL_SUPPLY;
    _mint(player, INITIAL_SUPPLY);
    emit Transfer(address(0), player, INITIAL_SUPPLY);
  }
  
  function transfer(address _to, uint256 _value) override public lockTokens returns(bool) {
    super.transfer(_to, _value);
  }

  // Prevent the initial owner from transferring tokens until the timelock has passed
  modifier lockTokens() {
    if (msg.sender == player) {
      require(block.timestamp > timeLock);
      _;
    } else {
     _;
    }
  } 
}

/** To beat this level you need to know how inheritance works. In this code, we import ERC20 from openzeppelin and inherit 

the contract. When we do that, all the functions from the inherited contracts are now in our contract. It does not matter 

it’s not written. So knowing this, we can use a function from ERC20.sol called transferFrom, that allow us to transfer the 

tokens form our address to another one. But first, we need to see how this function works. Looking at ERC20.sol code, we see 

that we need to approve a spender to send a token.

First we can check if the player is allowed to transfer token: Number(await contract.allowance(player, player))

This returns zero, meaning that the spender is allowed to spend 0 tokens.

To allow the player to send tokens: await contract.approve(player, "1000000000000000000000000")

Now we can transfer: await contract.transferFrom(player, "0x0000000000000000000000000000000000000001", "1000000000000000000000000") */