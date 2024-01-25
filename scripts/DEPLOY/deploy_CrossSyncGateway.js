const { artifacts, ethers, upgrades } = require('hardhat')
const getNamedSigners = require('../../utils/getNamedSigners')
const saveToConfig = require('../../utils/saveToConfig')
const readFromConfig = require('../../utils/readFromConfig')
const deploySettings = require('../deploySettings')

async function main () {

  const chainId = await hre.getChainId()
  console.log("STARTING CROSS SYNC GATEWAY DEPLOYMENT ON ", chainId)

  const CHAIN_NAME = deploySettings[chainId].CHAIN_NAME
  const EIP712_NAME = deploySettings[chainId].EIP712_NAME
  const EIP712_VERSION = deploySettings[chainId].EIP712_VERSION

  const CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS = deploySettings[chainId].CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS
  const CHAIN_NATIVE_CURRENCY_ADDRESS = deploySettings[chainId].CHAIN_NATIVE_CURRENCY_ADDRESS

  const OWNER_ADDRESS = deploySettings["COMMON"].OWNER_ADDRESS
  const FEE_ADDRESS = deploySettings["COMMON"].FEE_ADDRESS


  console.log('Deploying CrossSync Gateway Smart Contract')
  const {payDeployer} =  await getNamedSigners();
  console.log('Deploying using Owner Address: ', payDeployer.address)

  const CROSS_SYNC_GATEWAY_CONTRACT = await ethers.getContractFactory('CrossSyncGateway')
  CROSS_SYNC_GATEWAY_CONTRACT.connect(payDeployer)

  const gatewayABI = (await artifacts.readArtifact('CrossSyncGateway')).abi
  await saveToConfig(`CrossSyncGateway`, 'ABI', gatewayABI, chainId)

  const crossSyncGatewayContract = await upgrades.deployProxy(CROSS_SYNC_GATEWAY_CONTRACT, [EIP712_NAME, EIP712_VERSION, CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS, CHAIN_NATIVE_CURRENCY_ADDRESS, OWNER_ADDRESS, FEE_ADDRESS], { initializer: 'initialize', kind:'uups' })
  await crossSyncGatewayContract.deployed()

  await saveToConfig(`CrossSyncGateway`, 'ADDRESS', crossSyncGatewayContract.address, chainId)
  console.log('CrossSyncGateway contract deployed to:', crossSyncGatewayContract.address, ` on ${CHAIN_NAME}`)

  console.log('Verifying CrossSyncGateway Contract...')
  try {
    const currentImplAddress = await upgrades.erc1967.getImplementationAddress(crossSyncGatewayContract.address)
    console.log('current implementation address: ', currentImplAddress)
    await run('verify:verify', {
      address: currentImplAddress,
      contract: 'contracts/CrossSyncGateway.sol:CrossSyncGateway', // Filename.sol:ClassName
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
