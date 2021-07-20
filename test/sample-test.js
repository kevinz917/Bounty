const { expect, assert } = require("chai");

describe("Bounty Program", function () {
  it("Initialize  contracts", async function () {
    const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy();
    await greeter.returnAdminAddress();

    await greeter.initializeUser();

    let fetchedUserData = await greeter.getUserData();
    console.log(fetchedUserData);
    assert.equal(fetchedUserData.initialized, true);
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
});
