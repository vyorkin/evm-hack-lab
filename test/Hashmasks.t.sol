// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import {Test} from "forge-std/Test.sol";
import {Utilities} from "./Utilities.sol";
import {Hashmasks} from "../src/Hashmasks.sol";

contract HashmasksTest is Test {
    Utilities private utils;
    address payable private attacker;
    Hashmasks private hashmasks;

    function setUp() public {
      utils = new Utilities();

      address payable[] memory users = utils.createUsers(1);
      attacker = users[0];
      vm.label(attacker, "Attacker");

      hashmasks = new Hashmasks();
    }

    function testReentrancy() public {
        assertTrue(true);
    }
}
