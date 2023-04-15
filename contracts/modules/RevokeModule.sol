// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "interfaces/ISafe.sol";
import "interfaces/push/INotification.sol";

import {BaseModule} from "../BaseModule.sol";

contract RevokeModule is BaseModule {
    ////////////////////////////////////////////////////////////////////////////
    // INMUTABLE VARIABLES
    ////////////////////////////////////////////////////////////////////////////
    ISafe public immutable safe;

    ////////////////////////////////////////////////////////////////////////////
    // EVENTS
    ////////////////////////////////////////////////////////////////////////////

    event Revoked(
        address safe,
        address token,
        address spender,
        address signer,
        uint256 timestamp
    );

    constructor(ISafe _safe) {
        safe = ISafe(_safe);
    }

    /// @notice sets allowance to zero for specific token and spender
    /// @param token token address which we will trigger the revoking
    /// @param spender address which allowance is going to be set to zero
    function revoke(address token, address spender) external isSigner(safe) {
        if (!safe.isModuleEnabled(address(this))) revert ModuleMisconfigured();

        uint256 allowanceAmount = IERC20(token).allowance(
            address(safe),
            spender
        );
        if (allowanceAmount > 0) {
            _checkTransactionAndExecute(
                safe,
                token,
                abi.encodeCall(IERC20.approve, (spender, 0))
            );
            emit Revoked(
                address(safe),
                token,
                spender,
                msg.sender,
                block.timestamp
            );
        }
    }

    ////////////////////////////////////////////////////////////////////////////
    // INTERNAL
    ////////////////////////////////////////////////////////////////////////////

    /// @dev internal method to facilitate push notification to our channel
    /// @param token address of the token we trigger the revoke against
    /// @param spender address against we set the allowance to zero
    function _sendPushNotification(address token, address spender) internal {
        bytes memory message = bytes(
            string(
                abi.encodePacked(
                    "0",
                    "+",
                    "3",
                    "+",
                    "Emergency Token Revoke",
                    "+",
                    "Withdraw from token ",
                    addressToString(token),
                    "revoke allowance from spender ",
                    addressToString(spender)
                )
            )
        );
        _checkTransactionAndExecute(
            safe,
            PUSH_COMM,
            abi.encodeCall(
                INotification.sendNotification,
                (address(safe), address(safe), message)
            )
        );
    }
}
