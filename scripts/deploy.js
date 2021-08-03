async function main() {
  // We get the contract to deploy
  const Bounty = await ethers.getContractFactory("Bounty");
  const bounty = await Bounty.deploy();

  console.log("Bounty Contract deployed to:", bounty.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
