// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DropPlain} from "../src/DropPlain.sol";

contract DropPlainTest is Test {
    DropPlain drop;
    address alice = address(0xA11CE);

    function setUp() public {
        drop = new DropPlain("Base Drop", "BDROP", 10, 0, "ipfs://drop/");
    }

    function testOwnerCanMint() public {
        uint256 id = drop.mint(alice);
        assertEq(id, 1);
        assertEq(drop.ownerOf(1), alice);
        assertEq(drop.totalMinted(), 1);
    }

    function testRelayerCanMint() public {
        address relayer = address(0xBEEF);
        drop.setRelayer(relayer);
        vm.prank(relayer);
        drop.mint(alice);
        assertEq(drop.ownerOf(1), alice);
    }

    function testStrangerCannotMint() public {
        vm.prank(alice);
        vm.expectRevert(DropPlain.NotAuthorized.selector);
        drop.mint(alice);
    }

    function testSoldOut() public {
        DropPlain tiny = new DropPlain("T", "T", 1, 0, "x");
        tiny.mint(alice);
        vm.expectRevert(DropPlain.SoldOut.selector);
        tiny.mint(alice);
    }
}
