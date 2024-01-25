const { artifacts, ethers, upgrades } = require('hardhat')
const getNamedSigners = require('../../utils/getNamedSigners')
const saveToConfig = require('../../utils/saveToConfig')
const readFromConfig = require('../../utils/readFromConfig')
const deploySettings = require('../deploySettings')
const contractAddresses = require('../../contractAddresses.json')

async function main () {
  const chainId = await hre.getChainId()

  const CHAIN_NAME = deploySettings[chainId].CHAIN_NAME

  console.log("Starting Hyperlane Impl Data Sync On ", CHAIN_NAME)
  const {payDeployer} =  await getNamedSigners();



  try{
    console.log(`Syncing Hyperlane Impl Addresses on chain ${CHAIN_NAME}`)
    const messengerAddress = await readFromConfig('HYPERLANEIMPL', 'ADDRESS', chainId)
    const MessengerContract = await ethers.getContractFactory('HyperlaneImpl')
    const messengerContract = MessengerContract.attach(messengerAddress)
    messengerContract.connect(payDeployer)

    const chainIds = Object.keys(contractAddresses)
    for(let i =0;i<chainIds.length;i++) {
        if(chainIds[i] != chainId) {
            try {
                console.log("Checking Hyperlane Impl Address is set for chainId: ", chainIds[i])
                const key = chainIds[i]
                const chainMessengerAddress = contractAddresses[key].HYPERLANEIMPL
                const contractVal = await messengerContract.hyperlaneChainImplAddress(key);
                if(contractVal != chainMessengerAddress) {
                    console.log("Setting HyperlaneImpl Address for chainId: ", chainIds[i])
                    console.log(contractVal, " --> " , chainMessengerAddress)
                    const tx = await messengerContract.setHyperlaneChainImplAddress(key, chainMessengerAddress)
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
    console.log(`Syncing Hyperlane Impl ChainNames on chain ${CHAIN_NAME}`)
    const messengerAddress = await readFromConfig('HYPERLANEIMPL', 'ADDRESS', chainId)
    const MessengerContract = await ethers.getContractFactory('HyperlaneImpl')
    const messengerContract = MessengerContract.attach(messengerAddress)
    messengerContract.connect(payDeployer)

    const chainIds = Object.keys(deploySettings)
    for(let i =0;i<chainIds.length;i++) {
        if(chainIds[i] != chainId && chainIds[i] != 'COMMON') {
            try {
                console.log("Checking Hyperlane Chain Domain Id is set for chainId: ", chainIds[i])
                const key = chainIds[i]
                const uniqueKey = deploySettings[key].MESSENGERS.HYPERLANE.HYPERLANE_DOMAIN_ID
                const contractVal = await messengerContract.hyperlaneChainDomain(key);
                if(contractVal != uniqueKey) {
                    console.log("Setting HyperlaneImpl Chain Domain Id for chainId: ", chainIds[i])
                    console.log(contractVal, " --> " , uniqueKey)
                    const tx = await messengerContract.setHyperlaneChainDomain(key, uniqueKey)
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