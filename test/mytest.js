const rarible = artifacts.require("RaribleContract");
const truffleAssert = require('truffle-assertions');
require('dotenv').config();
const Account = require('eth-lib/lib/account');
const ethereumjsUtil = require('ethereumjs-util');
// const BN = require('bn.js');

contract("m9e", function (accounts) {
  console.log(accounts);
  let raribleContract;
  beforeEach('should setup the contract interface', async() => {
    raribleContract = await rarible.deployed();
  });

  describe('Contract Name and Symbol check', function(){
    it("should return Rarible as contract name", async function (){
      const name = await raribleContract.name();
      assert.equal(name, 'Rarible');
    });

    it("should return RN as contract symbol", async function (){
      const symbol = await raribleContract.symbol();
      assert.equal(symbol, 'RN');
    });
  });
});
