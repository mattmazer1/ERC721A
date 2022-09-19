// SPDX-License-Identifier: MIT

 pragma solidity ^0.8.17;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Testing is ERC721A, Ownable {

    using Strings for uint256;
    uint256 maxSupply;
    string _baseTokenURI;
    mapping(address => uint256) public owner;
    bool URISetter;
    string URI1;

    constructor(string memory baseURI) ERC721A("Testing", "TEST") {
        maxSupply=20;
        URISetter = false;
        setBaseURI(baseURI);
        URI1 = "ipfs://Qmdp7fTb7f1gTEYe6JkC22h4jScuwqxMgpAFFpeUmrk8Tq/";
    }

    function mint(uint256 quantity) external payable {
        require(URISetter==true,"You haven't set the URI");
        require(quantity > 0, "You have to mint at least 1 token");
        require(totalSupply() + quantity <= maxSupply, "Exceeded max supply of tokens");
        owner[msg.sender]+=quantity;
        require(owner[msg.sender]<=4,"You can only mint 4 per wallet");
        _safeMint(msg.sender, quantity);

    }

    function setBaseURI(string memory baseURI) public onlyOwner {
            _baseTokenURI = baseURI;
            URISetter = true;
        }

    function _baseURI() internal view virtual override returns (string memory) { 
    return _baseTokenURI;
    }

   function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

      function tokenURI(uint256 tokenId) public view override returns (string memory){
        require( _exists(tokenId), "ERC721Metadata: URI query for nonexistent token" );
        require(URISetter==true,"URI has not been set");
      
        if (block.timestamp % 2 == 0) {
            return bytes(URI1).length > 0 ? string(
            abi.encodePacked(URI1,Strings.toString(tokenId),".json"))
            : "";
        }else{
        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0 ? string(
            abi.encodePacked(currentBaseURI,Strings.toString(tokenId),".json"))
            : "";
        }
    }


}