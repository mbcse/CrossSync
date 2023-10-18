// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
pragma abicoder v2;


import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';
import "@openzeppelin/contracts/utils/Strings.sol";


import './interfaces/IMessagingImplBase.sol';


contract AxelarImpl is IMessagingImplBase {

    IAxelarGateway public gateway;
    IAxelarGasService public  gasService;

    mapping(uint256 => string) public axelarChainName;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _crossSyncGatewayAddress, address _nativeCurrencyWrappedAddress, address _nativeCurrencyAddress, address _owner, address _axelarGatewayAddress, address _axelarGasServiceAddress) public initializer {
        IMessagingImplBase_init(_crossSyncGatewayAddress, _nativeCurrencyWrappedAddress, _nativeCurrencyAddress, _owner);
        gateway = IAxelarGateway(_axelarGatewayAddress);
        gasService = IAxelarGasService(_axelarGasServiceAddress);

    }

    function executeSendMessage(ICrossSyncMessagingData calldata _data) override public payable nonReentrant returns(bytes memory){
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
        gateway.callContract(axelarChainName[_data.destinationChainId], Strings.toHexString(_data.destinationGatewayAddress), payload);
    }

    function setAxelarChainName(uint256 _chainId, string memory _chainName) public onlySuperAdmin {
        axelarChainName[_chainId] = _chainName;
    }

    // Setter function for IAxelarGateway
    function setAxelarGateway(IAxelarGateway _gateway) public onlySuperAdmin {
        gateway = _gateway;
    }

    // Setter function for IAxelarGasService
    function setAxelarGasService(IAxelarGasService _gasService) public onlySuperAdmin {
        gasService = _gasService;
    }

}