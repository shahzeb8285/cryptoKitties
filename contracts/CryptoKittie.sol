// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./base/TraitBase.sol";

contract CryptoBowies is TraitBase("CryptoBowies", "BOWY", 500, 0.01 ether, 10) {}
