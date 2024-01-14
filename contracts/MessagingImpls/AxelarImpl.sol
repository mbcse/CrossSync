// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
pragma abicoder v2;


import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';
import '@openzeppelin/contracts/utils/Strings.sol';

import {AxelarExecutable} from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';

import './interfaces/IMessagingImplBase.sol';
import '../interfaces/ICrossSyncGateway.sol';


contract AxelarImpl is IMessagingImplBase {

    IAxelarGateway public gateway;
    IAxelarGasService public  gasService;

    mapping(uint256 => string) public axelarChainName;
    mapping(string => uint256) public axelarChainNameToChainId;
    mapping(uint256 => address) public axelarChainImplAddress;
    mapping(bytes32 => mapping(bytes32 => bool)) private messageSeen;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _crossSyncGatewayAddress, address _nativeCurrencyWrappedAddress, address _nativeCurrencyAddress, address _owner, address _axelarGatewayAddress, address _axelarGasServiceAddress) public initializer {
        IMessagingImplBase_init(_crossSyncGatewayAddress, _nativeCurrencyWrappedAddress, _nativeCurrencyAddress, _owner);
        gateway = IAxelarGateway(_axelarGatewayAddress);
        gasService = IAxelarGasService(_axelarGasServiceAddress);

    }

    function executeSendMessage(ICrossSyncMessagingData calldata _data, uint256 _gasLimit) override public payable nonReentrant returns(bytes memory){
        require(_msgSender() == crossSyncGatewayAddress, 'Only CrossSyncGateway can call this function');
        require(msg.value > 0, 'Gas payment is required');
        bytes memory payload = abi.encode(_data);
        gasService.payNativeGasForContractCall{ value: msg.value }(
            address(this),
            axelarChainName[_data.destinationChainId],
             Strings.toHexString(_data.destinationGatewayAddress),
            payload,
            _msgSender()
        );
        gateway.callContract(axelarChainName[_data.destinationChainId], Strings.toHexString(axelarChainImplAddress[_data.destinationChainId]), payload);
    }

    function setAxelarChainName(uint256 _chainId, string memory _chainName) public onlySuperAdmin {
        axelarChainName[_chainId] = _chainName;
        axelarChainNameToChainId[_chainName] = _chainId;
    }

    // Setter function for IAxelarGateway
    function setAxelarGateway(IAxelarGateway _gateway) public onlySuperAdmin {
        gateway = _gateway;
    }

    // Setter function for IAxelarGasService
    function setAxelarGasService(IAxelarGasService _gasService) public onlySuperAdmin {
        gasService = _gasService;
    }

    function setAxelarChainImplAddress(uint256 _chainId, address _implAddress) public onlySuperAdmin {
        axelarChainImplAddress[_chainId] = _implAddress;
    }

    //Axelar Receiver
    function execute(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) external nonReentrant{
        
        require(_msgSender()== address(gateway), 'Only Axelar Gateway can call this function');
        // Check if Message came from CrossSync's One of the Impl Addresses
        require(stringToAddress(sourceAddress) == axelarChainImplAddress[axelarChainNameToChainId[sourceChain]], 'Source address is not a crossSync Impl Address');
        
        bytes32 payloadHash = keccak256(payload);
        if (!gateway.validateContractCall(commandId, sourceChain, sourceAddress, payloadHash))
            revert('Not Approved By Axelar Gateway');

        require(!messageSeen[commandId][payloadHash], 'Message already seen');    
        messageSeen[commandId][payloadHash] = true;

        ICrossSyncGateway(crossSyncGatewayAddress).handleReceive(payload);
    }


    function stringToAddress(string memory addressString) internal returns (address) {
        address myAddress = address(bytes20(bytes(addressString)));
        return myAddress;
    }
    
    function getFee(ICrossSyncMessagingData calldata _data, uint256 _gasLimit) override public view returns(uint256){
        revert('Not Supported');
    }

}