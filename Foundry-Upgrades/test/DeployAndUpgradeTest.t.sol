// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { BoxV1 } from "../src/BoxV1.sol";
import { BoxV2 } from "../src/BoxV2.sol";
import { DeployBox } from "../script/DeployBox.s.sol";
import { UpgradeBox } from "../script/UpgradeBox.s.sol";

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

    function testProxyStartAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).getNumber(7);
    }

    function testUpgrades() public {
        BoxV2 boxV2 = new BoxV2();
        upgrader.upgradeBox(proxy, address(boxV2));
        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV2(proxy).version());

        BoxV2(proxy).getNumber(7);
        assertEq(7, BoxV2(proxy).getNumber());
    }
}
