// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
pragma abicoder v2;


import './interfaces/IMessagingImplBase.sol';
import {IConnext} from "@connext/interfaces/core/IConnext.sol";

contract ConnextImpl is IMessagingImplBase {

   IConnext public connext;

   mapping(uint256 => uint32) public connextDestDomain;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _crossSyncGatewayAddress, address _nativeCurrencyWrappedAddress, address _nativeCurrencyAddress, address _owner, address _connextGatewayAddress) public initializer {
        IMessagingImplBase_init(_crossSyncGatewayAddress, _nativeCurrencyWrappedAddress, _nativeCurrencyAddress, _owner);
        connext = IConnext(_connextGatewayAddress);
    }


    function executeSendMessage(ICrossSyncMessagingData calldata _data) override public payable nonReentrant returns(bytes memory){
        require(_msgSender() == crossSyncGatewayAddress, 'Only CrossSyncGateway can call this function');
        require(msg.value > 0, 'Gas payment is required');
        bytes memory payload = abi.encode(_data);
        connext.xcall{value: msg.value}(
            connextDestDomain[_data.destinationChainId], 
            _data.destinationGatewayAddress,
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
    }
}