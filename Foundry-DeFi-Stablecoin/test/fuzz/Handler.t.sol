//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test } from "forge-std/Test.sol";
import { CSCEngine } from "../../src/CSCEngine.sol";
import { DecentralizedStableCoin } from "../../src/DecentralizedStableCoin.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract Handler is Test {
    CSCEngine cscEngine;
    DecentralizedStableCoin cscToken;
    ERC20Mock weth;
    ERC20Mock wbtc;

    uint256 MAX_DEPOSIT_SIZED = type(uint96).max; //El valor maximos de uint96

    constructor(CSCEngine _cscEngine, DecentralizedStableCoin _cscToken) {
        cscEngine = _cscEngine;
        cscToken = _cscToken;

        address[] memory collateralTokens = cscEngine.getCollateralTokens();
        weth = ERC20Mock(collateralTokens[0]);
        wbtc = ERC20Mock(collateralTokens[1]);
    }

    function depositCollateral(uint256 _collateralSeed, uint256 _amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(_collateralSeed);
        _amountCollateral = bound(_amountCollateral, 1, MAX_DEPOSIT_SIZED);
        cscEngine.depositCollateral(address(collateral), _amountCollateral);
    }

    /**
     * @notice la función elige dinámicamente entre dos tokens ERC-20 simulados (weth o wbtc) basándose en la paridad de la semilla proporcionada. Si la semilla es par, devuelve el token asociado a weth; si es impar, devuelve el token asociado a wbtc.
     * @param _collateralSeed Numero asociado al colateral.
     */
    function _getCollateralFromSeed(uint256 _collateralSeed) private view returns (ERC20Mock) {
        if (_collateralSeed % 2 == 0) {
            return weth;
        }
        return wbtc;
    }
}
