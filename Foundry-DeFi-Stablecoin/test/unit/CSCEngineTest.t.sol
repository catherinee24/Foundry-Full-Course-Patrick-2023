// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { DeployCSCEngine } from "../../script/DeployCSCEngine.s.sol";
import { DecentralizedStableCoin } from "../../src/DecentralizedStableCoin.sol";
import { CSCEngine } from "../../src/DecentralizedStableCoin.sol";

contract CSCEngineTest is Test {
    DeployCSCEngine deployer;
    DecentralizedStableCoin csc;
    CSCEngine cscEngine;

    function setUp() public {
        deployer = new DeployCSCEngine();
        csc = new DecentralizedStableCoin();
        cscEngine = deployer.run();
    }
}
