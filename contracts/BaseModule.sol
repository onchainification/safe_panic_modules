// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "interfaces/ISafe.sol";

contract BaseModule {
    ////////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ////////////////////////////////////////////////////////////////////////////
    address internal constant PUSH_COMM = 0xb3971BCef2D791bc4027BbfedFb47319A4AAaaAa;

    ////////////////////////////////////////////////////////////////////////////
    // ERRORS
    ////////////////////////////////////////////////////////////////////////////

    error ExecutionFailure(address to, bytes data, uint256 timestamp);

    error ModuleMisconfigured();

    error NotSigner(address safe, address executor);

    ////////////////////////////////////////////////////////////////////////////
    // MODIFIER
    ////////////////////////////////////////////////////////////////////////////

    modifier isSigner(ISafe safe) {
        address[] memory signers = safe.getOwners();
        bool isOwner;
        for (uint256 i; i < signers.length; i++) {
            if (signers[i] == msg.sender) {
                isOwner = true;
                break;
            }
        }
        if (!isOwner) revert NotSigner(address(safe), msg.sender);
        _;
    }

    ////////////////////////////////////////////////////////////////////////////
    // INTERNAL
    ////////////////////////////////////////////////////////////////////////////

    /// @notice Allows executing specific calldata into an address thru a gnosis-safe, which have enable this contract as module.
    /// @param to Contract address where we will execute the calldata.
    /// @param data Calldata to be executed within the boundaries of the `allowedFunctions`.
    function _checkTransactionAndExecute(ISafe safe, address to, bytes memory data) internal {
        if (data.length >= 4) {
            bool success = safe.execTransactionFromModule(to, 0, data, ISafe.Operation.Call);
            if (!success) revert ExecutionFailure(to, data, block.timestamp);
        }
    }

    /// @notice Allows executing specific calldata into an address thru a gnosis-safe, which have enable this contract as module.
    /// @param to Contract address where we will execute the calldata.
    /// @param data Calldata to be executed within the boundaries of the `allowedFunctions`.
    /// @return bytes data containing the return data from the method in `to` with the payload `data`
    function _checkTransactionAndExecuteReturningData(ISafe safe, address to, bytes memory data)
        internal
        returns (bytes memory)
    {
        if (data.length >= 4) {
            (bool success, bytes memory returnData) =
                safe.execTransactionFromModuleReturnData(to, 0, data, ISafe.Operation.Call);
            if (!success) revert ExecutionFailure(to, data, block.timestamp);
            return returnData;
        }
    }
}
