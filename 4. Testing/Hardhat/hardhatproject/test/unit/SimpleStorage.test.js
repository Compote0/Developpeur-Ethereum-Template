// @Hardhat avancé test
const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const helpers = require("@nomicfoundation/hardhat-network-helpers");

describe("SimpleStorage tests", function () {
    async function deployContract() {
      const [owner, otherAccount] = await ethers.getSigners();
      const SimpleStorage = await ethers.getContractFactory("SimpleStorage");
      const simpleStorage = await SimpleStorage.deploy(SimpleStorage);
      return { simpleStorage, owner, otherAccount };
    }

    describe("Deployment", function () {
      it("Should deploy the smart contract", async function () {
        const { simpleStorage } = await loadFixture(deployContract);
        expect(await simpleStorage.getValue()).to.equal(0);
      });
    });

    describe("Set", function() {
      it("Should set a new value inside the smart contract", async function () {
        const { simpleStorage, owner, otherAccount } = await loadFixture(deployContract);
        const newValue = 42;
        await simpleStorage.connect(otherAccount).setValue(newValue);
        const storedValue = await simpleStorage.getValue();
        expect(storedValue).to.equal(newValue);
      });
    })

    describe("getCurrentTimestamp", function() {
      it("Should get the current timestamp", async function () {
        const { simpleStorage } = await loadFixture(deployContract);
        await helpers.time.increaseTo(2000000000);
        let currentTimestamp = await simpleStorage.getCurrentTime();
        expect(Number(currentTimestamp)).to.equal(2000000000);

        await helpers.mine(1000, { interval: 15 });
        let timestampOfLastBlock = await helpers.time.latest();
        console.log(Number(timestampOfLastBlock))
      });
  });
});


/*
// @Hardhat Native Test

const { assert, expect } = require("chai");
const { ethers } = require('hardhat');

describe("SimpleStorage Tests", function () {
  let owner, addr1, addr2, addr3;
  let simpleStorage;

  beforeEach(async function() {
    [owner, addr1, addr2, addr3] = await ethers.getSigners();

    simpleStorage = await ethers.getContractFactory('SimpleStorage');
    simpleStorage = await simpleStorage.deploy()
  })

  describe('Set and Get number', function () {
    it('should get the number and the number should be equal to 0', async function() {
      let number = await simpleStorage.getNumber();
      assert(number.toString() === "0");
    });


    it('should NOT set the number to 99', async function() {
      await expect(simpleStorage.connect(addr1).setNumber(99)).to.be.
      revertedWithCustomError(
        simpleStorage,
        'NumberOutOfRange',
      )
    });

    it('should set the number to 7', async function() {
      await simpleStorage.connect(addr1).setNumber(7);
      let number = await simpleStorage.connect(addr1).getNumber();
      assert(number.toString() === "7");
    });

    it('should get the number with different accounts', async function() {
      await simpleStorage.connect(addr1).setNumber(7);
      let number = await simpleStorage.connect(addr1).getNumber();
      assert(number.toString() === "7");

      await simpleStorage.connect(addr2).setNumber(9);
      number = await simpleStorage.connect(addr2).getNumber();
      assert(number.toString() === "9");
    });

    it('should emit an event if the number is changed', async function() {
      await expect(simpleStorage.setNumber(4)).to.emit(simpleStorage, 'NumberChanged').withArgs(owner.address, 4);
    });

  });
});
*/
