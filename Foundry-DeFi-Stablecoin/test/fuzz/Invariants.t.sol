// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { StdInvariant } from "forge-std/StdInvariant.sol";
import { Test, console } from "forge-std/Test.sol";
import { DeployCSCEngine } from "../../script/DeployCSCEngine.s.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { CSCEngine } from "../../src/CSCEngine.sol";
import { DecentralizedStableCoin } from "../../src/DecentralizedStableCoin.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Handler } from "../../test/fuzz/Handler.t.sol";

contract Invariants is StdInvariant, Test {
    DeployCSCEngine deployer;
    HelperConfig helperConfig;
    CSCEngine cscEngine;
    DecentralizedStableCoin cscToken;
    Handler handler;
    address weth;
    address wbtc;

    function setUp() external {
        deployer = new DeployCSCEngine();
        (cscToken, cscEngine, helperConfig) = deployer.run();
        (,, weth, wbtc,) = helperConfig.activeNetworkConfig();

        // `targetContract()` Función del contrato `StdInvariant`
        // targetContract(address(cscEngine));
        handler = new Handler(cscEngine, cscToken);

        //Ahora nuestro contrato target será el `Handler` 
        targetContract(address(handler));
    }

    /**
     * Obtenemos todo el valor del collateral que hay en el protocolo, y lo comparamos con toda la deuda (cscToken).
     */
    function invariant_protocolMustHaveMoreValueThanTotalSupply() public view {
        // TotalSupply de CSC StableCoin(deuda) que hay en el protocolo.
        uint256 totalSupply = cscToken.totalSupply();

        //Cantidad total de weth y wbt depositado en el contrato `CSCEngine`.
        uint256 totalWethDeposited = IERC20(weth).balanceOf(address(cscEngine));
        uint256 totalWbtcDeposited = IERC20(wbtc).balanceOf(address(cscEngine));

        //Obteniendo los valores en usd de cada collateral.
        uint256 wethValue = cscEngine.getUsdValue(weth, totalWethDeposited);
        uint256 wbtcValue = cscEngine.getUsdValue(wbtc, totalWbtcDeposited);

        console.log("weth value: ", wethValue);
        console.log("wbtc value: ", wbtcValue);
        console.log("Total Supply: ", totalSupply);

        //Tenemos que tener más collateral en nuestro protocolo que csc(deuda).
        assert(wethValue + wbtcValue >= totalSupply);
    }
}
