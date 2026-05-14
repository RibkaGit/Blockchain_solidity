// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    struct Proposal {
        address target;
        bytes data;
        uint yesCount;
        uint noCount;
    }
    
    // Create a public array of type Proposal called proposals
    Proposal[] public proposals;
    
    // External function to create a new proposal
    function newProposal(address target, bytes calldata data) external {
        // Create a new Proposal with the arguments passed in
        Proposal memory newProposal = Proposal({
            target: target,
            data: data,
            yesCount: 0,
            noCount: 0
        });
        
        // Add the new Proposal to the proposals array
        proposals.push(newProposal);
    }
}