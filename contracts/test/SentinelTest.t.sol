// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {SentinelPolicy} from "../src/SentinelPolicy.sol";

contract SentinelTest is Test {
    SentinelPolicy public sentinel;

    address wallet1 = address(0xC0FFEE);
    address wallet2 = address(0xB0B);

    function setUp() public {
        sentinel = new SentinelPolicy();
    }

    /// @notice User A changes the policy to Strict, User B must remain Standard (default).
    /// This proves that mapping(address => Policy) is truly isolated per address.
    function test_SetPolicy_IsolatedPerUser() public {
        vm.prank(wallet1);
        sentinel.setPolicy(SentinelPolicy.SecurityProfile.Strict, true, true);

        // Check wallet1 Srict now
        SentinelPolicy.Policy memory policyA = sentinel.getPolicy(wallet1);

        assertEq(uint256(policyA.profile), uint256(SentinelPolicy.SecurityProfile.Strict));
        assertTrue(policyA.blockUnlimitedApproval);
        assertTrue(policyA.warnUknownContract);

        // Check wallet2 not change (default setting)
        SentinelPolicy.Policy memory policyB = sentinel.getPolicy(wallet2);

        assertEq(uint256(policyB.profile), uint256(SentinelPolicy.SecurityProfile.Standard));
        assertFalse(policyB.blockUnlimitedApproval);
        assertFalse(policyB.warnUknownContract);
    }

    /// @notice Ensures the PolicyUpdated event is emitted with the correct parameters
    /// using vm.expectEmit (Foundry best practice).
    function test_SetPolicyEmitsProfileUpdatedEvent() public {
        vm.expectEmit(true, false, false, true, address(sentinel));
        emit SentinelPolicy.PolicyUpdated(wallet1, SentinelPolicy.SecurityProfile.Strict, true, true);

        vm.prank(wallet1);
        sentinel.setPolicy(SentinelPolicy.SecurityProfile.Strict, true, true);
    }

    /// @notice Used for `forge snapshot` — measuring the gas cost of setPolicy.
    /// The results are automatically added to the .gas-snapshot file in the project root.
    function test_Gas_SetPolicy() public {
        vm.prank(wallet1);
        sentinel.setPolicy(SentinelPolicy.SecurityProfile.Custom, true, false);
    }
}
