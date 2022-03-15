const HDWalletProvider = require("@truffle/hdwallet-provider");
require('dotenv').config()

const { BSC_API, TEST_API, MNEMONIC } = process.env;
module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
      gas: 5000000
    },
    testnet: {
      provider: function() {
        return new HDWalletProvider(MNEMONIC, TEST_API)
      },
      network_id:97,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    bsc: {
      provider: function() {
        return new HDWalletProvider(MNEMONIC, BSC_API)
      },
      network_id:56,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },

  },
  compilers: {
    solc: {
      version:"0.8.0",
      settings: {
        optimizer: {
          enabled: true, // Default: false
          runs: 200      // Default: 200
        },
      }
    }
  },
  plugins: ['truffle-plugin-verify'],
  api_keys: {
    bscscan: process.env.BSCSCAN_API_KEY
  }

};