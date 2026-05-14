// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    struct Proposal {
        address target;
        bytes data;
        uint yesCount;
        uint noCount;
        bool executed;
    }
    
    // Create a public array of type Proposal called proposals
    Proposal[] public proposals;
    
    // Track votes: proposalId => (voter => hasVoted)
    mapping(uint => mapping(address => bool)) public hasVoted;
    
    // Track vote choice: proposalId => (voter => votedYes)
    mapping(uint => mapping(address => bool)) public votedYes;
    
    // Event emitted when a new proposal is created
    event ProposalCreated(uint proposalId);
    
    // Event emitted when a vote is cast
    event VoteCast(uint proposalId, address voter);
    
    // Event emitted when a proposal is executed
    event ProposalExecuted(uint proposalId);
    
    // Track authorized members
    mapping(address => bool) public isAuthorized;
    
    // Minimum yes votes required to execute
    uint public constant MIN_VOTES_THRESHOLD = 10;
    
    // Constructor that takes an array of addresses
    constructor(address[] memory members) {
        // Add the deployer as an authorized member
        isAuthorized[msg.sender] = true;
        
        // Add all addresses from the array as authorized members
        for (uint i = 0; i < members.length; i++) {
            isAuthorized[members[i]] = true;
        }
    }
    
    // Modifier to restrict access to authorized members only
    modifier onlyAuthorized() {
        require(isAuthorized[msg.sender], "Not authorized to perform this action");
        _;
    }
    
    // External function to create a new proposal (restricted to authorized members)
    function newProposal(address target, bytes calldata data) external onlyAuthorized {
        // Create a new Proposal with the arguments passed in
        Proposal memory _newProposal = Proposal({
            target: target,
            data: data,
            yesCount: 0,
            noCount: 0,
            executed: false
        });
        
        // Add the new Proposal to the proposals array
        proposals.push(_newProposal);
        
        // Emit the ProposalCreated event with the proposal ID
        emit ProposalCreated(proposals.length - 1);
    }
    
    // External function to cast a vote on a proposal (restricted to authorized members)
    function castVote(uint proposalId, bool inSupport) external onlyAuthorized {
        // Ensure the proposal ID is valid
        require(proposalId < proposals.length, "Invalid proposal ID");
        
        // Get the proposal from the array
        Proposal storage proposal = proposals[proposalId];
        
        // Check if proposal has already been executed
        require(!proposal.executed, "Proposal already executed");
        
        // Check if the voter has already voted on this proposal
        if (hasVoted[proposalId][msg.sender]) {
            // Voter is changing their vote
            bool previousVote = votedYes[proposalId][msg.sender];
            
            // Only process if the vote is actually changing
            if (previousVote != inSupport) {
                // Update vote counts based on previous vote
                if (previousVote) {
                    proposal.yesCount--;
                } else {
                    proposal.noCount--;
                }
                
                // Update vote counts based on new vote
                if (inSupport) {
                    proposal.yesCount++;
                } else {
                    proposal.noCount++;
                }
                
                // Update the voter's choice
                votedYes[proposalId][msg.sender] = inSupport;
            }
        } else {
            // New vote
            if (inSupport) {
                proposal.yesCount++;
            } else {
                proposal.noCount++;
            }
            
            // Mark that this voter has voted
            hasVoted[proposalId][msg.sender] = true;
            votedYes[proposalId][msg.sender] = inSupport;
        }
        
        // Emit the VoteCast event
        emit VoteCast(proposalId, msg.sender);
        
        // Check if the proposal has reached the threshold and execute it
        if (proposal.yesCount >= MIN_VOTES_THRESHOLD && !proposal.executed) {
            // Mark as executed before calling to prevent reentrancy
            proposal.executed = true;
            
            // Execute the vote by sending the data to the target address
            (bool success, ) = proposal.target.call(proposal.data);
            
            // Require success
            require(success, "Execution failed");
            
            // Emit execution event
            emit ProposalExecuted(proposalId);
        }
    }
    
    // Function to check if a proposal has been executed
    function isExecuted(uint proposalId) external view returns (bool) {
        require(proposalId < proposals.length, "Invalid proposal ID");
        return proposals[proposalId].executed;
    }
}