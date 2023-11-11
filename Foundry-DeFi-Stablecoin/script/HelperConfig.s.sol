// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { CSCEngine } from "../src/CSCEngine.sol";
import { DecentralizedStableCoin } from "../src/DecentralizedStableCoin.sol";
import { MockV3Aggregator } from "../test/mocks/MockV3Aggregator.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

/**
 * /// @title HelperConfig
 * /// @author Catherine Maverick from CatellaTech.
 * /// @notice Facilita la gestión de configuraciones de red para diferentes entornos, ofreciendo la posibilidad de
 * obtener configuraciones predefinidas o crearlas dinámicamente para entornos de desarrollo específicos.
 * ///@dev Se utiliza MockV3Aggregator(Chainlink) y ERC20Mock(Openzeppelin).
 */

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                CONSTANT VARIABLES 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    uint8 public constant DECIMALS = 8;
    int256 public constant ETH_USD_PRICE = 2000e8;
    int256 public constant BTC_USD_PRICE = 1000e8;

    uint256 public constant DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                DATA STRUCTURE
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    /**
     * @notice struct NetworkConfig, se utiliza para organizar y estructurar diferentes direcciones de contratos y
     * claves en un solo tipo de dato personalizado. Este tipo de estructura es comúnmente usado para almacenar datos
     * relacionados y acceder a ellos de manera más organizada.
     */
    struct NetworkConfig {
        address wethUsdPriceFeed;
        address wbtcUsdPriceFeed;
        address weth;
        address wbtc;
        uint256 deployerKey;
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                FUNCTIONS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    constructor() {
        if (block.chainid == 11_155_111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    /**
     * @notice Función diseñada para proporcionar una forma estructurada y predefinida de obtener la configuración de
     * la red Sepolia en lo que respecta a contratos de tokens (WETH y WBTC) y feeds de precios en dólares.
     */
    function getSepoliaEthConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            wethUsdPriceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306,
            wbtcUsdPriceFeed: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43,
            weth: 0xdd13E55209Fd76AfE204dBda4007C227904f0a81,
            wbtc: 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063,
            deployerKey: vm.envUint("PRIVATE_KEY")
        });
    }

    /**
     * @notice Esta función intenta obtener la configuración actual relacionada con contratos de tokens en la red de
     * Anvil para Ethereum. Si la configuración ya está definida, simplemente la devuelve. Si no está definida, crea
     * nuevos contratos de prueba para los feeds de precios y tokens y devuelve esta nueva configuración para su uso
     * posterior.
     */
    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.wethUsdPriceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator ethUsdPriceFeed = new MockV3Aggregator(DECIMALS, ETH_USD_PRICE);
        ERC20Mock wETHMock = new ERC20Mock();

        MockV3Aggregator btcUsdPriceFeed = new MockV3Aggregator(DECIMALS, BTC_USD_PRICE);
        ERC20Mock wBTCMock = new ERC20Mock();
        vm.stopBroadcast();

        return NetworkConfig({
            wethUsdPriceFeed: address(ethUsdPriceFeed),
            wbtcUsdPriceFeed: address(btcUsdPriceFeed),
            weth: address(wETHMock),
            wbtc: address(wBTCMock),
            deployerKey: DEFAULT_ANVIL_PRIVATE_KEY
        });
    }
}
