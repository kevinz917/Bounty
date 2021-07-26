// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Bounty {
  address public adminAddress;

  mapping(address => User) users;
  mapping(address => uint256) private balances;

  mapping(address => mapping(uint256 => mapping(uint256 => bool))) votes; // Challenge => Submission => Voted

  Challenge[] challenges;

  struct User {
    bool initialized; // Perhaps store more metadata
  }

  struct Submission {
    string name;
    address creator;
    uint256 votes; // Should we store a mapping as well?
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

  event Vote(address indexed _from, uint256 indexed _challenge_id, uint256 indexed _submission_id);

  // Challenges - with bounty amount
  function submitChallenge(string memory _name, uint256 duration) public payable {
    require(msg.value > 10e15); // at least 0.01 ETH

    uint256 idx = challenges.length;
    challenges.push();
    Challenge storage c = challenges[idx];
    c.name = _name;
    c.duration = duration;
    c.creator = msg.sender;
    c.startTime = block.timestamp;
    c.amount = msg.value;
  }

  function returnChallengeCount() public view returns (uint256) {
    return challenges.length;
  }

  // Return single Challenge by index
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

  /////////////////////////////////////////////////////////////////////////////

  // Add submission to a challenge
  function submitSubmission(uint256 _challenge_id, string memory name) public {
    Submission memory new_submission;
    new_submission.name = name;
    new_submission.creator = msg.sender;
    new_submission.votes = 0;

    challenges[_challenge_id].submissions.push(new_submission);

    // Add submission event
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

  /////////////////////////////////////////////////////////////////////////////
  // Vote on a submission
  function voteOnSubmission(uint256 _challenge_id, uint256 _submission_id) public {
    challenges[_challenge_id].submissions[_submission_id].votes += 1;
    votes[msg.sender][_challenge_id][_submission_id] = true;

    emit Vote(msg.sender, _challenge_id, _submission_id);
  }

  function hasVoted(uint256 _challenge_id, uint256 _submission_id) public view returns (bool) {
    return votes[msg.sender][_challenge_id][_submission_id];
  }

  //////////////////////// USER ///////////////////////////////////////////////
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

  ////// Payout function ///
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

    // EMIT WINNER EVENT
  }

  //////////////////////// modifiers ////////////////////////
  modifier doesUserExist() {
    if (users[msg.sender].initialized == false) {
      _;
    }
  }

  /////////////////////////// Other /////////////////////////////////////////////
  function returnAdminAddress() public view returns (address) {
    return adminAddress;
  }

  // ADD WHITELIST FUNCTION: ONLY WHITELISTED USER CAN PARTICIPATE IN BOUNTY CREATIONS
}
