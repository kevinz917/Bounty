pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Greeter {
    address adminAddress;
    mapping(address => User) users;
    Bounty[] bounties;

    struct User {
        bool initialized;
        uint256[] votes;
    }

    struct Bounty {
        string name;
        address creator;
        uint256 votes;
    }

    constructor() {
        adminAddress = msg.sender;
    }

    // bounty
    function submitBounty(string memory _name) public {
        Bounty memory new_bounty = Bounty({
            name: _name,
            creator: msg.sender,
            votes: 0
        });
        bounties.push(new_bounty);
    }

    function returnAllBounties() public view returns (string[] memory) {
        string[] memory bountyNames = new string[](bounties.length);
        for (uint256 i = 0; i < bounties.length; i++) {
            bountyNames[0] = bounties[i].name;
        }
        return bountyNames;
    }

    // vote
    function voteOnBounty(uint256 _id) public {
        bounties[_id].votes += 1;
        users[msg.sender].votes.push(_id);
    }

    function fetchBountyById(uint256 _id)
        public
        view
        returns (
            string memory,
            address,
            uint256
        )
    {
        return (bounties[_id].name, bounties[_id].creator, bounties[_id].votes);
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
