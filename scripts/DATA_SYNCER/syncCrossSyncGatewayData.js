const { artifacts, ethers, upgrades } = require('hardhat')
const getNamedSigners = require('../../utils/getNamedSigners')
const saveToConfig = require('../../utils/saveToConfig')
const readFromConfig = require('../../utils/readFromConfig')
const deploySettings = require('../deploySettings')
const contractAddresses = require('../../contractAddresses.json')

async function main () {
  const chainId = await hre.getChainId()

  const CHAIN_NAME = deploySettings[chainId].CHAIN_NAME

  console.log("Starting CrossSync Gateway Data Sync On ", CHAIN_NAME)
  const {payDeployer} =  await getNamedSigners();



  try{
    console.log(`Syncing Dest Gateway Addresses on chain ${CHAIN_NAME}`)
    const crossSyncGatewayAddress = await readFromConfig('CrossSyncGateway', 'ADDRESS', chainId)
    const CrossSyncGatewayContract = await ethers.getContractFactory('CrossSyncGateway')
    const crossSyncGatewayContract = CrossSyncGatewayContract.attach(crossSyncGatewayAddress)
    crossSyncGatewayContract.connect(payDeployer)

    const chainIds = Object.keys(contractAddresses)
    for(let i =0;i<chainIds.length;i++) {
        if(chainIds[i] != chainId) {
            try {
                console.log("Checking Dest Gateway Address is set for chainId: ", chainIds[i])
                const key = chainIds[i]
                const chainCrossSyncGatewayAddress = contractAddresses[key].CROSSSYNCGATEWAY
                const contractVal = await crossSyncGatewayContract.destChainGatewayAddress(key);
                if(contractVal != chainCrossSyncGatewayAddress) {
                    console.log("Setting Dest Gateway Address for chainId: ", chainIds[i])
                    console.log(contractVal, " --> " , chainCrossSyncGatewayAddress)
                    const tx = await crossSyncGatewayContract.setDestChainGatewayAddress(key, chainCrossSyncGatewayAddress)
                    await tx.wait()
                    console.log(tx.hash)
                }
            } catch (error) {
                console.log(error.message)
                console.log("Failed for chainId: ", chainIds[i])
            }
        }
    }
  }catch(err){
    console.log(err)
  }


}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})