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

    uint256 MAX_DEPOSIT_SIZED = type(uint96).max; //El valor máximo de uint96

    constructor(CSCEngine _cscEngine, DecentralizedStableCoin _cscToken) {
        cscEngine = _cscEngine;
        cscToken = _cscToken;

        address[] memory collateralTokens = cscEngine.getCollateralTokens();
        weth = ERC20Mock(collateralTokens[0]);
        wbtc = ERC20Mock(collateralTokens[1]);
    }

    //La explicación del desarrollo de estas funciones están en `Notes3.md` 🤌
    function mintCsc(uint256 _amountToMint) public {
        _amountToMint = bound(_amountToMint, 1, MAX_DEPOSIT_SIZED);
        vm.startPrank(msg.sender);
        cscEngine.mintCsc(_amountToMint);
        vm.stopPrank();
    }

    function depositCollateral(uint256 _collateralSeed, uint256 _amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(_collateralSeed);

        //Queremos que el msg.sender deposite de 1 a type(96).max
        _amountCollateral = bound(_amountCollateral, 1, MAX_DEPOSIT_SIZED);

        vm.startPrank(msg.sender);
        collateral.mint(msg.sender, _amountCollateral);
        collateral.approve(address(cscEngine), _amountCollateral);
        cscEngine.depositCollateral(address(collateral), _amountCollateral);
        vm.stopPrank();
    }

    function redeemCollateral(uint256 _collateralSeed, uint256 _amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(_collateralSeed);
        uint256 maxCollateralToRedeem = cscEngine.getCollateralBalanceOfUsers(address(collateral), msg.sender);

        //Queremos que el msg.sender redima del 0 a la máxima cantidad que tenga depositado en el protocolo.
        //Empezamos desde 0 porque si el máxima valor es 0 se rompería si empezamos desde 1.
        _amountCollateral = bound(_amountCollateral, 0, maxCollateralToRedeem);
        if (_amountCollateral == 0) {
            return;
        }

        cscEngine.redeemCollateral(address(collateral), _amountCollateral);
    }

    /**
     * @notice la función elige dinámicamente entre dos tokens ERC-20 simulados (weth o wbtc) basándose en la paridad
     * de la semilla proporcionada. Si la semilla es par, devuelve el token asociado a weth; si es impar, devuelve el
     * token asociado a wbtc.
     * @param _collateralSeed Numero asociado al colateral.
     */
    function _getCollateralFromSeed(uint256 _collateralSeed) private view returns (ERC20Mock) {
        if (_collateralSeed % 2 == 0) {
            return weth;
        }
        return wbtc;
    }
}
