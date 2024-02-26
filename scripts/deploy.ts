import { ethers } from "hardhat";

async function main() {
  const [owner] =  await ethers.getSigners();

  const NFT = await ethers.deployContract("NFT", [owner]);
  await NFT.waitForDeployment();

  const Marketplace = await ethers.deployContract("NFTMarketplace.sol", [
    owner,
  ]);
  await Marketplace.waitForDeployment();

  console.log(`NFT deployed to ${NFT.target}`);
  console.log(`NFT Marketplace deployed to ${Marketplace.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
