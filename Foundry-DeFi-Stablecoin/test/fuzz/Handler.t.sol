//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test } from "forge-std/Test.sol";
import { CSCEngine } from "../../src/CSCEngine.sol";
import { DecentralizedStableCoin } from "../../src/DecentralizedStableCoin.sol";

contract Handler is Test {
    CSCEngine cscEngine;
    DecentralizedStableCoin cscToken;

    constructor(CSCEngine _cscEngine, DecentralizedStableCoin _cscToken) {
        cscEngine = _cscEngine;
        cscToken = _cscToken;
    }
}
