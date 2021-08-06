// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMembership {
  function addMember(address _address, uint256 tier) external;

  function getMemberTier(address _adddress) external view returns (uint256);
}
