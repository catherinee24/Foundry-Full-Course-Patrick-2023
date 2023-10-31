//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import { Script } from "forge-std/Script.sol";
import { OurBasicNFTToken } from "../src/OurBasicNFTToken.sol";

contract DeployOurBasicNFTToken is Script {
    function run() external returns (OurBasicNFTToken) {
        vm.startBroadcast();
        OurBasicNFTToken nftToken = new OurBasicNFTToken();
        vm.stopBroadcast();
        return nftToken;
    }
}
