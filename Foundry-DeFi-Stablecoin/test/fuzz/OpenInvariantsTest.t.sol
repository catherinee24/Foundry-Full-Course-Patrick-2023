//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { StdInvariant } from "forge-std/StdInvariant.sol";
import { Test } from "forge-std/Test.sol";
import { DeployCSCEngine } from "../../script/DeployCSCEngine.s.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { CSCEngine } from "../../src/CSCEngine.sol";
import { DecentralizedStableCoin } from "../../src/DecentralizedStableCoin.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OpenInvariantsTest is StdInvariant, Test {
    DeployCSCEngine deployer;
    HelperConfig helperConfig;
    CSCEngine cscEngine;
    DecentralizedStableCoin cscToken;
    address weth;
    address wbtc;

    function setUp() external {
        deployer = new DeployCSCEngine();
        (cscToken, cscEngine, helperConfig) = deployer.run();
        (,, weth, wbtc,) = helperConfig.activeNetworkConfig();

        //Función del contrato `StdInvariant`
        targetContract(address(cscEngine));
    }

    /**
     * Obtenemos todo el valor del collateral que hay en el protocolo, y lo comparamos con toda la deuda (cscToken).
     */
    function invariant_protocolMustHaveMoreValueThanTotalSupply() public view {
        // TotalSupply de CSC StableCoin(deuda) que hay en el protocolo.
        uint256 totalSupply = cscToken.totalSupply();

        //Cantidad total de weth depositado al contrato `CSCEngine`.
        uint256 totalWethDeposited =IERC20(weth).balanceOf(address(cscEngine));
    }
}
