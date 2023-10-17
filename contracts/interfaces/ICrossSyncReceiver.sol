// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
pragma abicoder v2;


import "@openzeppelin/contracts/interfaces/IERC165.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";

//Hyperlane Recieve interface
interface IMessageRecipient {
    /**
     * @notice Handle an interchain message
     * @param _origin Domain ID of the chain from which the message came
     * @param _sender Address of the message sender on the origin chain as bytes32
     * @param _body Raw bytes content of message body
     */
    function handle(
        uint32 _origin,
        bytes32 _sender,
        bytes calldata _body
    ) external;
}

//Chainlink CCIP Interface
interface IAny2EVMMessageReceiver {
  /// @notice Called by the Router to deliver a message.
  /// If this reverts, any token transfers also revert. The message
  /// will move to a FAILED state and become available for manual execution.
  /// @param message CCIP Message
  /// @dev Note ensure you check the msg.sender is the OffRampRouter
  function ccipReceive(Client.Any2EVMMessage calldata message) external;
}

abstract contract ICrossSyncReceiver is IMessageRecipient {

    // Connext Receiver
    function xReceive(
        bytes32 _transferId,
        uint256 _amount,
        address _asset,
        address _originSender,
        uint32 _origin,
        bytes calldata _callData
    ) public returns (bytes memory) {
        _handleReceive(_callData);
    }  

    //Hyperlane Reciever
    function handle(
            uint32 _origin,
            bytes32 _sender,
            bytes calldata _body
    ) public {
        _handleReceive(_body);
    }


    //Axelar Receiver
    function execute(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) external {
        // bytes32 payloadHash = keccak256(payload);

        // if (!gateway.validateContractCall(commandId, sourceChain, sourceAddress, payloadHash))
        //     revert NotApprovedByGateway();

        _handleReceive(payload);
    }

    // WormHole Receiver 
    function receiveWormholeMessages(
        bytes calldata payload,
        bytes[] memory additionalVaas,
        bytes32 sourceAddress,
        uint16 sourceChain,
        bytes32 deliveryHash
    ) external payable {
        _handleReceive(payload);
    }


  // Chainlink CCIP Receiver
  function ccipReceive(Client.Any2EVMMessage calldata message) external {
    _handleReceive(message.data);
  }

  // Interface support for CCIP chainlink Receive
  function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
    return interfaceId == type(IAny2EVMMessageReceiver).interfaceId || interfaceId == type(IERC165).interfaceId;
  }

    function _handleReceive(
        bytes calldata _payload
    ) internal virtual;  

}