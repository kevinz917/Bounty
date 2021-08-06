// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/IMembership.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Membership is IMembership, Ownable {
  // TODO: ideally we want to store more advanced capability permissioning
  // ex: separate members into tiers - each tier has different capabilities
  // store mapping where user is awarded different abilities - in this case no strict tiers

  // membership permissioning
  // here we factor memberships into three categories 1-3. 1 is reserved for the admin team whereas 3 is reserved for users.

  struct Member {
    uint256 tier;
  }

  mapping(address => Member) members;

  constructor(address[] memory _members, uint256[] memory _tiers) {
    require(_members.length == _tiers.length, "Member length and tier length doesn't match");

    // initialize members with corresponding tiers
    for (uint256 i = 0; i < _members.length; i++) {
      // how do you an effective number check?
      members[_members[i]] = Member(_tiers[i]);
    }
  }

  // fetch member tier
  function getMemberTier(address _address) public view override returns (uint256) {
    return members[_address].tier;
  }

  function addMember(address _address, uint256 tier) public override onlyOwner {
    members[_address] = Member(tier);
  }

  modifier onlyMember() {
    require(members[msg.sender].tier == 1 || members[msg.sender].tier == 2 || members[msg.sender].tier == 3);
    _;
  }

  modifier onlyAdmin() {
    require(members[msg.sender].tier == 1, "Member isn't admin");
    _;
  }
}
