// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TraitBase is ERC721, Ownable {
    bool public isSaleEnabled;
    uint256 public immutable MAX_SUPPLY;
    uint256 public price;
    uint256 public maxHoldPerWallet;
    uint256 public totalSupply;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _MAX_SUPPLY,
        uint256 _price,
        uint256 _maxHoldPerWallet
    ) ERC721(_name, _symbol) {
        MAX_SUPPLY = _MAX_SUPPLY;
        price = _price;
        maxHoldPerWallet = _maxHoldPerWallet;
    }

    function changePrice(uint256 newPrice) public onlyOwner {
        price = newPrice;
    }

    function changeMaxMintPerWallet(uint256 newLimit) public onlyOwner {
        maxHoldPerWallet = newLimit;
    }

    function flipSaleState() public onlyOwner {
        isSaleEnabled = !isSaleEnabled;
    }

    function mintTrait(uint256 noOfTraits) public payable {
        _mintTrait(msg.sender, msg.value, noOfTraits);
    }

    function mintTraitFor(address _for, uint256 noOfTraits) public payable {
        _mintTrait(_for, msg.value, noOfTraits);
    }

    function _mintTrait(
        address _user,
        uint256 payingAmount,
        uint256 noOfTraits
    ) internal {
        require((balanceOf(_user) + noOfTraits) <= maxHoldPerWallet, "Trait: You can't hold beyond max limit");
        require((noOfTraits * price) <= payingAmount, "Trait: Invalid Paying Amount");
        require(isSaleEnabled, "Trait: Sale is Disabled");

        for (uint256 i = 0; i < noOfTraits; i++) {
            _mintTrait(_user);
        }
    }

    function _mintTrait(address _to) internal {
        uint256 _tokenId = totalSupply + 1;
        _mint(_to, _tokenId);
        totalSupply = _tokenId;
        require(totalSupply <= MAX_SUPPLY, "Trait: Max Supply Exceeds");
    }
}
