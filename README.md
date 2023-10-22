# CrossSync Protocol
Cross Chain Messaging Aggregator Protocol

![Architecture](./crossSync.png)


Detailed Bigger Demo Link :
<div style="position: relative; padding-bottom: 56.25%; height: 0;"><iframe src="https://www.loom.com/embed/378283b419c7410e9852169f49378115?sid=4d8f6c41-9434-46df-a1d5-d1cb8ef118d6" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe></div>


## About
CrossSync Protocol is a cross-chain messaging aggregator protocol. You may have used Hyperlane, Connext, Wormhole, Axelar, Chainlink CCIP, etc, but these protocols come with various challenges for developers and users. Firstly, they support different types of chains, one is available on some chains and another on some other chains. They also have syntax differences. To integrate one, two, or even three of them, developers need to implement numerous interfaces and understand the workings of the underlying protocol, relayer fees, etc.

To address these challenges and provide a common Interface and Gateway for interacting with multiple messaging interoperability protocols CrossSync has been made, With this users only need to implement and interact with CrossSync Protocol Gateway. They have to call the sendMessage function of the CrossSync Gateway and specify the route ID for sending messages, for example, 1 for Using Axelar, 2 for CCIP, 3 for Connext, 4 for Hyperlane, and 5 for Wormhole. CrossSync Protocol handles the rest and converts all the payload into the payload required for the messenger protocol, you don't have to bother about different kinds of domain IDs, chain names, etc. Additionally, users no longer have to implement individual interfaces to receive messages on the destination chain. A single receiveMessage function is all they need to integrate for receiving the payload.

This protocol is available on Polygon ZKEVM, Mantle Testnet, Scroll Testnet, Goerli, Sepolia, and Mumbai. All contract addresses and abi and details are present in the GitHub repo.

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
```
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
```

### For Receiving Message on Destination Chain
```
interface ICrossSyncReceiverImplementer {

    function receiveMessage(
        uint256 _sourceChainId,
        address _sourceAddress,
        bytes calldata _payload
    ) external payable ;          
}
```

## Networks
- Hyperlane : chains -> Polygon ZKEvm 1442, Mantle Testnet 5001
- Connext : chains -> Polygon ZKEvm 1442, goerli 5, Mumbai 80001
- Axelar : chains -> Polygon ZKEvm 1442, goerli 5, Mumbai 80001, Mantle Testnet 5001, Scroll  534351 
- CCIP: chains  -> Mumbai 80001, Sepolia 
- Wormhole: chains -> mumbai 80001, goerli 5


## Gateway and Implementation  Contracts
https://github.com/mbcse/CrossSync/blob/main/contractAddresses.json


## Future Plans
- Implement Auto Routing
- Implement Token and Other sends
- Implement Common Relayer Fee
- Implement Pay in any token Functionality
- Launch for public use
