const { expect, assert } = require("chai");
const { convertBigNumberArray } = require("./helpers/math");

describe("Bounty Program", function () {
  it("Initialize  contracts", async function () {
    const Bounty = await ethers.getContractFactory("Bounty");
    const bountyContract = await Bounty.deploy();

    await bountyContract.returnAdminAddress();
    await bountyContract.initializeUser();

    let fetchedUserData = await bountyContract.getUserData();
    assert.equal(fetchedUserData[0], true);
  });

  it("Submit Challenges", async () => {
    const Bounty = await ethers.getContractFactory("Bounty");
    const bountyContract = await Bounty.deploy();

    await bountyContract.submitChallenge("SAMPLE");

    let returnedBounties = await bountyContract.returnChallenges();
    assert.deepEqual(returnedBounties, ["SAMPLE"]);
  });

  it("Voting", async () => {
    const Bounty = await ethers.getContractFactory("Bounty");
    const bountyContract = await Bounty.deploy();

    await bountyContract.submitChallenge("SAMPLE");

    // vote on challenge
    await bountyContract.submitSubmission(0);

    // check for returned votes
    let returnedVotes = await bountyContract.returnSingleChallenge(0);
    console.log(returnedVotes.toNumber());
    assert.equal(returnedVotes, 1);
  });
});
