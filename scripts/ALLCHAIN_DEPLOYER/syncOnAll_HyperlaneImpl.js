const { artifacts, ethers, upgrades } = require('hardhat')
const getNamedSigners = require('../../utils/getNamedSigners')
const saveToConfig = require('../../utils/saveToConfig')
const readFromConfig = require('../../utils/readFromConfig')
const deploySettings = require('../deploySettings')
const {runCommand} = require('../../utils/runCommand')
async function main () {
    const chains = Object.keys(deploySettings)
    for(let i =0;i<chains.length;i++) {
      const key = chains[i]
      // console.log(key)
      try {
          if(key !== 'COMMON' && deploySettings[key].ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED){
            console.log(`Executing on chainId ${key}`)
            const MESSENGERS = Object.keys(deploySettings[key].MESSENGERS)
            for(let j =0;j<MESSENGERS.length;j++) {
              if(MESSENGERS[j] === "HYPERLANE"){
                await runCommand(`npx hardhat run scripts/DATA_SYNCER/syncHyperlaneImplData.js --network ${deploySettings[key].NETWORK_NAME}`)
              }
            }
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
