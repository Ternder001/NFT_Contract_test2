// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract NFTMarketplace is ERC721, Ownable {
    using Counters for Counters.Counter;
    uint counter = 1;
    counter private _tokenIdTracker;

    mapping(uint => uint) private _nftPrices;

    event NFTListed(uint indexed nftId, uint price);
    event NFTSold(address indexed buyer, uint indexed nftId, uint price);
    
    constructor() ERC721("NFTMarketplace", "NFTM") {}

    function mint(address to) public onlyOwner {
        uint newTokenId = _tokenIdTracker.current() + 1;
        _safeMint(to, newTokenId);
        _tokenIdTracker.increment();
    }

    function setNftPrice(uint nftId, uint price) public {
        require(_exists(nftId), "NFT does not exist");
        require(ownerOf(nftId) == msg.sender, "You are not the owner of this NFT");
        _nftPrices[nftId] = price;
        emit NFTListed(nftId, price);
    }

    function buyNft(uint nftId) public payable {
        require(_exists(nftId), "NFT does not exist");
        uint price = _nftPrices[nftId];
        require(price > 0, "NFT is not for sale");
        require(msg.value >= price, "Insufficient funds");
        address owner = ownerOf(nftId);
        payable(owner).transfer(msg.value);
        _transfer(owner, msg.sender, nftId);
        _nftPrices[nftId] = 0; // Remove the listing after sale
        emit NFTSold(msg.sender, nftId, price);
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(owner()).transfer(balance);
    }

    function tokenPrice(uint nftId) public view returns (uint) {
        return _nftPrices[nftId];
    }
}
