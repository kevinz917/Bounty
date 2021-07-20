pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Bounty {
    address adminAddress;
    mapping(address => User) users;
    Submission[] submissions;
    Challenge[] challenges;

    struct User {
        bool initialized;
        uint256[] votes;
    }

    struct Submission {
        string name;
        address creator;
        uint256 votes;
    }

    struct Challenge {
        address creator;
        string name;
        uint256 votes;
    }

    constructor() {
        adminAddress = msg.sender;
    }

    // Challenges
    function submitChallenge(string memory _name) public {
        Challenge memory new_challenge = Challenge({
            name: _name,
            creator: msg.sender,
            votes: 0
        });
        challenges.push(new_challenge);
    }

    function returnChallenges() public view returns (string[] memory) {
        string[] memory challengeNames = new string[](challenges.length);
        for (uint256 i = 0; i < challenges.length; i++) {
            challengeNames[0] = challenges[i].name;
        }
        return challengeNames;
    }

    function returnSingleChallenge(uint256 _id) public view returns (uint256) {
        return challenges[_id].votes;
    }

    // Submissions to challenges
    function submitSubmission(uint256 _id) public {
        challenges[_id].votes += 1;
        users[msg.sender].votes.push(_id);
    }

    // vote
    function voteOnSubmission(uint256 _id) public {
        submissions[_id].votes += 1;
        users[msg.sender].votes.push(_id);
    }

    function fetchSubmissionById(uint256 _id)
        public
        view
        returns (
            string memory,
            address,
            uint256
        )
    {
        return (
            submissions[_id].name,
            submissions[_id].creator,
            submissions[_id].votes
        );
    }

    function returnAdminAddress() public view returns (address) {
        return adminAddress;
    }

    function initializeUser() public doesUserExist {
        User memory _user;
        _user.initialized = true;
        users[msg.sender] = _user;
    }

    function getUserData() public view returns (bool, uint256[] memory) {
        return (users[msg.sender].initialized, users[msg.sender].votes);
    }

    // modifiers
    modifier doesUserExist() {
        if (users[msg.sender].initialized == false) {
            _;
        }
    }
}
