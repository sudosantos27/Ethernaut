// Unlock the vault to pass the level!


// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Vault {
  bool public locked;
  bytes32 private password;

  constructor(bytes32 _password) public {
    locked = true;
    password = _password;
  }

  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
}

/** Setting the visibility of a function or variable to `private`
 does not make it invisible on the blockchain. It simply restricts its access to functions within the contract.

To get a private variable we have to write in the console: await web3.eth.getStorageAt(contractAddress, Slot of variable)

In this case will be: await web3.eth.getStorageAt("0x0C4901D41Ad460Dc68A385559A6549042137D816", 1), because locked variable is in slot 0 and password in slot 1

We received the password but in hex, so we have to convert it to ASCII.

We store the hex value in a variable called pwd.

Now we do: web3.utils.toAscii(pwd)

However, to use the function we have to pass it to the function as a hex value 

contract.unlock(pwd)

It's important to remember that marking a variable as private only prevents other contracts from accessing it. State variables 

marked as private and local variables are still publicly accessible.

To ensure that data is private, it needs to be encrypted before being put onto the blockchain. In this scenario, the decryption 

key should never be sent on-chain, as it will then be visible to anyone who looks for it. [zk-SNARKs](https://blog.ethereum.org/2016/12/05/zksnarks-in-a-nutshell/) provide a way 

to determine whether someone possesses a secret parameter, without ever having to reveal the parameter. */