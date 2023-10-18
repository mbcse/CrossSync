// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
pragma abicoder v2;


import './interfaces/IMessagingImplBase.sol';
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";


contract ChainlinkCCIPImpl is IMessagingImplBase {
    IRouterClient public chainlinkCcipRouter;

    mapping(uint256 => uint64) public chainlinkCcipChainSelector;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _crossSyncGatewayAddress, address _nativeCurrencyWrappedAddress, address _nativeCurrencyAddress, address _owner, address _chainlinkRouterAddress) public initializer {
        IMessagingImplBase_init(_crossSyncGatewayAddress, _nativeCurrencyWrappedAddress, _nativeCurrencyAddress, _owner);
        chainlinkCcipRouter = IRouterClient(_chainlinkRouterAddress);
    }

    function executeSendMessage(ICrossSyncMessagingData calldata _data) override public payable nonReentrant returns(bytes memory){
        require(_msgSender() == crossSyncGatewayAddress, 'Only CrossSyncGateway can call this function');
        require(msg.value > 0, 'Gas payment is required');
        bytes memory payload = abi.encode(_data);
        Client.EVM2AnyMessage memory evm2AnyMessage = _buildCCIPMessage(
            _data.destinationGatewayAddress,
            payload,
            address(0)
        );

        bytes32 messageId = chainlinkCcipRouter.ccipSend{value: msg.value}(
            chainlinkCcipChainSelector[_data.destinationChainId],
            evm2AnyMessage
        );

    }


    function _buildCCIPMessage(
        address _receiver,
        bytes memory _payload,
        address _feeTokenAddress
    ) internal pure returns (Client.EVM2AnyMessage memory) {
        // Create an EVM2AnyMessage struct in memory with necessary information for sending a cross-chain message
        return
            Client.EVM2AnyMessage({
                receiver: abi.encode(_receiver), // ABI-encoded receiver address
                data: _payload, // ABI-encoded string
                tokenAmounts: new Client.EVMTokenAmount[](0), // Empty array aas no tokens are transferred
                extraArgs: Client._argsToBytes(
                    // Additional arguments, setting gas limit and non-strict sequencing mode
                    Client.EVMExtraArgsV1({gasLimit: 200_000, strict: false})
                ),
                // Set the feeToken to a feeTokenAddress, indicating specific asset will be used for fees
                feeToken: _feeTokenAddress
            });
    }


    function setChainlinkCcipRouter(IRouterClient _router) public onlySuperAdmin{
        chainlinkCcipRouter = _router;
    }

    // Setter function for updating values in chainlinkCcipChainSelector mapping
    function setChainlinkCcipChainSelector(uint256 _chainId, uint64 _chainSelector) public onlySuperAdmin{
        chainlinkCcipChainSelector[_chainId] = _chainSelector;
    }

}