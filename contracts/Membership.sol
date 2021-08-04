// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Membership is Ownable {
  // ideally we want to store more advanced capability permissioning
  // ex: separate members into tiers - each tier has different capabilities
  // store mapping where user is awarded different abilities - in this case no strict tiers

  mapping(address => bool) members;

  constructor(address[] memory _members) {
    // initialize og members
    for (uint256 i = 0; i < _members.length; i++) {
      members[_members[i]] = true;
    }
  }

  function addMember(address _address) public onlyOwner {
    members[_address] = true;
  }

  // used to restrict function usage to only a few members;
  modifier onlyMember() {
    if (members[msg.sender] == true) {
      _;
    }
  }
}
