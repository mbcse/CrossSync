# CrossSync Protocol
Cross Chain Messaging Aggregator Protocol

Detailed Bigger Demo Link : https://www.loom.com/share/378283b419c7410e9852169f49378115?sid=d9b22c53-7553-4982-ad56-c75ca74c8092

## About
CrossSync Protocol is a cross-chain messaging aggregator protocol. You may have used Hyperlane, Connext, Wormhole, Axelar, Chainlink CCIP, but these protocols come with various challenges for developers and users. Firstly, they support different types of chains and have syntax differences. To integrate one, two, or even three of them, developers need to implement numerous interfaces.

To address these challenges and provide a common interface for interacting with multiple messaging interoperability protocols, users only need to implement the sendMessage function of the CrossSync Gateway and specify the route ID for sending messages. CrossSync Protocol handles the rest. Additionally, users no longer have to implement individual interfaces to receive messages on the destination chain. A single receiveMessage function is all they need to integrate for receiving the payload

## Testing 
### ROUTE IDs:
- 0: NATIVE(Not Supported Yet)
- 1: AXELAR
- 2: CCIP
- 3: CONNEXT
- 4: HYPERLANE
- 5: WORMHOLE


## CrossSync Gateway Interfaces

### For Sending Message/Call Contract on Destination Chain
`
interface ICrossSyncGateway {

    struct MessagingPayload{
        address to;
        bytes data;
    }

    function sendMessage(
        uint256 _destinationChainId,
        uint256 _routeId,
        MessagingPayload calldata _payload,
        bytes calldata _routeData
    ) external payable;
}
`

### For Receiving Message on Destination Chain
`
interface ICrossSyncReceiverImplementer {

    function receiveMessage(
        uint256 _sourceChainId,
        address _sourceAddress,
        bytes calldata _payload
    ) external payable ;          
}
`

## Networks
- Hyperlane : chains -> Polygon ZKEvm 1442, Mantle Testnet 5001
- Connext : chains -> Polygon ZKEvm 1442, goerli 5, Mumbai 80001
- Axelar : chains -> Polygon ZKEvm 1442, goerli 5, Mumbai 80001, Mantle Testnet 5001, Scroll  534351 
- CCIP: chains  -> Mumbai 80001, Sepolia 
- Wormhole: chains -> mumbai 80001, goerli 5


## Gateway and Implementation  Contracts
https://github.com/mbcse/CrossSync/blob/main/contractAddresses.json


