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
        vm.prank(msg.sender);
        token.transfer(cathe, STARTING_BALANCE);
    }

    function testCatheBalance() public {
        assertEq(STARTING_BALANCE, token.balanceOf(cathe));
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;
        uint256 transferAmount = 500;

        //Cathe le aprueva a Gabi gastar token a su nombre.
        vm.prank(cathe);
        token.approve(gabi, initialAllowance);

        //Gabi gasta la mitad de los tokens de cathe.
        vm.prank(gabi);
        token.transferFrom(cathe, gabi, transferAmount);

        assertEq(token.balanceOf(gabi), transferAmount);
        assertEq(token.balanceOf(cathe), STARTING_BALANCE - transferAmount);
    }
}
