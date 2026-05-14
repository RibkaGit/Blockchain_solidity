// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    address public owner;

    error NotOwner(address caller);

    constructor() payable {
        owner = msg.sender;
    }

    receive() external payable {}

    function withdraw() public {
        if (msg.sender != owner) {
            revert NotOwner(msg.sender);
        }

        (bool success, ) = owner.call{ value: address(this).balance }("");
        require(success, "Withdraw transfer failed");
    }
}
