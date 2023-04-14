// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "interfaces/gnosis/IGnosisSafe.sol";

import {BaseModule} from "../BaseModule.sol";

contract ApprovalModule is BaseModule {
    ////////////////////////////////////////////////////////////////////////////
    // EVENTS
    ////////////////////////////////////////////////////////////////////////////
    event ZeroApprove(address safe, address token, address spender, uint256 timestamp);

    function approve(IGnosisSafe safe, address token, address spender) internal {
        uint256 allowanceAmount = IERC20(token).allowance(address(safe), spender);
        if (allowanceAmount > 0) {
            _checkTransactionAndExecute(safe, token, abi.encodeCall(IERC20.approve, (spender, 0)));
            emit ZeroApprove(address(safe), token, spender, block.timestamp);
        }
    }
}
