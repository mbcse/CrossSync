const { artifacts, ethers, upgrades } = require('hardhat')
const getNamedSigners = require('../../utils/getNamedSigners')
const saveToConfig = require('../../utils/saveToConfig')
const readFromConfig = require('../../utils/readFromConfig')
const deploySettings = require('../deploySettings')
const contractAddresses = require('../../contractAddresses.json')

async function main () {
  const chainId = await hre.getChainId()

  const CHAIN_NAME = deploySettings[chainId].CHAIN_NAME

  console.log("Starting Wormhole Impl Data Sync On ", CHAIN_NAME)
  const {payDeployer} =  await getNamedSigners();



  try{
    console.log(`Syncing Wormhole Impl Addresses on chain ${CHAIN_NAME}`)
    const messengerAddress = await readFromConfig('WORMHOLEIMPL', 'ADDRESS', chainId)
    const MessengerContract = await ethers.getContractFactory('WormholeImpl')
    const messengerContract = MessengerContract.attach(messengerAddress)
    messengerContract.connect(payDeployer)

    const chainIds = Object.keys(contractAddresses)
    for(let i =0;i<chainIds.length;i++) {
        if(chainIds[i] != chainId) {
            try {
                console.log("Checking Wormhole Impl Address is set for chainId: ", chainIds[i])
                const key = chainIds[i]
                const chainMessengerAddress = contractAddresses[key].WORMHOLEIMPL
                const contractVal = await messengerContract.wormholeChainImplAddress(key);
                if(contractVal != chainMessengerAddress) {
                    console.log("Setting WormholeImpl Address for chainId: ", chainIds[i])
                    console.log(contractVal, " --> " , chainMessengerAddress)
                    const tx = await messengerContract.setWormholeChainImplAddress(key, chainMessengerAddress)
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



  try{
    console.log(`Syncing Wormhole Impl ChainIds on chain ${CHAIN_NAME}`)
    const messengerAddress = await readFromConfig('WORMHOLEIMPL', 'ADDRESS', chainId)
    const MessengerContract = await ethers.getContractFactory('WormholeImpl')
    const messengerContract = MessengerContract.attach(messengerAddress)
    messengerContract.connect(payDeployer)

    const chainIds = Object.keys(deploySettings)
    for(let i =0;i<chainIds.length;i++) {
        if(chainIds[i] != chainId && chainIds[i] != 'COMMON') {
            try {
                console.log("Checking Wormhole ChainId is set for chainId: ", chainIds[i])
                const key = chainIds[i]
                const uniqueKey = deploySettings[key].MESSENGERS.WORMHOLE.WORMHOLE_CHAIN_ID
                const contractVal = await messengerContract.wormholeChainId(key);
                if(contractVal != uniqueKey) {
                    console.log("Setting WormholeImpl ChainId for chainId: ", chainIds[i])
                    console.log(contractVal, " --> " , uniqueKey)
                    const tx = await messengerContract.setWormholeChainId(key, uniqueKey)
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