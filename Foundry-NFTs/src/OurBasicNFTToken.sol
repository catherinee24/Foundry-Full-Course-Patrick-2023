//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract OurBasicNFTToken is ERC721 {
    uint256 private s_tokenCounter;

    constructor() ERC721("MavericksDoggies", "MDGS") {
        s_tokenCounter = 0;
    }

    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {}
}
