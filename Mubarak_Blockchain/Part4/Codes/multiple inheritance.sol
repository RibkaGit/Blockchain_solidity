// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Ownable {
    address public owner;
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner cannot be zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
    
    function renounceOwnership() external onlyOwner {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }
}

contract Transferable {
    event Transfer(address indexed from, address indexed to);
    
    function transfer(address newOwner) external {
        // Check that caller is the current owner
        Ownable collectible = Ownable(address(this));
        require(msg.sender == collectible.owner(), "Only owner can call this function");
        
        // Directly update the owner in Ownable contract
        collectible.transferOwnership(newOwner);
        
        emit Transfer(msg.sender, newOwner);
    }
}