import { network } from "hardhat";

const { ethers } = await network.create();

const Addition = await ethers.getContractFactory("Addition");
const addition = await Addition.deploy();
await addition.waitForDeployment();

console.log("Addition deployed to:", await addition.getAddress());
