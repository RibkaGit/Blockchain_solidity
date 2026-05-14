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
    
    // Event emitted when a new proposal is created
    event ProposalCreated(uint proposalId);
    
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
        
        // Emit the ProposalCreated event with the proposal ID
        emit ProposalCreated(proposals.length - 1);
    }
    
    // External function to cast a vote on a proposal
    function castVote(uint proposalId, bool inSupport) external {
        // Ensure the proposal ID is valid
        require(proposalId < proposals.length, "Invalid proposal ID");
        
        // Get the proposal from the array
        Proposal storage proposal = proposals[proposalId];
        
        // Update the yesCount or noCount based on the vote
        if (inSupport) {
            proposal.yesCount++;
        } else {
            proposal.noCount++;
        }
    }
}