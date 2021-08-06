const { expect, assert } = require("chai");

describe("Membership Contract", async function () {
  let membership;
  let membershipContract;
  let owner;
  let addr1;
  let addr2;

  before(async function () {
    membership = await ethers.getContractFactory("Membership");
  });

  it("Initialize members", async () => {
    await expect(membership.deploy([], [1, 2, 3])).to.be.revertedWith("Member length and tier length doesn't match");

    membershipContract = await membership.deploy([], []);
    [owner, addr1, addr2] = await ethers.getSigners();
  });

  it("Add member from admin", async () => {
    await membershipContract.addMember(addr1.address, 1);
  });

  it("Non admin cannot add members", async () => {
    await membershipContract.addMember(addr1.address, 1);
    await expect(membershipContract.connect(addr2).addMember(addr2.address, 1)).to.be.revertedWith("Ownable: caller is not the owner");
  });

  it("Get member status", async () => {
    const tier = await membershipContract.getMemberTier(addr1.address);
    assert.equal(tier, 1);
  });
});
