// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Bounty {
  address public adminAddress;

  mapping(address => User) private users;
  mapping(address => uint256) private balances;

  mapping(address => mapping(uint256 => mapping(uint256 => bool))) votes; // Challenge => Submission => Voted

  Challenge[] challenges;

  struct User {
    bool initialized;
  }

  struct Submission {
    string name;
    address creator;
    uint256 votes;
  }

  struct Challenge {
    string name;
    uint256 startTime;
    uint256 duration;
    address creator;
    uint256 amount;
    Submission[] submissions; // Mappings cannot be iterated upon so we use array
  }

  constructor() {
    adminAddress = msg.sender;
  }

  event ChallengeCreated(address indexed _from, uint256 _challenge_id);
  event SubmissionVote(address indexed _from, uint256 indexed _challenge_id, uint256 indexed _submission_id);
  event SubmissionSent(address indexed _from, uint256 indexed _challenge_id, uint256 indexed _submission_id);

  // ****************************** Challenges ***********************************

  // this allows (in the future whitelisted) users to submit a challenge
  // challenges are attached with bounty amounts that are at least 0.01 Eth.
  // When the challenge time expires, "payout" can be called to distribute funds.
  function submitChallenge(string memory _name, uint256 duration) public payable {
    require(msg.value > 10e15);

    uint256 idx = challenges.length;
    challenges.push();
    Challenge storage c = challenges[idx];
    c.name = _name;
    c.duration = duration;
    c.creator = msg.sender;
    c.startTime = block.timestamp;
    c.amount = msg.value;

    emit ChallengeCreated(msg.sender, idx);
  }

  // use case: after the front end returns the length of all challenges,
  // "returnChallengesByIndex" can be called to individually index detailed info
  // to render the UI
  function returnChallengeCount() public view returns (uint256) {
    return challenges.length;
  }

  // used in conjunction with "returnChallengeCount" to fetch detailed information
  //   about an individual challenge
  function returnChallengesByIndex(uint256 idx)
    public
    view
    returns (
      address,
      string memory,
      uint256
    )
  {
    return (challenges[idx].creator, challenges[idx].name, challenges[idx].amount);
  }

  // ****************************** Submissions ***********************************

  // this allows anyone to submit a submission for an existing challenge
  // the bounty amount is distributed in proportion to the number of votes received.
  function submitSubmission(uint256 _challenge_id, string memory name) public {
    require(returnChallengeCount() > _challenge_id);

    Submission memory new_submission;
    new_submission.name = name;
    new_submission.creator = msg.sender;
    new_submission.votes = 0;

    challenges[_challenge_id].submissions.push(new_submission);
    emit SubmissionSent(msg.sender, _challenge_id, challenges[_challenge_id].submissions.length);
  }

  function fetchSubmissionCountByChallenge(uint256 _challenge_id) public view returns (uint256) {
    return challenges[_challenge_id].submissions.length;
  }

  // Fetch submission details by challenge
  function fetchSubmissionByChallenge(uint256 _challenge_id, uint256 _submission_id)
    public
    view
    returns (
      string memory,
      address,
      uint256
    )
  {
    Submission memory submission = challenges[_challenge_id].submissions[_submission_id];
    return (submission.name, submission.creator, submission.votes);
  }

  // ****************************** votes ***********************************

  // allows any user to vote on a submission. Votes determine who receives the bounty
  function voteOnSubmission(uint256 _challenge_id, uint256 _submission_id) public {
    challenges[_challenge_id].submissions[_submission_id].votes += 1;
    votes[msg.sender][_challenge_id][_submission_id] = true;

    emit SubmissionVote(msg.sender, _challenge_id, _submission_id);
  }

  function hasVoted(uint256 _challenge_id, uint256 _submission_id) public view returns (bool) {
    return votes[msg.sender][_challenge_id][_submission_id];
  }

  // ****************************** user ***********************************

  function initializeUser() public doesUserExist {
    User memory _user;
    _user.initialized = true;
    users[msg.sender] = _user;
  }

  function getUserData() public view returns (bool) {
    return users[msg.sender].initialized;
  }

  function getBalance() public view returns (uint256) {
    return balances[msg.sender];
  }

  // ****************************** payout ***********************************

  function payout(uint256 _challenge_id) public {
    Challenge memory challenge = challenges[_challenge_id];

    require(block.timestamp > challenge.startTime + challenge.duration * 1 days, "Challenge has not ended");
    require(challenge.submissions.length > 0, "No submissions");

    Submission[] memory submissions = challenge.submissions;

    Submission memory winningSubmission = submissions[0];
    for (uint256 i = 0; i < submissions.length; i++) {
      if (submissions[i].votes > winningSubmission.votes) {
        winningSubmission = submissions[i];
      }
    }

    balances[winningSubmission.creator] += challenge.amount;

    //  Emit winner event
  }

  // ****************************** modifiers ***********************************

  modifier doesUserExist() {
    if (users[msg.sender].initialized == false) {
      _;
    }
  }

  // ****************************** other ***********************************

  function returnAdminAddress() public view returns (address) {
    return adminAddress;
  }

  // ADD WHITELIST FUNCTION: ONLY WHITELISTED USER CAN PARTICIPATE IN BOUNTY CREATIONS
}
