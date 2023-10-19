// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
pragma abicoder v2;

import './interfaces/IMessagingImplBase.sol';
 
interface HyperlaneMailBox {
    function dispatch(
        uint32 _destination,
        bytes32 _recipient,
        bytes calldata _body
    ) external returns (bytes32);
}


interface IInterchainGasPaymaster {
    /**
     * @notice Emitted when a payment is made for a message's gas costs.
     * @param messageId The ID of the message to pay for.
     * @param gasAmount The amount of destination gas paid for.
     * @param payment The amount of native tokens paid.
     */
    event GasPayment(
        bytes32 indexed messageId,
        uint256 gasAmount,
        uint256 payment
    );

    /**
     * @notice Deposits msg.value as a payment for the relaying of a message
     * to its destination chain.
     * @dev Overpayment will result in a refund of native tokens to the _refundAddress.
     * Callers should be aware that this may present reentrancy issues.
     * @param _messageId The ID of the message to pay for.
     * @param _destinationDomain The domain of the message's destination chain.
     * @param _gasAmount The amount of destination gas to pay for.
     * @param _refundAddress The address to refund any overpayment to.
     */
    function payForGas(
        bytes32 _messageId,
        uint32 _destinationDomain,
        uint256 _gasAmount,
        address _refundAddress
    ) external payable;

    /**
     * @notice Quotes the amount of native tokens to pay for interchain gas.
     * @param _destinationDomain The domain of the message's destination chain.
     * @param _gasAmount The amount of destination gas to pay for.
     * @return The amount of native tokens required to pay for interchain gas.
     */
    function quoteGasPayment(uint32 _destinationDomain, uint256 _gasAmount)
        external
        view
        returns (uint256);
}

contract HyperlaneImpl is IMessagingImplBase {
    HyperlaneMailBox public hyperlaneMailBox;
    IInterchainGasPaymaster public  hyperlaneInterchainGasPaymaster;
    uint256 GAS_LIMIT;

    mapping(uint256 => uint32) public hyperlaneChainDomain;


    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _crossSyncGatewayAddress, address _nativeCurrencyWrappedAddress, address _nativeCurrencyAddress, address _owner, address _hyperlaneMailBoxAddress, address _hyperlaneGasPaymasterAddress) public initializer {
        IMessagingImplBase_init(_crossSyncGatewayAddress, _nativeCurrencyWrappedAddress, _nativeCurrencyAddress, _owner);
        hyperlaneMailBox = HyperlaneMailBox(_hyperlaneMailBoxAddress);
        hyperlaneInterchainGasPaymaster = IInterchainGasPaymaster(_hyperlaneGasPaymasterAddress);
        GAS_LIMIT = 50_000;
    }


    function executeSendMessage(ICrossSyncMessagingData calldata _data) override public payable nonReentrant returns(bytes memory){
        require(_msgSender() == crossSyncGatewayAddress, 'Only CrossSyncGateway can call this function');
        require(msg.value > 0, 'Gas payment is required');
        bytes memory payload = abi.encode(_data);
       
        bytes32 messageId = hyperlaneMailBox.dispatch(hyperlaneChainDomain[_data.destinationChainId], addressToBytes32(_data.destinationGatewayAddress), payload);

        hyperlaneInterchainGasPaymaster.payForGas{ value: msg.value }(
            // The ID of the message
            messageId,
            // Destination domain
            hyperlaneChainDomain[_data.destinationChainId],
            GAS_LIMIT,
            // Refund the msg.sender
            _msgSender()
        );
    }


    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }

        // Setter function for HyperlaneMailBox
    function setHyperlaneMailBox(HyperlaneMailBox _mailBox) public  onlySuperAdmin{
        hyperlaneMailBox = _mailBox;
    }

    // Setter function for IInterchainGasPaymaster
    function setHyperlaneInterchainGasPaymaster(IInterchainGasPaymaster _paymaster) public onlySuperAdmin{
        hyperlaneInterchainGasPaymaster = _paymaster;
    }

    // Setter function for updating values in hyperlaneChainDomain mapping
    function setHyperlaneChainDomain(uint256 _chainId, uint32 _chainDomain) public onlySuperAdmin{
        hyperlaneChainDomain[_chainId] = _chainDomain;
    }

    // Setter function for updating the GAS_LIMIT
    function setHyperlaneGasLimit(uint256 newGasLimit) public onlySuperAdmin{
        GAS_LIMIT = newGasLimit;
    }
    

}