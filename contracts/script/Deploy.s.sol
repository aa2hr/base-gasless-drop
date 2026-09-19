// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {DropPlain} from "../src/DropPlain.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();
        DropPlain drop = new DropPlain(
            "Base Gasless Drop",
            "BDROP",
            1000,
            0,
            "https://example.com/metadata/"
        );
        vm.stopBroadcast();
        drop;
    }
}
