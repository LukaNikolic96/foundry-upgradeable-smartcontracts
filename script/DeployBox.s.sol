// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBox is Script {
    function run() external returns (address){
        address proxy = deployBox();
        return proxy;
    }
    function deployBox() public returns (address) {
        // first we start broadcasting
        vm.startBroadcast();
        BoxV1 box = new BoxV1(); // implementation (logic)
        // we pass address of our contract (box) to proxy so he know address of implementation contract
        // we don't have any data that is why it is empty
        ERC1967Proxy proxy = new ERC1967Proxy(address(box), "");
        vm.stopBroadcast();
        return address(proxy);
    }
}