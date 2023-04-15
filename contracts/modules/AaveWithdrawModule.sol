// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "interfaces/ISafe.sol";
import {DataTypes, IAaveV3Pool} from "interfaces/aave/IAaveV3Pool.sol";
import "interfaces/aave/IAToken.sol";
import "interfaces/push/INotification.sol";

import {BaseModule} from "../BaseModule.sol";

contract AaveWithdrawModule is BaseModule {
    ////////////////////////////////////////////////////////////////////////////
    // INMUTABLE VARIABLES
    ////////////////////////////////////////////////////////////////////////////
    ISafe public immutable safe;

    ////////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ////////////////////////////////////////////////////////////////////////////

    IAaveV3Pool AAVE_POOL =
        IAaveV3Pool(0x7b5C526B7F8dfdff278b4a3e045083FBA4028790);

    ////////////////////////////////////////////////////////////////////////////
    // ERRORS
    ////////////////////////////////////////////////////////////////////////////

    error CollateralNotSupported(
        address collateral,
        address signer,
        uint256 timestamp
    );

    ////////////////////////////////////////////////////////////////////////////
    // EVENTS
    ////////////////////////////////////////////////////////////////////////////

    event EmergencyWithdraw(
        address asset,
        uint256 amount,
        address signer,
        uint256 timestamp
    );

    constructor(ISafe _safe) {
        safe = ISafe(_safe);
    }

    /// @notice signers can call withdraw as a 1/n signers. Used in emergencies
    /// @param collateral address of the collateral that the safe owners had deposit into AaveV3
    function aaveV3Withdraw(address collateral) external isSigner(safe) {
        if (!safe.isModuleEnabled(address(this))) revert ModuleMisconfigured();

        DataTypes.ReserveData memory reserveData = AAVE_POOL.getReserveData(
            collateral
        );

        address aTokenAddress = reserveData.aTokenAddress;
        if (aTokenAddress == address(0))
            revert CollateralNotSupported(
                collateral,
                msg.sender,
                block.timestamp
            );

        uint256 collateralBal = IAToken(aTokenAddress).balanceOf(address(safe));
        if (collateralBal > 0) {
            _checkTransactionAndExecute(
                safe,
                address(AAVE_POOL),
                abi.encodeCall(
                    IAaveV3Pool.withdraw,
                    (collateral, type(uint256).max, address(safe))
                )
            );
            emit EmergencyWithdraw(
                collateral,
                collateralBal,
                msg.sender,
                block.timestamp
            );
            _sendPushNotification(aTokenAddress);
        }
    }

    ////////////////////////////////////////////////////////////////////////////
    // INTERNAL
    ////////////////////////////////////////////////////////////////////////////

    /// @dev internal method to facilitate push notification to our channel
    /// @param _aTokenAddress address of the aToken which we withdraw from
    function _sendPushNotification(address _aTokenAddress) internal {
        bytes memory message = bytes(
            string(
                abi.encodePacked(
                    "0",
                    "+",
                    "3",
                    "+",
                    "Emergency Aave Withdrawal",
                    "+",
                    "Withdraw from aToken ",
                    addressToString(_aTokenAddress)
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
