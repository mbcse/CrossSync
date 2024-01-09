// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
pragma abicoder v2;


import './interfaces/IMessagingImplBase.sol';
import '../interfaces/ICrossSyncGateway.sol';

interface IWormholeRelayer {
    function sendPayloadToEvm(
        uint16 targetChain,
        address targetAddress,
        bytes memory payload,
        uint256 receiverValue,
        uint256 gasLimit
    ) external payable returns (uint64 sequence);

    function quoteEVMDeliveryPrice(
        uint16 targetChain,
        uint256 receiverValue,
        uint256 gasLimit
    ) external view returns (
        // How much value to attach to the send call
        uint256 nativePriceQuote, 
        // 
        uint256 targetChainRefundPerGasUnused
    );
}

contract WormholeImpl is IMessagingImplBase {
    IWormholeRelayer public wormholeRelayer;

    mapping(uint256 => uint16) public wormholeChainId;
    mapping(uint16 => uint256) public wormholeChainIdToChainId;
    mapping(uint256 => address) public wormholeChainImplAddress;

   mapping(bytes32 => mapping(bytes32 =>bool)) public messageSeen;

    uint256 GAS_LIMIT;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _crossSyncGatewayAddress, address _nativeCurrencyWrappedAddress, address _nativeCurrencyAddress, address _owner, address _wormholeRelayerAddress) public initializer {
        IMessagingImplBase_init(_crossSyncGatewayAddress, _nativeCurrencyWrappedAddress, _nativeCurrencyAddress, _owner);
        wormholeRelayer = IWormholeRelayer(_wormholeRelayerAddress);
        GAS_LIMIT = 50_000;
    }

    function executeSendMessage(ICrossSyncMessagingData calldata _data) override public payable nonReentrant returns(bytes memory){
        require(_msgSender() == crossSyncGatewayAddress, 'Only CrossSyncGateway can call this function');
        uint256 cost = quoteCrossChainFee(wormholeChainId[_data.destinationChainId]);
        require(msg.value > cost, 'Gas payment is less');
        bytes memory payload = abi.encode(_data);
        wormholeRelayer.sendPayloadToEvm{value: cost}(
            wormholeChainId[_data.destinationChainId],
            _data.destinationGatewayAddress,
            payload, // payload
            0, // no receiver value needed since we're just passing a message
            GAS_LIMIT
        );
    }

    function setWormholeRelayer(IWormholeRelayer _wormholeRelayer) public onlySuperAdmin{
        wormholeRelayer = _wormholeRelayer;
    }

    // Setter function for updating values in wormholeChainId mapping
    function setWormholeChainId(uint256 _chainId, uint16 _wormholeChainId) public onlySuperAdmin{
        wormholeChainId[_chainId] = _wormholeChainId;
        wormholeChainIdToChainId[_wormholeChainId] = _chainId;
    }


    function setWormholeGasLimit(uint256 newGasLimit) public onlySuperAdmin{
        GAS_LIMIT = newGasLimit;
    }


    function quoteCrossChainFee(uint16 targetChain) public view returns (uint256 cost) {
        // Cost of delivering token and payload to targetChain
        uint256 deliveryCost;
        (deliveryCost,) = wormholeRelayer.quoteEVMDeliveryPrice(targetChain, 0, GAS_LIMIT);

        // Total cost: delivery cost + cost of publishing the 'sending token' wormhole message
        cost = deliveryCost + 0;
    }


    // WormHole Receiver 
    function receiveWormholeMessages(
        bytes calldata payload,
        bytes[] memory additionalVaas,
        bytes32 sourceAddress,
        uint16 sourceChain,
        bytes32 deliveryHash
    ) external payable nonReentrant{
        require(msg.sender == address(wormholeRelayer), 'WormholeImpl: Only WormholeRelayer can call this function');
        require(sourceAddress == addressToBytes32(wormholeChainImplAddress[wormholeChainIdToChainId[sourceChain]]), 'WormholeImpl: Invalid source address');
        
        bytes32 payloadHash  = keccak256(payload);
        require(!messageSeen[deliveryHash][payloadHash], 'Message already seen!');
        messageSeen[deliveryHash][payloadHash] = true;

        ICrossSyncGateway(crossSyncGatewayAddress).handleReceive(payload);
    }


    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }

}