// SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import { TimelockController } from "@openzeppelin/contracts/governance/TimelockController.sol";

contract TimeLock is TimelockController {
    ///minDelay Tiempo que debe de esperar una address antes de ejecutar.
    ///proposers Lista de direcciones que pueden proponer.
    ///executors Lista de direcciones que pueden ejecutar.
    constructor(
        uint256 minDelay,
        address[] memory proposers,
        address[] memory executors
    )
        TimelockController(minDelay, proposers, executors, msg.sender)
    { }
}
