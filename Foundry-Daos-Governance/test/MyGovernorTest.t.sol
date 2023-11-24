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

    uint256[] values;
    bytes[] calldatas;
    address[] targets;

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
        myGovernor = new MyGovernor(governanceToken, timeLock);

        bytes32 proposerRole = timeLock.PROPOSER_ROLE();
        bytes32 executorRole = timeLock.EXECUTOR_ROLE();
        bytes32 adminRole = timeLock.DEFAULT_ADMIN_ROLE();

        // Solo el governor puede proponer cosas al timelock.
        // Nadie puede ejecutar proposals.
        // El VOTER no va a seguir siendo el admin.
        //grantRole -> Conceder Rol
        timeLock.grantRole(proposerRole, address(myGovernor));
        timeLock.grantRole(executorRole, address(0));
        timeLock.revokeRole(adminRole, VOTER);
        vm.stopPrank();

        box = new Box();
        box.transferOwnership(address(timeLock));
    }

    //Esto deberia pasar porque no puedes actualizar el box a menos que se a través del governor/Dao
    function testCannotUpdateBoxWithoutGovernance() public {
        vm.expectRevert();
        box.store(1);
    }

/** Governor.sol by Openzeppelin
    function _propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description,
        address proposer 
*/
    function testGovernanceUpdateBox() public {
        uint256 valueStore = 28;
        string memory description = "Store 1 in Box";
        bytes memory encodedFunctionCall = abi.encodeWithSignature("store(uint256)", valueStore);
        address proposer = address(timeLock);
        
        values.push(0);
        calldatas.push(encodedFunctionCall);
        targets.push(address(box));


    }
}
