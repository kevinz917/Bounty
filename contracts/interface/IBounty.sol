// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface BOUNTY {
  function submitChallenge(string memory _name, uint256 duration) external payable;

  function returnChallengeCount() external view returns (uint256);

  function returnChallengesByIndex(uint256 idx) external;

  function submitSubmission(uint256 _challenge_id, string memory name) external;

  function fetchSubmissionCountByChallenge(uint256 _challenge_id) external view returns (uint256);

  function fetchSubmissionByChallenge(uint256 _challenge_id, uint256 _submission_id)
    external
    view
    returns (
      string memory,
      address,
      uint256
    );
}
