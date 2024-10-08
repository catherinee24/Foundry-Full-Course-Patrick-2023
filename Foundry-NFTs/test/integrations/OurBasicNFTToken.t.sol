//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import { Test } from "forge-std/Test.sol";
import { OurBasicNFTToken } from "../../src/OurBasicNFTToken.sol";
import { DeployOurBasicNFTToken } from "../../script/DeployOurBasicNFTToken.s.sol";

contract OurBasicNFTTokenTest is Test {
    OurBasicNFTToken public nftToken;
    DeployOurBasicNFTToken public deployer;

    address public USER = makeAddr("Cathe");
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurBasicNFTToken();
        nftToken = deployer.run();
    }

    /**
     * En el assert de esta funcion nos saldrá un error porque los String types no se pueden comparar.
     * Los Strings son un tipado especial, los strings types son un array de bytes.
     * Unicamente podemos comparar ----> uint256, address, bool.
     * Como podemos comparar strings?? ----> lo podemos hacer con un for (loop through the array) y luego comparar los
     * elementos del array.
     * Otra manera mas sencilla es usar abi.encodePacked() y tomar el hash.
     */
    function testNameIsCorrect() public view {
        string memory expectedName = "MavericksDoggies";
        string memory actualName = nftToken.name();
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        nftToken.mint(PUG);

        assert(nftToken.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(PUG)) == keccak256(abi.encodePacked(nftToken.tokenURI(0))));
    }
}
