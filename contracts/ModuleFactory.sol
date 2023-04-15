// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./modules/RevokeModule.sol";
import "./modules/AaveWithdrawModule.sol";
import "./modules/UniswapWithdrawModule.sol";

import "interfaces/ISafe.sol";

/// @title   ModuleFactory
/// @dev  Allows deploying easily a module targeting a specific safe environment
contract ModuleFactory {
    ////////////////////////////////////////////////////////////////////////////
    // ERRORS
    ////////////////////////////////////////////////////////////////////////////

    error NoSupportedModuleType(ModuleType moduleType, address deployer);

    error NotSigner(address safe, address executor);

    ////////////////////////////////////////////////////////////////////////////
    // EVENTS
    ////////////////////////////////////////////////////////////////////////////

    event ModuleDeployed(
        address module,
        ModuleType moduleType,
        address deployer,
        uint256 timestamp
    );

    ////////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ////////////////////////////////////////////////////////////////////////////

    enum ModuleType {
        REVOKE_MODULE,
        AAVE_WITHDRAW,
        UNISWAP_WITHDRAW
    }

    /// @dev Given a specific enum value will deploy different module
    /// @notice Deploys a new module
    /// @param safe target safe contract which the module is targeting
    /// @param modType identifier of the module to be deployed
    function createModuleAndEnable(ISafe safe, ModuleType modType) external {
        if (modType == ModuleType.REVOKE_MODULE) {
            RevokeModule module = new RevokeModule(safe);
            emit ModuleDeployed(
                address(module),
                ModuleType.REVOKE_MODULE,
                msg.sender,
                block.timestamp
            );
        } else if (modType == ModuleType.AAVE_WITHDRAW) {
            AaveWithdrawModule module = new AaveWithdrawModule(safe);
            emit ModuleDeployed(
                address(module),
                ModuleType.AAVE_WITHDRAW,
                msg.sender,
                block.timestamp
            );
        } else if (modType == ModuleType.UNISWAP_WITHDRAW) {
            UniswapWithdrawModule module = new UniswapWithdrawModule(safe);
            emit ModuleDeployed(
                address(module),
                ModuleType.UNISWAP_WITHDRAW,
                msg.sender,
                block.timestamp
            );
        } else {
            revert NoSupportedModuleType(modType, msg.sender);
        }
    }
}
