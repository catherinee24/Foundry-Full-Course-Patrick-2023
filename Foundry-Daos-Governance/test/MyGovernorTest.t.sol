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
    uint256 public constant MIN_DELAY = 3600 seconds; //1 hora: después de que una votación sea aprobada, tienes 1
        // hora antes de poder votar.
    uint256 public constant VOTING_DELAY = 1; // Representa la cantidad de un bloque hasta que la votación esté activa.
    uint256 public constant VOTIN_PERIOD = 50_400; // 1 semana

    // Le minteamos algo de tokens a VOTER
    //llamamos a la funcion delegate de el archivo Votes.sol heredado por GovernanceToken, para delegarle los tokens
    // a nosotros mismos
    function setUp() public {
        governanceToken = new GovernanceToken();
        governanceToken.mint(VOTER, INITIAL_SUPPLY);

        vm.prank(VOTER);
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
        timeLock.revokeRole(adminRole, msg.sender);

        box = new Box();
        box.transferOwnership(address(timeLock));
    }

    //Esto deberia pasar porque no puedes actualizar el box a menos que se a través del governor/Dao
    function testCannotUpdateBoxWithoutGovernance() public {
        vm.expectRevert();
        box.store(1);
    }

    /**
     * Governor.sol by Openzeppelin
     * function propose(
     *     address[] memory targets,
     *     uint256[] memory values,
     *     bytes[] memory calldatas,
     *     string memory description
     * ) public virtual returns (uint256) {}
     */
    function testGovernanceUpdateBox() public {
        uint256 valueStore = 28;
        string memory description = "Store 1 in Box";
        bytes memory encodedFunctionCall = abi.encodeWithSignature("store(uint256)", valueStore);

        values.push(0);
        calldatas.push(encodedFunctionCall);
        targets.push(address(box));

        /**
         * 1. Hacemos la propuesta a la DAO.
         */
        uint256 proposalId = myGovernor.propose(targets, values, calldatas, description);

        // Podemos ver el estado de la propuesta. La propuesta estará pending.
        console.log("Proposal State: ", uint256(myGovernor.state(proposalId)));

        vm.warp(block.timestamp + VOTING_DELAY + 1);
        vm.roll(block.number + VOTING_DELAY + 1);

        // Podemos ver el estado de la propuesta. La propuesta estará active.
        console.log("Proposal State: ", uint256(myGovernor.state(proposalId)));

        /**
         *  2.Podemos empezar a votar.
         */
        string memory reason = "Because i wanna be a better dev and security researcher";

        // 0 = Against, 1 = For, 2 = Abstain for this example
        uint8 voteWay = 1;
        vm.prank(VOTER);
        myGovernor.castVoteWithReason(proposalId, voteWay, reason);

        vm.warp(block.timestamp + VOTIN_PERIOD + 1);
        vm.roll(block.number + VOTIN_PERIOD + 1);

        /**
         * 3. "Queue the txs"/poner en cola las transacciones
         * GovernorTomelockControl.sol by openzeppelin
         * function queue(
         *     address[] memory targets,
         *     uint256[] memory values,
         *     bytes[] memory calldatas,
         *     bytes32 descriptionHash
         * ) public virtual returns (uint256) {}
         */
        bytes32 descriptionHash = keccak256(abi.encodePacked(description));
        myGovernor.queue(targets, values, calldatas, descriptionHash);

        vm.warp(block.timestamp + MIN_DELAY + 1);
        vm.roll(block.number + MIN_DELAY + 1);

        /**
         * 4. Ejecutar la txs
         */
        myGovernor.execute(targets, values, calldatas, descriptionHash);

        console.log("Box Value: ", box.getNumber());
        assert(box.getNumber() == valueStore);
    }
}
