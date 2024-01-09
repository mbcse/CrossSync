// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
pragma abicoder v2;


interface ICrossSyncReceiver {

    function handleReceive(
        bytes calldata _payload
    ) external;  

}