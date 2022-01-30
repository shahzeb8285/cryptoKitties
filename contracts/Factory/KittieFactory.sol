// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract CryptoBowiesFactory is IERC721Receiver {
    IERC721 public constant TRAIT1 = IERC721(0x347aD1DE1461157274d0cd751408169D745130A5);
    IERC721 public constant TRAIT2 = IERC721(0x347aD1DE1461157274d0cd751408169D745130A5);
    IERC721 public constant BOWIE = IERC721(0x347aD1DE1461157274d0cd751408169D745130A5);

    struct Traits {
        uint256 trait1;
        uint256 trait2;
    }
    mapping(uint256 => Traits) public traits;

    event onGenerate(uint256 bowieId);
    event onWithrawTrait(uint256 bowieId);

    function generateCharacter(
        uint256 bowieID,
        uint256 trait1ID,
        uint256 trait2ID
    ) public {
        require(BOWIE.ownerOf(bowieID) == msg.sender, "CryptoBowiesFactory: You are not Owner");
        if (trait1ID != 0) {
            TRAIT1.safeTransferFrom(msg.sender, address(this), trait1ID);
            uint256 previousTrait1ID = traits[bowieID].trait1;
            if (previousTrait1ID != 0) {
                TRAIT1.safeTransferFrom(address(this), msg.sender, previousTrait1ID);
            }
            traits[bowieID].trait1 = trait1ID;
        }

        if (trait2ID != 0) {
            TRAIT2.safeTransferFrom(msg.sender, address(this), trait2ID);
            uint256 previousTrait2ID = traits[bowieID].trait2;
            if (previousTrait2ID != 0) {
                TRAIT2.safeTransferFrom(address(this), msg.sender, previousTrait2ID);
            }
            traits[bowieID].trait2 = trait2ID;
        }

        emit onGenerate(bowieID);
    }

    function withdrawTraits(
        uint256 bowieID,
        bool trait1,
        bool trait2
    ) public {
        require(BOWIE.ownerOf(bowieID) == msg.sender, "CryptoBowiesFactory: You are not Owner");
        if (trait1) {
            uint256 previousTrait1ID = traits[bowieID].trait1;
            if (previousTrait1ID != 0) {
                TRAIT1.safeTransferFrom(address(this), msg.sender, previousTrait1ID);
            }
            traits[bowieID].trait1 = 0;
        }

        if (trait2) {
            uint256 previousTrait2ID = traits[bowieID].trait2;
            if (previousTrait2ID != 0) {
                TRAIT2.safeTransferFrom(address(this), msg.sender, previousTrait2ID);
            }
            traits[bowieID].trait2 = 0;
        }
        emit onWithrawTrait(bowieID);
    }

    function onERC721Received(
        address _operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        return 0x150b7a02;
    }
}
