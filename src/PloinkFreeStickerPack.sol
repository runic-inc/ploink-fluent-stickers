// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "./IStickerPack.sol";

contract PloinkFreeStickerPack is Ownable, IStickerPack, ERC165 {

    error InputLengthMismatch();
    
    mapping(address=>uint256) internal _reverseLookups; // Address to TokenId
    mapping(uint32=>StickerInfo) internal _stickerInfo; // Sticker Type ID to sticker info
    uint256 internal _stickerCount;

    constructor(address _owner) Ownable(_owner) {}

    function supportsInterface(bytes4 interfaceID) public view virtual override returns (bool) {
        return type(IStickerPack).interfaceId == interfaceID ||
            super.supportsInterface(interfaceID);
    }

    function setStickerBatch(uint32[] memory typeIds, StickerInfo[] memory infos) public onlyOwner {
        if (typeIds.length != infos.length) {
            revert InputLengthMismatch();
        }
        for (uint256 i = 0; i < infos.length; i++) {
            setSticker(typeIds[i], infos[i]);
        }
    }
    
    function setSticker(uint32 typeId, StickerInfo memory info) public onlyOwner {
        if (bytes(info.imageURI).length == 0 && bytes(_stickerInfo[typeId].imageURI).length != 0) {
            _stickerCount--;
        }
        if (bytes(info.imageURI).length != 0 && bytes(_stickerInfo[typeId].imageURI).length == 0) {
            _stickerCount++;
        }
        _stickerInfo[typeId] = info;
        emit SetSticker(typeId, info.name, info.imageURI, info.plunkPrice);
    }

    function stickerCount() public view returns (uint256 count) {
        return _stickerCount;
    }

    function sticker(uint32 typeId) public view returns (StickerInfo memory info) {
        return _stickerInfo[typeId];
    }

    function allowUse(address /* by */) public pure returns (bool use) {
        // free always
        return true;
    }
}