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

    struct ICrossSyncMultiHopMessagingData {
        address sender;
        uint256 nonce;
        uint256[] messagingRouteIds;
        uint256 sourceChainId;
        uint256[] destinationChainIds;
        address sourceGatewayAddress;
        address destinationGatewayAddress;
        ICrossSyncGateway.MessagingPayload payload;
    }

    function executeSendMessage(
        ICrossSyncMessagingData calldata _data, uint256 _gasLimit) external payable returns(bytes calldata) ;

    // function executeMultiHopSendMessage(
    //     ICrossSyncMultiHopMessagingData calldata _data, uint256 _gasLimit) external payable returns(bytes calldata) ;    

    function getFee(ICrossSyncMessagingData calldata _data, uint256 _gasLimit) external view returns(uint256);    

}