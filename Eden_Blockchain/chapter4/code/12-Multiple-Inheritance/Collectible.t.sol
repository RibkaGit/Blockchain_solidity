// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "./Collectible.sol";

contract CollectibleTest is Test {
    Collectible public collectible;
    address public owner = address(1);
    address public newOwner = address(2);
    address public nonOwner = address(3);
    
    function setUp() public {
        vm.prank(owner);
        collectible = new Collectible();
    }
    
    function testTransfer() public {
        vm.prank(owner);
        collectible.transfer(newOwner);
        assertEq(collectible.owner(), newOwner);
    }
    
    function testNonOwnerCannotTransfer() public {
        vm.prank(nonOwner);
        vm.expectRevert("Only owner can call this function");
        collectible.transfer(newOwner);
    }
    
    function testNewOwnerCanMarkPrice() public {
        vm.prank(owner);
        collectible.transfer(newOwner);
        
        vm.prank(newOwner);
        collectible.markPrice(100);
        assertEq(collectible.price(), 100);
    }
}