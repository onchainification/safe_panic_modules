// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "interfaces/ISafe.sol";
import {IUniswapV2Router02} from "interfaces/uniswap_v2/IUniswapV2Router02.sol";
import {IUniswapV2Pair} from "interfaces/uniswap_v2/IUniswapV2Pair.sol";
import {IWETH9} from "interfaces/IWETH9.sol";
import {BaseModule} from "../BaseModule.sol";

contract UniswapWithdrawModule is BaseModule {
    ////////////////////////////////////////////////////////////////////////////
    // INMUTABLE VARIABLES
    ////////////////////////////////////////////////////////////////////////////
    ISafe public immutable safe;

    ////////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ////////////////////////////////////////////////////////////////////////////

    IUniswapV2Router02 internal constant UNIV2_ROUTER2 =
        IUniswapV2Router02(payable(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D));
    IWETH9 internal constant WETH =
        IWETH9(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6);

    uint256 MAX_BPS = 10_000;
    uint256 SLIPPAGE_BPS = 50;

    ////////////////////////////////////////////////////////////////////////////
    // ERRORS
    ////////////////////////////////////////////////////////////////////////////

    error LpNotSupported(address lp, address signer, uint256 timestamp);

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

    function uniswapV2Withdraw(address lp) external isSigner(safe) {
        // https://docs.uniswap.org/contracts/v2/reference/smart-contracts/router-02#removeliquidity
        IUniswapV2Pair ULP = IUniswapV2Pair(lp);
        address token0 = ULP.token0();
        address token1 = ULP.token1();

        uint256 wethBefore = WETH.balanceOf(address(safe));

        // assume withdrawal of total balance
        uint256 ulpAmount = ULP.balanceOf(address(safe));

        (uint256 reserves0, uint256 reserves1, ) = ULP.getReserves();
        uint256 expectedAsset0 = (reserves0 * ulpAmount) / ULP.totalSupply();
        uint256 expectedAsset1 = (reserves1 * ulpAmount) / ULP.totalSupply();

        _checkTransactionAndExecute(
            safe,
            address(ULP),
            abi.encodeCall(
                IUniswapV2Pair.approve,
                (address(UNIV2_ROUTER2), ulpAmount)
            )
        );
        _checkTransactionAndExecute(
            safe,
            address(UNIV2_ROUTER2),
            abi.encodeCall(
                IUniswapV2Router02.removeLiquidity,
                (
                    token0,
                    token1,
                    ulpAmount,
                    (expectedAsset0 * (MAX_BPS - SLIPPAGE_BPS)) / MAX_BPS,
                    (expectedAsset1 * (MAX_BPS - SLIPPAGE_BPS)) / MAX_BPS,
                    address(safe),
                    block.timestamp
                )
            )
        );
        // TODO: gnosis safe has bugged fallback
        // uint256 wethAfter = WETH.balanceOf(address(safe));
        // if (wethAfter > wethBefore) {
        //     _checkTransactionAndExecute(
        //         safe,
        //         address(WETH),
        //         abi.encodeCall(IWETH9.withdraw, wethAfter - wethBefore)
        //     );
        // }
    }

    fallback() external payable {}
}
