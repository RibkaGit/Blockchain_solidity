// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    address public charity;

    constructor(address _charity) {
        charity = _charity;
    }

    receive() external payable {}

    function donate() public {
        selfdestruct(payable(charity));
    }
}
