const NSNFTContract = artifacts.require("NSNFTContract");
const baseURL = "https://ipfs.io/ipfs/QmUkomZjcm81RPGiw6g1LzjrPE4eA57YQiYqsh7mzEQw9d/"

module.exports = function(deployer) {
    deployer.deploy(NSNFTContract, baseURL);
};