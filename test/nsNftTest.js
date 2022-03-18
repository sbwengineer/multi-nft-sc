const nsNft = artifacts.require("NSNFTContract");
const truffleAssert = require('truffle-assertions');
require('dotenv').config();
const Account = require('eth-lib/lib/account');
const ethereumjsUtil = require('ethereumjs-util');

contract("m9e", function (accounts) {
  let nsNftContract;
  beforeEach('should setup the contract interface', async() => {
    nsNftContract = await nsNft.deployed();
  });

  describe('Contract Name and Symbol check', function(){
    it("should return NSNFTContract as contract name", async function (){
      const name = await nsNftContract.name();
      assert.equal(name, 'NSNFTContract');
    });

    it("should return NSN as contract symbol", async function (){
      const symbol = await nsNftContract.symbol();
      assert.equal(symbol, 'NSN');
    });
  });
});
