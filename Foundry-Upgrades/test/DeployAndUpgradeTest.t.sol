// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    addrees public proxy;
    address public OWNER = makeAddr("owner");
    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = new deployer.run(); //El proxy ahora mismo, apunta a BoxV1.
    }

    function testUpgrades() public {}
}