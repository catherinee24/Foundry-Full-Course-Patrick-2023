// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";

/**
 * @title A Sample Raffle Smart Contract Deploy
 * @author Catherine Maverick
 * @notice This contract is for creating a sample Raffle Smart Contract Script Deploy.
 */
contract DeployRaffle is Script {
    function run() external returns (Raffle) {}
}
