//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public token;
    DeployOurToken public deployer;

    //Usarios que interactuen con nuestro token.
    address public cathe = makeAddr("cathe");
    address public gabi = makeAddr("gabi");

    uint256 public constant STARTING_BALANCE = 100 ether;
    
    function setUp() public {
        deployer = new DeployOurToken();
        token = deployer.run();

        //El que deploya es el Owner
        vm.prank(address(deployer));
        token.transfer(cathe, STARTING_BALANCE);
    }
}