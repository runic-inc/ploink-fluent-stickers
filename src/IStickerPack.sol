// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
@notice A Ploink-compatible Sticker Pack
*/
interface IStickerPack {

    event SetSticker(uint32 indexed typeId, string name, string imageURI, uint256 plunkPrice);

    struct StickerInfo {
        string name;
        string imageURI;
        uint256 plunkPrice;
    }

    function stickerCount() external view returns (uint256 count);

    function sticker(uint32 typeId) external view returns (StickerInfo memory info);

    function allowUse(address by) external view returns (bool use);
}
