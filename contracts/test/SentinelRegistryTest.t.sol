// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {SentinelRegistry} from "../src/SentinelRegistry.sol";

contract SentinelRegistryTest is Test {
    SentinelRegistry public sentinel;

    address wallet1 = address(0xC0FFEE);
    address wallet2 = address(0xB0B);

    function setUp() public {
        sentinel = new SentinelRegistry();
    }

    /// @notice Make sure wallet1 is not protected
    function test_WalletNotProtected() public {
        bool status = sentinel.isProtected(wallet1);

        assertFalse(status);
    }

    /// @notice Test the active function so that the result is protect true
    function test_active() public {
        vm.prank(wallet1);

        sentinel.activate();

        assertTrue(sentinel.isProtected(wallet1));
    }

    /// @notice Test timestamp make sure it is saved
    function test_GuardianTimestampStored() public {
        vm.prank(wallet1);

        sentinel.activate();

        uint64 activatedAt = sentinel.getGuardian(wallet1);

        assertEq(activatedAt, uint64(block.timestamp));
    }

    /// @notice Make sure error if double activate
    function test_CannotActivateTwice() public {
        vm.startPrank(wallet1);

        sentinel.activate();

        vm.expectRevert(SentinelRegistry.AlreadyActivated.selector);

        sentinel.activate();

        vm.stopPrank();
    }

    /// @notice Make sure false if with another wallet
    function test_AnotherWalletInactive() public {
        vm.prank(wallet1);

        sentinel.activate();

        assertFalse(sentinel.isProtected(wallet2));
    }

    /// @notice Make sure the event works when active
    function test_EventActived() public {
        uint64 timestamp = 1_700_000_000;

        vm.warp(timestamp);

        vm.expectEmit(true, false, false, true, address(sentinel));
        emit SentinelRegistry.GuardianActivated(wallet1, timestamp);

        vm.prank(wallet1);
        sentinel.activate();
    }
}
