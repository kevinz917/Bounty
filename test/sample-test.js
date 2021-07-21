const { expect, assert } = require("chai");

describe("Bounty Program", function () {
  it("Initialize  contracts", async function () {
    const Bounty = await ethers.getContractFactory("Bounty");
    const bountyContract = await Bounty.deploy();

    await bountyContract.returnAdminAddress();
    await bountyContract.initializeUser();

    let fetchedUserData = await bountyContract.getUserData();
    assert.equal(fetchedUserData[0], true);
  });

  // it("Submit Challenges", async () => {
  //   const Bounty = await ethers.getContractFactory("Bounty");
  //   const bountyContract = await Bounty.deploy();

  //   await bountyContract.submitChallenge("SAMPLE");

  //   let returnedBounties = await bountyContract.returnChallenges();
  //   assert.deepEqual(returnedBounties, ["SAMPLE"]);
  // });

  // it("Voting", async () => {
  //   const Bounty = await ethers.getContractFactory("Bounty");
  //   const bountyContract = await Bounty.deploy();

  //   await bountyContract.submitChallenge("SAMPLE", {
  //     value: ethers.utils.parseEther("0.1"),
  //   });
  // });
});
