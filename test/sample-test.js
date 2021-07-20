const { expect, assert } = require("chai");
const { convertBigNumberArray } = require("./helpers/math");

describe("Bounty Program", function () {
  it("Initialize  contracts", async function () {
    const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy();
    await greeter.returnAdminAddress();

    await greeter.initializeUser();

    let fetchedUserData = await greeter.getUserData();
    assert.equal(fetchedUserData[0], true);
  });

  it("Submit bounty", async () => {
    const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy();

    await greeter.submitBounty("SAMPLE");

    let [name, creator, votes] = await greeter.fetchBountyById(0);
    assert.equal(name, "SAMPLE");

    // Return all bounties
    let bountyNames = await greeter.returnAllBounties();
    assert.equal(bountyNames[0], "SAMPLE");
  });

  it("Voting", async () => {
    const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy();
    await greeter.submitBounty("SAMPLE");

    // vote
    await greeter.voteOnBounty(0);

    // retrieve user information
    let fetchedUserData = await greeter.getUserData();
    assert.deepEqual(convertBigNumberArray(fetchedUserData[1]), ["0"]);

    // retrieve bounty votes
    let fetchedBounty = await greeter.fetchBountyById(0);
    assert.equal(fetchedBounty[2].toNumber(), 1);
  });
});
