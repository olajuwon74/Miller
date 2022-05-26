import { expect } from "chai";
import { ethers } from "hardhat";


describe ("Karoke", function () {
  let Karoke;
  let kar:any;
  const owner = "0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84"
  let ownerSigner:any;
  
  beforeEach(async function () {
  Karoke = await ethers.getContractFactory("Karoke");
  kar = await Karoke.deploy(owner, 1653038404, 1653038604);
    await kar.deployed();

    // Set the owner as the signer
  ownerSigner = await ethers.getSigner(owner)
    });

  it("Should return an increase in index", async function () {
    const signers = await ethers.getSigners();

    await kar.connect(signers[0]).indicate();
    expect(await kar.index()).to.be.equal(2)

    await kar.connect(signers[1]).indicate();
    expect(await kar.index()).to.be.equal(3)

    await kar.connect(signers[2]).indicate();
    expect(await kar.index()).to.be.equal(4)
  })

  it("Should set start session by owner", async function () {
    // console.log(ownerSigner)
    const signers = await ethers.getSigners();

   expect( await kar.connect(signers[2]).startSession(0, 1653039404, 1653938404)).to.be.revertedWith("Not Allowed'");
   
  })

})