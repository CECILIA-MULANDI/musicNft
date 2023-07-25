// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract musicNft is ERC721URIStorage{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address  private _admin;
    address private _minter;
     // modifier functions
    modifier onlyAdmin(){
        require(msg.sender==_admin,"this function can only be accessed by the admin");
        _;
    }
    modifier onlyMinter() {
        require(msg.sender == _minter, "Only the minter can call this function");
        _;
    }

    // Function to set the minter address (can only be called by the contract admin)
    function setMinter(address minter) public onlyAdmin {
        _minter = minter;
    }
    // let's have a struct to define how our music nft will look like
    struct MusicNftMetadata{
        string name;
        string artist;
        uint256 releaseYear;
    }
    
    // mappings = id => metadataURI(SOMEHOW LIKE JSON FORMAT OF DATA  )
    mapping(uint256=>MusicNftMetadata) private _tokenMetadata;
   
    constructor() ERC721 ("musicNft","MSC"){
        // when the contract is initialized let the deployer be the admin
        _admin=msg.sender;
    }
    // let's mint
    function createMusicNft(string memory tokenURI,string memory name,string memory artist,uint256 releaseYear) public onlyMinter returns(uint){
    //    increased the count
        _tokenIds.increment();
        uint256 newItemId=_tokenIds.current();
        _mint(_minter, newItemId);
        _setTokenURI(newItemId, tokenURI);
        _tokenMetadata[newItemId]=MusicNftMetadata(name,artist,releaseYear);
        return newItemId;

    }

    function getMusicNftMetadata(uint _tokenId)public view returns(MusicNftMetadata memory){
        return _tokenMetadata[_tokenId];

    }
    // transfer ownership
    function transferOwnerShip(address newAdmin) public onlyAdmin{
        _admin=newAdmin;
    }
    // // Function to allow token transfers
    // function transferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) {
    //     // Add any additional logic or restrictions if needed
    //     super.transferFrom(from, to, tokenId);
    // }
    // transfer your musicNft
    function transferMusicNft(address to,uint256 tokenId) public {
        require(ownerOf(tokenId)==msg.sender,"Your are not the owner of this nft");
        _transfer(msg.sender, to, tokenId);
    }

}