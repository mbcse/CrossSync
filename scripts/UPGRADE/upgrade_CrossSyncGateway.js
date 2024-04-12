const { ethers, upgrades } = require('hardhat')
const saveToConfig = require('../../utils/saveToConfig')
const readFromConfig = require('../../utils/readFromConfig')
const deploySettings = require('../deploySettings')

async function main () {
    const routeID = 1
    const chainId = await hre.getChainId()
    console.log('chainId: ', chainId)
    // const implData = deploySettings[chainId].MESSENGERS[ImplName]

    console.log(`STARTING CrossSync Gateway UPGRADE ON `, chainId)

    const CHAIN_NAME = deploySettings[chainId].CHAIN_NAME

    const ImplContractV2 = await ethers.getContractFactory("CrossSyncGateway")

    const ImplContractABI = (await artifacts.readArtifact("CrossSyncGateway")).abi
    await saveToConfig("CrossSyncGateway", 'ABI', ImplContractABI, chainId)

    const implContractAddress = await readFromConfig("CrossSyncGateway", 'ADDRESS', chainId)

    console.log('Upgrading CrossSync Contract...')
    const tx = await upgrades.upgradeProxy(implContractAddress, ImplContractV2, {kind:'uups'})
    await new Promise((resolve) => setTimeout(resolve, 25000)) // 25 seconds
    console.log('Impl Contract upgraded')

    console.log('Verifying Implementation Contract...')
    try {
    const currentImplAddress = await upgrades.erc1967.getImplementationAddress(implContractAddress)
    console.log('current implementation address: ', currentImplAddress)
    await run('verify:verify', {
        address: currentImplAddress,
        contract: `${implData.SMART_CONTRACT_PATH}:${"CrossSyncGateway"}`, // Filename.sol:ClassName
        constructorArguments: [],
        network: deploySettings[chainId].NETWORK_NAME
    })
    } catch (error) {
    console.log(error)
    }
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
