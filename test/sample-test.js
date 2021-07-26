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
    await bountyContract.submitChallenge("First Bounty");

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
    let secondSubmission = await bountyContract.fetchSubmissionByChallenge(0, 1);
    assert.equal(secondSubmission[0], "Second submission");

    // Count submissions
    let count = await bountyContract.fetchSubmissionCountByChallenge(0);
    assert.equal(2, count);
  });

  it("Vote on submission", async () => {
    await bountyContract.voteOnSubmission(0, 0);

    let hasUserVoted = await bountyContract.hasVoted(0, 0);
    assert.equal(hasUserVoted, true);
  });
});
