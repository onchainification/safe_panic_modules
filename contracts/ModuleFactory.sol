// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./modules/RevokeModule.sol";
import "./modules/AaveWithdrawModule.sol";

import "interfaces/ISafe.sol";

contract ModuleFactory {
    ////////////////////////////////////////////////////////////////////////////
    // ERRORS
    ////////////////////////////////////////////////////////////////////////////

    error NoSupportedModuleType(ModuleType moduleType, address deployer);

    error NotSigner(address safe, address executor);

    ////////////////////////////////////////////////////////////////////////////
    // EVENTS
    ////////////////////////////////////////////////////////////////////////////

    event ModuleDeployed(address module, ModuleType moduleType, address deployer, uint256 timestamp);

    ////////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ////////////////////////////////////////////////////////////////////////////

    enum ModuleType {
        REVOKE_MODULE,
        AAVE_WITHDRAW
    }

    function createModuleAndEnable(ISafe safe, ModuleType modType) external {
        if (modType == ModuleType.REVOKE_MODULE) {
            RevokeModule module = new RevokeModule(safe);
            emit ModuleDeployed(address(module), ModuleType.REVOKE_MODULE, msg.sender, block.timestamp);
        } else if (modType == ModuleType.AAVE_WITHDRAW) {
            AaveWithdrawModule module = new AaveWithdrawModule(safe);
            emit ModuleDeployed(address(module), ModuleType.AAVE_WITHDRAW, msg.sender, block.timestamp);
        } else {
            revert NoSupportedModuleType(modType, msg.sender);
        }
    }
}
