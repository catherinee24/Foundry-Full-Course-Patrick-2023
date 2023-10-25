//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {OurBasicNFTToken} from "../src/OurBasicNFTToken.sol";
import {DeployOurBasicNFTToken} from "../script/DeployOurBasicNFTToken.s.sol";

contract OurBasicNFTTokenTest is Test {
    OurBasicNFTToken public nftToken;
    DeployOurBasicNFTToken public deployer;

    address public cathe = makeAddr("Cathe");
    address public gabi = makeAddr("Gabi");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurBasicNFTToken();
        nftToken = deployer.run();
    }
}
