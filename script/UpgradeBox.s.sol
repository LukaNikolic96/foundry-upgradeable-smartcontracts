// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV1} from "../src/BoxV1.sol";

contract UpgradeBox is Script {
    function run() external returns(address){
    // since we first deploy boxV1 we want to get address of most recently deployed contract that is ERC1967Proxy on block and his chainid
    address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
    // we start broadcasting boxV2
    vm.startBroadcast();
    BoxV2 newBox = new BoxV2();
    vm.stopBroadcast();
    // our proxy address will have previus proxy address and address of newBox will be passed to her
    address proxy = upgradeBox(mostRecentDeployment, address(newBox));
    return proxy;
    }

    function upgradeBox(address proxyAddress, address newBox) public returns(address){
        vm.startBroadcast();
        // we are giving abi of boxV1 to our proxy address
        BoxV1 proxy = BoxV1(proxyAddress);
        // then we upgrate it to address of new box (proxy contract now points to this new address)
        proxy.upgradeToAndCall(address(newBox), "");
        vm.stopBroadcast();
        return address(proxy);
    }
}