// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "interfaces/gnosis/IGnosisSafe.sol";

import {BaseModule} from "../BaseModule.sol";

contract ApprovalModule is BaseModule {
    function approve(IGnosisSafe safe, address token, address spender) internal {
        _checkTransactionAndExecute(safe, token, abi.encodeCall(IERC20.approve, (spender, 0)));
    }
}
