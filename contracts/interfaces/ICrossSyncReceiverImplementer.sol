// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
pragma abicoder v2;

interface ICrossSyncReceiverImplementer {

    function receiveMessage(
        uint256 _sourceChainId,
        address _sourceAddress,
        bytes calldata _payload
    ) external payable ;    
  
        
}