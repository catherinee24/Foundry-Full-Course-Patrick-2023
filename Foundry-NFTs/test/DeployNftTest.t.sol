// SPDX-License-Indetifier: MIT

pragma solidity ^0.8.19;

import { Test, console } from "forge-std/Test.sol";
import { DeployMoodNft } from "../script/DeployMoodNft.s.sol";
import { MoodNft } from "../src/MoodNft.sol";

contract DeployNftTest is Test {
    DeployMoodNft public deployer;

    function setUp() public {
        deployer = new DeployMoodNft();
    }

    function testConvertSvgToUri() public { }
}
