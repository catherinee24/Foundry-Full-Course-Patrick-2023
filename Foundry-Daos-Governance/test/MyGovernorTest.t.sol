// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import { Test, console } from "forge-std/Test.sol";
import { Box } from "../src/Box.sol";
import { GovernanceToken } from "../src/GovernanceToken.sol";
import { MyGovernor } from "../src/MyGovernor.sol";
import { TimeLock } from "../src/TimeLock.sol";

contract MyGovernorTest is Test {
    Box box;
    GovernanceToken governanceToken;
    MyGovernor myGovernor;
    TimeLock timeLock;

    address[] proposers;
    address[] executors;

    address VOTER = address(1);
    uint256 public constant INITIAL_SUPPLY = 100 ether;
    uint256 public constant MIN_DELAY = 3600 seconds; //1 hora: después de que una votación sea aprobada, tienes 1 hora antes de poder votar.

    // Le minteamos algo de tokens a VOTER
    //llamamos a la funcion delegate de el archivo Votes.sol heredado por GovernanceToken, para delegarle los tokens
    // a nosotros mismos 
    function setUp() public {
        governanceToken = new GovernanceToken();
        governanceToken.mint(VOTER, INITIAL_SUPPLY);
        vm.startPrank(VOTER);
        governanceToken.delegate(VOTER);

        timeLock = new TimeLock(MIN_DELAY, proposers, executors);
    }
}
