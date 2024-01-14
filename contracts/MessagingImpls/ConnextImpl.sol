// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
pragma abicoder v2;


import './interfaces/IMessagingImplBase.sol';
import {IConnext} from '@connext/interfaces/core/IConnext.sol';
import '../interfaces/ICrossSyncGateway.sol';

contract ConnextImpl is IMessagingImplBase {

   IConnext public connext;

   mapping(uint256 => uint32) public connextDestDomain;
   mapping(uint32 => uint256) public connextDestDomainToChainId;
   mapping(uint256 => address) public connextChainImplAddress;

   mapping(bytes32 => mapping(bytes32 =>bool)) public messageSeen;


    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _crossSyncGatewayAddress, address _nativeCurrencyWrappedAddress, address _nativeCurrencyAddress, address _owner, address _connextGatewayAddress) public initializer {
        IMessagingImplBase_init(_crossSyncGatewayAddress, _nativeCurrencyWrappedAddress, _nativeCurrencyAddress, _owner);
        connext = IConnext(_connextGatewayAddress);
    }


    function executeSendMessage(ICrossSyncMessagingData calldata _data, uint256 _gasLimit) override public payable nonReentrant returns(bytes memory){
        require(_msgSender() == crossSyncGatewayAddress, 'Only CrossSyncGateway can call this function');
        require(connextDestDomain[_data.destinationChainId] != 0, 'Connext Not available for this chain');
        require(msg.value > 0, 'Gas payment is required');
        bytes memory payload = abi.encode(_data);
        connext.xcall{value: msg.value}(
            connextDestDomain[_data.destinationChainId], 
            connextChainImplAddress[_data.destinationChainId],
            address(0),    
            _msgSender(),
            0,            
            300,          
            payload           
        );
    }

    function setConnextGateWayAddress(IConnext _connext) public onlySuperAdmin{
        connext = _connext;
    }

    function setConnextDestChainDomain(uint256 _chainId, uint32 _chainDomain) public onlySuperAdmin{
        connextDestDomain[_chainId] = _chainDomain;
        connextDestDomainToChainId[_chainDomain] = _chainId;
    }

    // Connext Receiver
    function xReceive(
        bytes32 _transferId,
        uint256 _amount,
        address _asset,
        address _originSender,
        uint32 _origin,
        bytes calldata _callData
    ) public nonReentrant returns (bytes memory) {
        require(msg.sender == address(connext), 'ConnextImpl: Only Connext can call this function');
        require(_originSender == connextChainImplAddress[connextDestDomainToChainId[_origin]], 'ConnextImpl: Origin domain is not registered');

        bytes32 payloadHash = keccak256(_callData);
        require(!messageSeen[_transferId][payloadHash], ' Message already seen!');
        messageSeen[_transferId][payloadHash] = true;

        ICrossSyncGateway(crossSyncGatewayAddress).handleReceive(_callData);
    }  

    function getFee(ICrossSyncMessagingData calldata _data, uint256 _gasLimit) override public view returns(uint256){
        revert('Not Supported');
    }
}