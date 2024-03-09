// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
pragma abicoder v2;


import './interfaces/IMessagingImplBase.sol';
import '../interfaces/ICrossSyncGateway.sol';
import {ITeleporterMessenger, TeleporterMessageInput, TeleporterFeeInfo} from "./interfaces/ITeleporterMessenger.sol";


contract TeleporterImpl is IMessagingImplBase {
    
    ITeleporterMessenger public teleporterMessenger;
    mapping(uint256 => bytes32) public  teleporterDestBlockchainId;
    mapping(bytes32 => uint256) public teleporterDestBlockchainIdToChainId;
    mapping(uint256 => address) public teleporterChainImplAddress;

   mapping(bytes32 => mapping(bytes32 =>bool)) public messageSeen;


    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _crossSyncGatewayAddress, address _nativeCurrencyWrappedAddress, address _nativeCurrencyAddress, address _owner, address _teleporterAddress) public initializer {
        IMessagingImplBase_init(_crossSyncGatewayAddress, _nativeCurrencyWrappedAddress, _nativeCurrencyAddress, _owner);
        teleporterMessenger = ITeleporterMessenger(_teleporterAddress);
    }


    function executeSendMessage(ICrossSyncMessagingData calldata _data, uint256 _gasLimit) override public payable nonReentrant returns(bytes memory){
        require(_msgSender() == crossSyncGatewayAddress, 'Only CrossSyncGateway can call this function');
        require(teleporterDestBlockchainId[_data.destinationChainId] != 0, 'Teleporter Not available for this chain');
        require(msg.value > 0, 'Gas payment is required');
        bytes memory payload = abi.encode(_data);

        uint256 gasLimit = _gasLimit == 0 ? defaultGasLimit : _gasLimit;

        teleporterMessenger.sendCrossChainMessage(
        TeleporterMessageInput({
            destinationBlockchainID: teleporterDestBlockchainId[_data.destinationChainId],
            destinationAddress: teleporterChainImplAddress[_data.destinationChainId],
            feeInfo: TeleporterFeeInfo({
                feeTokenAddress: address(0),
                amount: msg.value
            }),
            requiredGasLimit: gasLimit,
            allowedRelayerAddresses: new address[](0),
            message: payload
        }));
        
    }

    function setTeleporterGateWayAddress(ITeleporterMessenger _messenger) public onlySuperAdmin{
        teleporterMessenger = _messenger;
    }

    function setTeleporterDestBlockchainId(uint256 _chainId, bytes32 _blockchainId) public onlySuperAdmin{
        teleporterDestBlockchainId[_chainId] = _blockchainId;
        teleporterDestBlockchainIdToChainId[_blockchainId] = _chainId;
    }

    function setTeleporterChainImplAddress(uint256 _chainId, address _chainImplAddress) public onlySuperAdmin{
        teleporterChainImplAddress[_chainId] = _chainImplAddress;
    }

    // Teleporter Receiver

    function receiveTeleporterMessage(
        bytes32 originChainID,
        address originSenderAddress,
        bytes calldata message
    ) public nonReentrant returns (bytes memory) {
        require(msg.sender == address(teleporterMessenger), 'TeleporterImpl: Only Teleporter can call this function');
        require(originSenderAddress == teleporterChainImplAddress[teleporterDestBlockchainIdToChainId[originChainID]], 'Teleporter: Origin Blockchain Id is not registered');

        bytes32 payloadHash = keccak256(message);
        require(!messageSeen[originChainID][payloadHash], 'Message already seen!');
        messageSeen[originChainID][payloadHash] = true;

        ICrossSyncGateway(crossSyncGatewayAddress).handleReceive(message);
    }

    function getFee(ICrossSyncMessagingData calldata _data, uint256 _gasLimit) override public view returns(uint256){
        revert('Not Supported');
    }
    
}