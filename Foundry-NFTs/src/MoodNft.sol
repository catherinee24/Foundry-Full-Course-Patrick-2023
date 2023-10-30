//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/base64.sol";


contract MoodNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_sadSvgImageURI;
    string private s_happySvgImageURI;

    constructor(string memory _sadSvgImageURI, string memory _happySvgImageURI) ERC721("Mood Nft", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageURI = _sadSvgImageURI;
        s_happySvgImageURI = _happySvgImageURI;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 _tokenId) public view override returns(string memory){

    }
}
