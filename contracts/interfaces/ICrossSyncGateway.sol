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
        bytes calldata _routeData
    ) external payable;
    
       
}