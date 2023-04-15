// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "interfaces/ISafe.sol";

contract BaseModule {
    ////////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ////////////////////////////////////////////////////////////////////////////
    address internal constant PUSH_COMM = 0xb3971BCef2D791bc4027BbfedFb47319A4AAaaAa;

    // https://docs.gelato.network/developer-services/relay/quick-start/erc-2771#3.-re-deploy-your-contract-and-whitelist-gelatorelayerc2771
    address internal GELATO_TRUSTED_FORWARDED = 0xBf175FCC7086b4f9bd59d5EAE8eA67b8f940DE0d;

    ////////////////////////////////////////////////////////////////////////////
    // ERRORS
    ////////////////////////////////////////////////////////////////////////////

    error ExecutionFailure(address to, bytes data, uint256 timestamp);

    error ModuleMisconfigured();

    error NotSigner(address safe, address executor);

    error NotTrustedForwarded(address forwarded);

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

    /// @dev Helper function to convert address to string
    function addressToString(address _address) internal pure returns (string memory) {
        bytes32 _bytes = bytes32(uint256(uint160(_address)));
        bytes memory HEX = "0123456789abcdef";
        bytes memory _string = new bytes(42);
        _string[0] = "0";
        _string[1] = "x";
        for (uint256 i = 0; i < 20; i++) {
            _string[2 + i * 2] = HEX[uint8(_bytes[i + 12] >> 4)];
            _string[3 + i * 2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
        }
        return string(_string);
    }
}
