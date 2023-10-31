//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/base64.sol";

contract MoodNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_sadSvgImageURI;
    string private s_happySvgImageURI;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;
    constructor(
        string memory _sadSvgImageURI,
        string memory _happySvgImageURI
    ) ERC721("Mood Nft", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageURI = _sadSvgImageURI;
        s_happySvgImageURI = _happySvgImageURI;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter]= Mood.HAPPY;
        s_tokenCounter++;
    }

    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        //Este va a ser el Metadata de nuestro Token.
        string memory tokenMetadata = string.concat(
            '{"name": "',
            name(),
            '", "description": "An Nft that reflects the owners mood.", "attributes": [{"trait_type": "moodiness", "value": 100}], "image": "',
            imageURI,
            '"}'
        );
    }
}
