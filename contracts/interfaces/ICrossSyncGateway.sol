// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
pragma abicoder v2;

import './ICrossSyncReceiver.sol';

interface ICrossSyncGateway is ICrossSyncReceiver {

    struct MessagingPayload{
        address to;
        bytes data;
    }

    function sendMessage(
        uint256 _destinationChainId,
        uint256 _routeId,
        MessagingPayload calldata _payload,
        uint256 gasLimit,
        bytes calldata _routeData
    ) external payable;

    // function sendMessageUsingManualMultiHop(
    //     uint256[] memory _destinationChainIds,
    //     uint256[] memory _routeIds,
    //     MessagingPayload calldata _payload,
    //     uint256 gasLimit,
    //     bytes[] calldata _routeData
    // ) external payable;

    function getFee(
        uint256 _destinationChainId,
        uint256 _routeId,
        MessagingPayload calldata _payload,
        uint256 _gasLimit
    ) external view returns(uint256);
    
       
}