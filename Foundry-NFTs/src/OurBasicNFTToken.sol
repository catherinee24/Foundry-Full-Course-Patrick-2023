//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract OurBasicNFTToken is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;

    constructor() ERC721("MavericksDoggies", "MDGS") {
        s_tokenCounter = 0;
    }

    /// @dev _safeMint funcion de la implentacion de OZ ERC721.sol
    function mint(string memory _tokenURI) public {
        s_tokenIdToUri[s_tokenCounter] = _tokenURI;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        return s_tokenIdToUri[_tokenId];
    }
}
