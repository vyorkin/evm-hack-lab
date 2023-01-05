// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import {Counters} from "openzeppelin/utils/Counters.sol";
import {ERC721} from "openzeppelin/token/ERC721/ERC721.sol";

contract Hashmasks is ERC721 {
  using Counters for Counters.Counter;

  uint256 constant MAX_NFT_SUPPLY = 40;
  uint256 constant NFT_PRICE = 0.001 ether;

  Counters.Counter public tokenId;

  constructor() ERC721("Hashmasks", "HSH") {}

  function mint(uint256 numberOfNfts) public payable {
      require(totalSupply() < MAX_NFT_SUPPLY, "Sale has already ended");
      require(totalSupply() + numberOfNfts <= MAX_NFT_SUPPLY, "Exceeds MAX_NFT_SUPPLY");
      require(numberOfNfts > 0, "numberOfNfts cannot be 0");
      require(numberOfNfts <= 20, "You may not buy more than 20 NFTs at once");

      for (uint i = 0; i < numberOfNfts; i++) {
          uint256 ix = totalSupply();
          tokenId.increment();
          _safeMint(msg.sender, ix);
      }
  }

  function totalSupply() public view returns (uint256) {
    return tokenId.current();
  }
}
