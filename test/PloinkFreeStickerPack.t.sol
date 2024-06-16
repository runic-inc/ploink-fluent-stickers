// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/PloinkFreeStickerPack.sol";

contract PloinkTest is Test {
    address private _owner;
    PloinkFreeStickerPack public _ploinkFreeStickerPack;

    function setUp() public {
        _owner = address(1);
        _ploinkFreeStickerPack = new PloinkFreeStickerPack(_owner);

        vm.startPrank(_owner);
        vm.stopPrank();
    }

    function testFreeStickerPack() public {
        assertTrue(
            _ploinkFreeStickerPack.supportsInterface(
                type(IStickerPack).interfaceId
            )
        );
        assertTrue(_ploinkFreeStickerPack.allowUse(address(5)));
        assertTrue(_ploinkFreeStickerPack.allowUse(address(6)));
    }
}
