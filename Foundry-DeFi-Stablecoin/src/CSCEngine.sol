// SPDX License-Indentifier: MIT

pragma solidity ^0.8.18;

/// @title CSCEngine (Catella StableCoin Engine)
/// @author Catherine Maverick from catellatech.
/// The system is designed to be as minimal as possible, and have the token mantain 1 Token == $1 peg.
/// This Stablecoin has the properties:
/// - Exogenous Collateral (wBTC - wETH)
/// - Dollar pegged
/// - Algoritmically stable
/// It is similar to DAI if DAI had no governance, no fees, and was only backed by WETH and WBTC.
/// Our CSC system should always be (Overcollateralized). At no point, should the value of all collateral <= the $ backed value of all the CSC. (Siempre tenemos que tener mas WBTC O WETH que CSC).
/// @notice This contract is the core of the CSC system. It handles all the logic for minting and redeeming CSC, as well
/// as depositing and withdrawing collateral.
/// @notice This contract is very loosely based on the MakerDAO DSS (DAI) system.

contract CSCEngine {
    function depositCollateralAndMintCsc() external {}
    function redeemCollateralForCsc() external {}
    function burnCsc() external {}
    function liquidate() external {}
    function getHealthFactor() external view {}
 }
