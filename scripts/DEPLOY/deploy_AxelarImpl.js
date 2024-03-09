const { artifacts, ethers, upgrades } = require('hardhat')
const getNamedSigners = require('../../utils/getNamedSigners')
const saveToConfig = require('../../utils/saveToConfig')
const readFromConfig = require('../../utils/readFromConfig')

const generateRandomId = require('../../utils/randomIdGenerator')

const deploySettings = require('../deploySettings')
const sleep = require('../../utils/sleep')

let args = process.argv.slice(2);


async function main () {
  const ImplName = "AXELAR"
  const routeID = 1
  const chainId = await hre.getChainId()
  console.log('chainId: ', chainId)

  console.log(`STARTING ${ImplName} IMPL DEPLOYMENT ON `, chainId)

  const implData = deploySettings[chainId].MESSENGERS[ImplName]

  const CHAIN_NAME = deploySettings[chainId].CHAIN_NAME
  const EIP712_NAME = deploySettings[chainId].EIP712_NAME
  const EIP712_VERSION = deploySettings[chainId].EIP712_VERSION

  const CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS = deploySettings[chainId].CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS
  const CHAIN_NATIVE_CURRENCY_ADDRESS = deploySettings[chainId].CHAIN_NATIVE_CURRENCY_ADDRESS

  const OWNER_ADDRESS = deploySettings["COMMON"].OWNER_ADDRESS
  const CROSS_SYNC_GATEWAY_ADDRESS = await readFromConfig('CrossSyncGateway', 'ADDRESS', chainId)


  // Impl Specific
  const AXELAR_GATEWAY_ADDRESS = implData.GATEWAY_ADDRESS
  const AXELAR_GAS_PAYMASTER_ADDRESS = implData.GAS_PAYMASTER
  // Impl Specific
  console.log(`DEPLOYING ${ImplName} IMPL SMART CONTRACT`)
  const {payDeployer} =  await getNamedSigners();
  console.log('Deploying using Owner Address: ', payDeployer.address)
  const IMPL_CONTRACT = await ethers.getContractFactory(implData.SMART_CONTRACT_NAME)
  IMPL_CONTRACT.connect(payDeployer)

  const implABI = (await artifacts.readArtifact(implData.SMART_CONTRACT_NAME)).abi
  await saveToConfig(implData.SMART_CONTRACT_NAME, 'ABI', implABI, chainId)

  const implContract = await upgrades.deployProxy(IMPL_CONTRACT, [CROSS_SYNC_GATEWAY_ADDRESS, CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS, CHAIN_NATIVE_CURRENCY_ADDRESS, OWNER_ADDRESS, AXELAR_GATEWAY_ADDRESS, AXELAR_GAS_PAYMASTER_ADDRESS], { initializer: 'initialize', kind:'uups' })
  await implContract.deployed()

  await saveToConfig(implData.SMART_CONTRACT_NAME, 'ADDRESS', implContract.address, chainId)
  console.log(`${ImplName} deployed to: ${implContract.address} on ${CHAIN_NAME}`)

  let crossSyncGatewayContract = await ethers.getContractFactory("CrossSyncGateway");
  crossSyncGatewayContract = crossSyncGatewayContract.attach(CROSS_SYNC_GATEWAY_ADDRESS)
  crossSyncGatewayContract.connect(payDeployer)

  await sleep(20000)

  const routeData = await crossSyncGatewayContract.getRoute(routeID)
  if(routeData[0] === "0x0000000000000000000000000000000000000000") {
    console.log(`Adding ${ImplName} Route to CrossSyncGateway`)
    const tx1 = await crossSyncGatewayContract.addRoute(routeID, implContract.address, ImplName)
    await tx1.wait()
    console.log(tx1.hash)
    console.log(`Added ${ImplName} Impl route to CrossSync Gateway with id ${routeID}`)

  }else{
    console.log(`Route ${routeID} already exists, Updating Route Address`)
    const tx2 = await crossSyncGatewayContract.setRouteAddress(routeID, implContract.address)
    await tx2.wait()
    console.log(tx2.hash)
    console.log(`Updated ${ImplName} Impl route address in CrossSync Gateway with id ${routeID}`)
  }

  console.log('Verifying Implementation Contract...')
  try {
      const currentImplAddress = await upgrades.erc1967.getImplementationAddress(implContract.address)
      console.log('current implementation address: ', currentImplAddress)
      await run('verify:verify', {
      address: currentImplAddress,
      contract: `${implData.SMART_CONTRACT_PATH}:${implData.SMART_CONTRACT_NAME}`, // Filename.sol:ClassName
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
