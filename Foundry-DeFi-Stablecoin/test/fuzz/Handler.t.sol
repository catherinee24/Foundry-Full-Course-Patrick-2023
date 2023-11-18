//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test } from "forge-std/Test.sol";
import { CSCEngine } from "../../src/CSCEngine.sol";
import { DecentralizedStableCoin } from "../../src/DecentralizedStableCoin.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract Handler is Test {
    CSCEngine cscEngine;
    DecentralizedStableCoin cscToken;

    constructor(CSCEngine _cscEngine, DecentralizedStableCoin _cscToken) {
        cscEngine = _cscEngine;
        cscToken = _cscToken;
    }

    function depositCollateral(uint256 _collateralSeed, uint256 _amountCollateral) public {
        cscEngine.depositCollateral(_collateral, _amountCollateral);
    }

    //Helper function
    function _getCollateralFromSeed(uint256 _collateralSeed) private view returns (ERC20Mock){}
}
