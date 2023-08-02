// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
contract musicNfts is ERC721URIStorage{
    // we need to keep count of how many nfts we have 
        using Counters for Counters.Counter;
        Counters.Counter  private _tokenIds;
        uint256 listingPrice = 25 ether;
    // constructor
    constructor () ERC721("MUSICNFTS", "MSC"){}

    // structure for music nft

    struct MusicNft{
        uint256  tokenId;
        address seller;
        address owner;
        uint256 price;
        bool isSold;
    }
    mapping (uint256=>MusicNft) public idToMusic;
    event MarketItemCreated(uint256 indexed tokenId , address seller, address owner,uint256 price,bool isSold);




    // function to do the minting

    function createMusicNft(string memory
    _tokenURI,uint256 price) public payable returns (uint){
        // increase the count
        _tokenIds.increment();
        uint256 currentId=_tokenIds.current();
        _mint(msg.sender, currentId);
        _setTokenURI(currentId, _tokenURI);
        createNFTInMarketPlace(price,currentId);

        return currentId;
    }
    // place the nft on the market

    function createNFTInMarketPlace(uint256 price,uint256 currentId) private  {
        require(price>0,"price must be more than 1 wei");
        require(msg.value==listingPrice,"money sent must be equal to listing price");
       idToMusic[currentId] = MusicNft(currentId, payable(msg.sender), payable(address(this)), price, false);
       _transfer(msg.sender, address(this), currentId);
       emit  MarketItemCreated( currentId , msg.sender, address(this),price,false);


    }

}