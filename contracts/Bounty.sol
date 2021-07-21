pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Bounty {
    address adminAddress;
    mapping(address => User) users;
    mapping(address => uint256) credit;

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
        uint256 amount;
        Submission[] submissions;
    }

    constructor() {
        adminAddress = msg.sender;
    }

    // Challenges - with bounty amount
    function submitChallenge(string memory _name) public payable {
        Challenge memory new_challenge;
        // new_challenge.name = _name;
        // new_challenge.creator = msg.sender;
        // new_challenge.amount = msg.value;

        challenges.push(new_challenge);
    }

    // // State transition function
    // function triggerCompletion(uint256 _id) public payable {
    //     require(_id < challenges.length);
    // }

    // function returnChallenges() public view returns (string[] memory) {
    //     string[] memory challengeNames = new string[](challenges.length);
    //     for (uint256 i = 0; i < challenges.length; i++) {
    //         challengeNames[0] = challenges[i].name;
    //     }
    //     return challengeNames;
    // }

    // // Submissions to challenges
    // function submitSubmission(uint256 _challenge_id, string memory name)
    //     public
    // {
    //     Submission memory new_submission;
    //     new_submission.name = name;
    //     new_submission.creator = msg.sender;

    //     challenges[_challenge_id].submissions.push(new_submission);
    // }

    // // vote
    // function voteOnSubmission(uint256 _challengeid, uint256 _id) public {
    //     challenges[_challengeid].submissions[_id].votes += 1;
    //     users[msg.sender].votes.push(_id);
    // }

    // function returnAdminAddress() public view returns (address) {
    //     return adminAddress;
    // }

    // function initializeUser() public doesUserExist {
    //     User memory _user;
    //     _user.initialized = true;
    //     users[msg.sender] = _user;
    // }

    // function getUserData() public view returns (bool, uint256[] memory) {
    //     return (users[msg.sender].initialized, users[msg.sender].votes);
    // }

    // // modifiers
    // modifier doesUserExist() {
    //     if (users[msg.sender].initialized == false) {
    //         _;
    //     }
    // }
}
