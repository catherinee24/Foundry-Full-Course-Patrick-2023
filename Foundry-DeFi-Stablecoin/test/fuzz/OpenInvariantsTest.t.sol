//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { StdInvariant } from "forge-std/StdInvariant.sol";
import { Test } from "forge-std/Test.sol";
import { DeployCSCEngine } from "../../script/DeployCSCEngine.s.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { CSCEngine } from "../../src/CSCEngine.sol";
import { DecentralizedStableCoin } from "../../src/DecentralizedStableCoin.sol";

contract OpenInvariantsTest is StdInvariant, Test {
    DeployCSCEngine deployer;
    HelperConfig helperConfig;
    CSCEngine cscEngine;
    DecentralizedStableCoin cscToken;

    function setUp() external {
        deployer = new DeployCSCEngine();
        (cscToken, cscEngine, helperConfig) = deployer.run();

        //Función del contrato `StdInvariant`
        targetContract(address(cscEngine));
    }

    function invariant_protocolMustHaveMoreValueThanTotalSupply() public view {}
}
