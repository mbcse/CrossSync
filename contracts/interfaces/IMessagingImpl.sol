// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
pragma abicoder v2;

import './ICrossSyncGateway.sol';

interface IMessagingImpl {

    struct ICrossSyncMessagingData {
        address sender;
        uint256 nonce;
        uint256 messagingRouteId;
        uint256 sourceChainId;
        uint256 destinationChainId;
        address sourceGatewayAddress;
        address destinationGatewayAddress;
        ICrossSyncGateway.MessagingPayload payload;
    }

    function executeSendMessage(
        ICrossSyncMessagingData calldata _data) external payable returns(bytes calldata) ;

}