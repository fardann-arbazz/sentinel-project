// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract SentinelPolicy {
    enum SecurityProfile {
        Standard,
        Strict,
        Custom
    }

    struct Policy {
        SecurityProfile profile;
        bool blockUnlimitedApproval;
        bool warnUknownContract;
    }

    mapping(address => Policy) private policies;

    event PolicyUpdated(
        address indexed user, SecurityProfile profile, bool blockUnlimitedApproval, bool warnUknownContract
    );

    function setPolicy(SecurityProfile profile, bool blockUnlimitedApproval, bool warnUknownContract) external {
        policies[msg.sender] = Policy(profile, blockUnlimitedApproval, warnUknownContract);
        emit PolicyUpdated(msg.sender, profile, blockUnlimitedApproval, warnUknownContract);
    }

    function getPolicy(address user) external view returns (Policy memory) {
        return policies[user];
    }
}
