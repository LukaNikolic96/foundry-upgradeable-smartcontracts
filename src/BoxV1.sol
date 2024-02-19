// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract BoxV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 internal number;

    // proxies don't use constructors so we use _disableInitializers function to basically tell them let us got we know
    // we basically say to constructor to don't do anything (don't initialize anything), we could just also delete it
    // but this way is more robust
    //_disableInitializers don't let any initialization happens
    /// @custom:oz-upgrades-unsafe-allow contstructor
    constructor() {
        _disableInitializers();
    }

    // this is kinda constructor for proxies bcs they can't have constructor
    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 1;
    }

    /**
     *
     * @param newImplementation /
     * THERE WE CAN SAY SOMETHING LIKE IF MSG.SENDER IS NOT OWNER TO REVERT
     */
    function _authorizeUpgrade(address newImplementation) internal override {}
}
