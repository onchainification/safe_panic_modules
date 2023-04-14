// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "interfaces/gnosis/IGnosisSafe.sol";
import {DataTypes, IAaveV3Pool} from "interfaces/aave/IAaveV3Pool.sol";
import "interfaces/aave/IAToken.sol";

import {BaseModule} from "../BaseModule.sol";

contract AaveWithdrawModule is BaseModule {
    ////////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ////////////////////////////////////////////////////////////////////////////

    IAaveV3Pool AAVE_POOL = IAaveV3Pool(0x7b5C526B7F8dfdff278b4a3e045083FBA4028790);

    ////////////////////////////////////////////////////////////////////////////
    // EVENTS
    ////////////////////////////////////////////////////////////////////////////

    event EmergencyWithdraw(address asset, uint256 amount, address signer, uint256 timestamp);

    function aaveV3Withdraw(IGnosisSafe safe, address collateral) external isSigner(safe) {
        if (!safe.isModuleEnabled(address(this))) revert ModuleMisconfigured();

        DataTypes.ReserveData memory reserveData = AAVE_POOL.getReserveData(collateral);
        uint256 collateralBal = IAToken(reserveData.aTokenAddress).balanceOf(address(safe));
        if (collateralBal > 0) {
            _checkTransactionAndExecute(
                safe,
                address(AAVE_POOL),
                abi.encodeCall(IAaveV3Pool.withdraw, (collateral, type(uint256).max, address(safe)))
            );
            emit EmergencyWithdraw(collateral, collateralBal, msg.sender, block.timestamp);
        }
    }
}
