const { artifacts, ethers, upgrades } = require('hardhat')
const getNamedSigners = require('../../utils/getNamedSigners')
const saveToConfig = require('../../utils/saveToConfig')
const readFromConfig = require('../../utils/readFromConfig')
const deploySettings = require('../deploySettings')
const {runCommand} = require('../../utils/runCommand')
const contractAddresses = require('../../contractAddresses.json')
async function main () {
    const chains = Object.keys(deploySettings)
    for(let i =0;i<chains.length;i++) {
      const key = chains[i]
      // console.log(key)
      try {
          if(key !== 'COMMON' && deploySettings[key].ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED){
            console.log(`Executing on chainId ${key}`)
            if(!contractAddresses[key] || !contractAddresses[key]["CROSSSYNCGATEWAY"])
            await runCommand(`npx hardhat run scripts/DEPLOY/deploy_CrossSyncGateway.js --network ${deploySettings[key].NETWORK_NAME}`)
            else console.log(`Already Executed on chainId ${key}`)
            console.log(`Execution Completed on chainId ${key}`)
          }
      } catch (error) {
        console.log(error)
      }
    }
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
