// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public OWNER = makeAddr("owner");

    address public proxy;

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();

        proxy = deployer.run(); // this points to boxV1
    }
    function testProxyStartsAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(7);

    }

    function testUpgrades() public {
        // setting new address
        BoxV2 box2 = new BoxV2();
        // upgrade proxy(boxV1) to the new address
        upgrader.upgradeBox(proxy, address(box2));

        // in boxV2 we set version to 2 so we now expect to show 2
        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV2(proxy).version());

        // WE HAVE FUNCTION IN boxV2 that sets number but we don't have that in boxV1
        // so we are calling that function and put random number and then we expect this number in test
        // to be equal with number that we put in that function
        // we put here tp update real function to 7 and then we do check(assertEq) to see if that
        // number matches number we put through that function
        BoxV2(proxy).setNumber(7);
        assertEq(7, BoxV2(proxy).getNumber());
    }
}