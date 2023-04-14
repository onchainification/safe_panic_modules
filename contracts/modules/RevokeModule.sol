// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "interfaces/gnosis/IGnosisSafe.sol";

import {BaseModule} from "../BaseModule.sol";

contract RevokeModule is BaseModule {
    ////////////////////////////////////////////////////////////////////////////
    // ERRORS
    ////////////////////////////////////////////////////////////////////////////

    error ModuleMisconfigured();

    error NotSigner(address safe, address executor);

    ////////////////////////////////////////////////////////////////////////////
    // EVENTS
    ////////////////////////////////////////////////////////////////////////////

    event Revoked(address safe, address token, address spender, uint256 timestamp);

    ////////////////////////////////////////////////////////////////////////////
    // MODIFIER
    ////////////////////////////////////////////////////////////////////////////

    modifier isSigner(IGnosisSafe safe) {
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

    function revoke(IGnosisSafe safe, address token, address spender) external isSigner(safe) {
        if (!safe.isModuleEnabled(address(this))) revert ModuleMisconfigured();

        uint256 allowanceAmount = IERC20(token).allowance(address(safe), spender);
        if (allowanceAmount > 0) {
            _checkTransactionAndExecute(safe, token, abi.encodeCall(IERC20.approve, (spender, 0)));
            emit Revoked(address(safe), token, spender, block.timestamp);
        }
    }
}
