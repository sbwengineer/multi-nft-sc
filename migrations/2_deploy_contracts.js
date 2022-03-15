const RaribleContract = artifacts.require("RaribleContract");

module.exports = function(deployer) {
  deployer.deploy(RaribleContract);
};