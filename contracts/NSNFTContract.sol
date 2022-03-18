// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./ERC721Enumerable.sol";
import "./ERC721Burnable.sol";
import "./Ownable.sol";
import "./SafeMath.sol";
import "./Counters.sol";

contract NSNFTContract is ERC721Enumerable, Ownable, ERC721Burnable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdTracker;

    uint256 public constant MAX_ELEMENTS = 10000;
    uint256 public constant PRICE = 7 * 10**16;
    address public constant creatorAddress = 0x46C1aD913af291f84328D912d8Cd64d41FC3A4D0;
    string public baseTokenURI;
    bool private _pause;
    mapping (uint256 => bool) public _mintStates;
    mapping (uint256 => uint256) public _nftPrices;

    event JoinFace(uint256 indexed id);

    constructor(string memory baseURI) ERC721("NSNFTContract", "NSN") {
        setBaseURI(baseURI);
        pause(true);
    }

    modifier saleIsOpen {
        require(_totalSupply() <= MAX_ELEMENTS, "Sale end");
        if (_msgSender() != owner()) {
            require(!_pause, "Pausable: paused");
        }
        _;
    }
    function _totalSupply() internal view returns (uint) {
        return _tokenIdTracker.current();
    }
    function totalMint() public view returns (uint256) {
        return _totalSupply();
    }
    function mint(address _to, uint256[] memory ids) public payable saleIsOpen {
        uint256 total = _totalSupply();
        require(total + 1 <= MAX_ELEMENTS, "Max limit");
        require(total <= MAX_ELEMENTS, "Sale end");
        require(msg.value >= price(ids), "Not enough value");
        _tokenIdTracker.increment();
        
        for (uint256 i = 0; i < ids.length; i++) {
            require(!_mintStates[ids[i]], "Some NFTs already minted");
            require(_nftPrices[ids[i]] != 0, "Price not set");
            _mintAnElement(_to, ids[i]);
            _mintStates[ids[i]] = true;
        }
    }
    function _mintAnElement(address _to, uint256 id) private {
        _safeMint(_to, id);
        emit JoinFace(id);
    }
    function price(uint256[] memory ids) public view returns (uint256) {
        uint _totalPrice = 0;
        for (uint256 i = 0; i < ids.length; i++)
            _totalPrice += _nftPrices[ids[i]];
        return _totalPrice;
    }
    function getMintStates() public view returns (bool[] memory){
        bool[] memory mintStateArray;
        for(uint256 i = 1; i <= MAX_ELEMENTS; i++) {
            mintStateArray[i] = _mintStates[i];
        }
        return mintStateArray;
    }
    function setPriceById(uint256 id, uint256 nftPrice) public onlyOwner {
        require(id <= MAX_ELEMENTS, "ID number is exceeded.");
        require(nftPrice > 0, "NFT price can not be 0!");
        _nftPrices[id] = nftPrice;
    }
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }
    function setBaseURI(string memory baseURI) public onlyOwner {
        baseTokenURI = baseURI;
    }
    function walletOfOwner(address _owner) external view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);
        uint256[] memory tokensId = new uint256[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokensId;
    }    
    function pause(bool val) public onlyOwner {
        _pause = val;
    }
    function withdrawAll() public payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0);
        _widthdraw(creatorAddress, address(this).balance);
    }
    function _widthdraw(address _address, uint256 _amount) private {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Transfer failed.");
    }
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}