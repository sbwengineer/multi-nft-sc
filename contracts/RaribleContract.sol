// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./ERC721Enumerable.sol";
import "./ERC721Burnable.sol";
import "./Ownable.sol";
import "./SafeMath.sol";
import "./Counters.sol";

contract RaribleContract is ERC721Enumerable, Ownable, ERC721Burnable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdTracker;

    uint256 public constant MAX_ELEMENTS = 10000;
    uint256 public constant MAX_BY_MINT = 20;
    address public constant creatorAddress = 0x92F545708BCD3E0168627CC988b3c489783D9a90;
    
    mapping (uint256 => uint256) _price;
    bool private _pause;

    event JoinFace(uint256 indexed id);

    constructor() ERC721("DaFeisNFT", "DFN") {
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
    function setPrice(uint256[] memory _tokenId, uint256[] memory _tokenPrice) public onlyOwner {
        require(_tokenId.length == _tokenPrice.length, "Unmatched input data");
        for (uint i = 0; i < _tokenId.length; i ++) {
            require(_tokenId[i] <= MAX_ELEMENTS, "Token id exceeds");
            require(_tokenPrice[i] > 0, "Price must be greater than 0");
            _price[_tokenId[i]] = _tokenPrice[i];
        }
    }
    function mint(address _to, uint256 _count, string[] memory _tokenURI) public payable saleIsOpen {
        uint256 total = _totalSupply();
        require(total + _count <= MAX_ELEMENTS, "Max limit");
        require(total <= MAX_ELEMENTS, "Sale end");
        require(_count <= MAX_BY_MINT, "Exceeds number");
        require(_price[total + _count] != 0, "Token is not exist");
        require(msg.value >= price(_count), "Value below price");
        require(_tokenURI.length == _count, "Token URI input failed");
        for (uint256 i = 0; i < _count; i++) {
            _mintAnElement(_to, _tokenURI[i]);
        }
    }
    function _mintAnElement(address _to, string memory _tokenURI) private {
        uint id = _totalSupply();
        _tokenIdTracker.increment();
        setTokenURI(id + 1, _tokenURI);
        _safeMint(_to, id + 1);
        emit JoinFace(id + 1);
    }
    function price(uint256 _count) public view returns (uint256) {
        uint id = _totalSupply();
        uint _totalPrice = 0;
        for (uint i = 1; i <= _count; i ++)
            _totalPrice += _price[id + i];
        return _totalPrice;
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