// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
pragma abicoder v2;


import './interfaces/IMessagingImplBase.sol';
import {IRouterClient} from '@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol';
import {Client} from '@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol';
import '@openzeppelin/contracts/interfaces/IERC165.sol';
import '../interfaces/ICrossSyncGateway.sol';

//Chainlink CCIP Interface
interface IAny2EVMMessageReceiver {
  /// @notice Called by the Router to deliver a message.
  /// If this reverts, any token transfers also revert. The message
  /// will move to a FAILED state and become available for manual execution.
  /// @param message CCIP Message
  /// @dev Note ensure you check the msg.sender is the OffRampRouter
  function ccipReceive(Client.Any2EVMMessage calldata message) external;
}

contract ChainlinkCCIPImpl is IMessagingImplBase {
    IRouterClient public chainlinkCcipRouter;

    mapping(uint256 => uint64) public chainlinkCcipChainSelector;
    mapping(uint64 => uint256) public chainlinkCcipChainSelectorToChainId;
    mapping(uint256 => address) public chainlinkCcipChainImplAddress;

    mapping(bytes32 => mapping(bytes32 =>bool)) public messageSeen;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _crossSyncGatewayAddress, address _nativeCurrencyWrappedAddress, address _nativeCurrencyAddress, address _owner, address _chainlinkRouterAddress) public initializer {
        IMessagingImplBase_init(_crossSyncGatewayAddress, _nativeCurrencyWrappedAddress, _nativeCurrencyAddress, _owner);
        chainlinkCcipRouter = IRouterClient(_chainlinkRouterAddress);
    }

    function executeSendMessage(ICrossSyncMessagingData calldata _data, uint256 _gasLimit) override public payable nonReentrant returns(bytes memory){
        require(_msgSender() == crossSyncGatewayAddress, 'Only CrossSyncGateway can call this function');
        require(chainlinkCcipChainSelector[_data.destinationChainId] != 0, 'Chainlink CCIP Not available for this chain');
        require(msg.value > 0, 'Gas payment is required');
        bytes memory payload = abi.encode(_data);
        Client.EVM2AnyMessage memory evm2AnyMessage = _buildCCIPMessage(
            chainlinkCcipChainImplAddress[_data.destinationChainId],
            payload,
            address(0),
            _gasLimit
        );

        bytes32 messageId = chainlinkCcipRouter.ccipSend{value: msg.value}(
            chainlinkCcipChainSelector[_data.destinationChainId],
            evm2AnyMessage
        );

    }


    function _buildCCIPMessage(
        address _receiver,
        bytes memory _payload,
        address _feeTokenAddress,
        uint256 _gasLimit
    ) internal view returns (Client.EVM2AnyMessage memory) {
        // Create an EVM2AnyMessage struct in memory with necessary information for sending a cross-chain message
        
        uint256 gasLimit = _gasLimit == 0 ? defaultGasLimit : _gasLimit;
        
        return
            Client.EVM2AnyMessage({
                receiver: abi.encode(_receiver), // ABI-encoded receiver address
                data: _payload, // ABI-encoded string
                tokenAmounts: new Client.EVMTokenAmount[](0), // Empty array aas no tokens are transferred
                extraArgs: Client._argsToBytes(
                    // Additional arguments, setting gas limit and non-strict sequencing mode
                    Client.EVMExtraArgsV1({gasLimit: gasLimit, strict: false})
                ),
                // Set the feeToken to a feeTokenAddress, indicating specific asset will be used for fees
                feeToken: _feeTokenAddress
            });
    }


    function setChainlinkCcipRouter(IRouterClient _router) public onlySuperAdmin{
        chainlinkCcipRouter = _router;
    }

    // Setter function for updating values in chainlinkCcipChainSelector mapping
    function setChainlinkCcipChainSelector(uint256 _chainId, uint64 _chainSelector) public onlySuperAdmin {
        chainlinkCcipChainSelector[_chainId] = _chainSelector;
        chainlinkCcipChainSelectorToChainId[_chainSelector] = _chainId;
    }

    function setChainlinkCcipChainImplAddress(uint256 _chainId, address _implAddress) public onlySuperAdmin {
        chainlinkCcipChainImplAddress[_chainId] = _implAddress;
    }

    // Chainlink CCIP Receiver
    function ccipReceive(Client.Any2EVMMessage calldata message) external nonReentrant{
        require(_msgSender() == address(chainlinkCcipRouter), 'Only ChainlinkCCIPRouter can call this function');
        
        bytes32 payloadHash = keccak256(message.data);
        require(!messageSeen[message.messageId][payloadHash], 'Message Already Seen!');
        messageSeen[message.messageId][payloadHash] = true;
        
        address sender = abi.decode(message.sender, (address));
        require(sender == chainlinkCcipChainImplAddress[chainlinkCcipChainSelectorToChainId[message.sourceChainSelector]], 'Only ChainlinkCCIPImpl can call this function');
        ICrossSyncGateway(crossSyncGatewayAddress).handleReceive(message.data);
    }

    // Interface support for CCIP chainlink Receive
    function supportsInterface(bytes4 interfaceId) public pure override returns (bool) {
        return interfaceId == type(IAny2EVMMessageReceiver).interfaceId || interfaceId == type(IERC165).interfaceId;
    }

    function getFee(ICrossSyncMessagingData calldata _data, uint256 _gasLimit) override public view returns(uint256){
        require(chainlinkCcipChainSelector[_data.destinationChainId] != 0, 'Chainlink CCIP Not available for this chain');
        bytes memory payload = abi.encode(_data);
        Client.EVM2AnyMessage memory evm2AnyMessage = _buildCCIPMessage(
            chainlinkCcipChainImplAddress[_data.destinationChainId],
            payload,
            address(0),
            _gasLimit
        );
        uint256 fees = chainlinkCcipRouter.getFee(chainlinkCcipChainSelector[_data.destinationChainId], evm2AnyMessage);
        return fees;
    }

}