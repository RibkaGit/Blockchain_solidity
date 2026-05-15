// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Escrow {
    address public depositor;
    address public beneficiary;
    address public arbiter;

    event Approved(uint balance);

    error NotArbiter(address caller);

    constructor(address _arbiter, address _beneficiary) payable {
        depositor = msg.sender;
        arbiter = _arbiter;
        beneficiary = _beneficiary;
    }

    function approve() external {
        if (msg.sender != arbiter) {
            revert NotArbiter(msg.sender);
        }

        uint balance = address(this).balance;

        (bool success, ) = beneficiary.call{ value: balance }("");
        require(success);

        emit Approved(balance);
    }
}
