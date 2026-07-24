// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {SentinelRegistry} from "../src/SentinelRegistry.sol";

contract DeploySentinelRegistry is Script {
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        SentinelRegistry sentinelRegistry = new SentinelRegistry();
        vm.stopBroadcast();

        console.log("Sentinel Registry:", address(sentinelRegistry));
    }
}