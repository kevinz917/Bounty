const { expect, assert } = require("chai");

describe("Bounty Program", async function () {
  let bountyContract;
  let owner;
  let addr1;

  // NOTE
  // to execute command from another account, we can do this: await bountyContract.connect(addr1).initializeUser();

  it("Initialization", async () => {
    Bounty = await ethers.getContractFactory("Bounty");
    bountyContract = await Bounty.deploy();
    [owner, addr1] = await ethers.getSigners();
  });

  it("Initialize  contracts", async function () {
    await bountyContract.returnAdminAddress();
    await bountyContract.initializeUser();

    let fetchedUserData = await bountyContract.getUserData();
    assert.equal(fetchedUserData, true);
  });

  it("Submit Challenges", async () => {
    await bountyContract.submitChallenge("First Bounty", 10, { value: "100000000000000000000" });

    // Challenge count
    let contractCount = await bountyContract.returnChallengeCount();
    assert.equal(contractCount, 1);

    // Return challenge info based on index
    let returnedBounty = await bountyContract.returnChallengesByIndex(0);
    assert.equal(returnedBounty[1], "First Bounty");

    assert.equal(returnedBounty[0], owner.address);
  });

  it("Submit submission", async () => {
    await bountyContract.submitSubmission(0, "First submission");

    // Fetch submission from index
    let submission = await bountyContract.fetchSubmissionByChallenge(0, 0);
    assert.equal(submission[0], "First submission");
    assert.equal(submission[1], owner.address);
    assert.equal(submission[2], 0);

    // Submit a second submission for first challenge
    await bountyContract.submitSubmission(0, "Second submission");
    let secondSubmissionInfo = await bountyContract.fetchSubmissionByChallenge(0, 1);
    expect(secondSubmissionInfo[0]).to.equal("Second submission");
  });

  it("Vote on submission", async () => {
    await bountyContract.voteOnSubmission(0, 0);
    expect(await bountyContract.hasVoted(0, 0)).to.equal(true);
  });

  it("Payout mechanism", async () => {
    await expect(bountyContract.payout(0)).to.be.revertedWith("Challenge has not ended"); // Challenge has not ended
    expect(await bountyContract.getBalance()).to.be.equal(0); // Balance should be zero
  });

  it("Submit second challenge", async () => {
    await bountyContract.submitChallenge("First Bounty", 0, { value: "100000000000000000000" }); // Create a second challenge that instantly ends
    await expect(bountyContract.payout(1)).to.be.revertedWith("No submissions"); // Reverted due to no submissions

    await bountyContract.submitSubmission(1, "First submission of second challenge");
    await bountyContract.payout(1);
    let balance = await bountyContract.getBalance();
    expect(balance, 100000000000000000000);
  });
});
