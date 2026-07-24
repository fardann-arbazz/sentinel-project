// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract SentinelRegistry {
    struct Guardian {
        uint64 activatedAt;
    }

    mapping(address => Guardian) private guardians;

    event GuardianActivated(address indexed user, uint64 activatedAt);
    error AlreadyActivated();

    /// @notice Activates Sentinel protection for the caller.
    function activate() external {
        if (guardians[msg.sender].activatedAt != 0) {
            revert AlreadyActivated();
        }

        guardians[msg.sender] = Guardian({activatedAt: uint64(block.timestamp)});

        emit GuardianActivated(msg.sender, uint64(block.timestamp));
    }

    /// @notice To find out if security is active
    function isProtected(address user) external view returns (bool) {
        return guardians[user].activatedAt != 0;
    }

    /// @notice To get guardian active time data
    function getGuardian(address user) external view returns (uint64) {
        return guardians[user].activatedAt;
    }
}
