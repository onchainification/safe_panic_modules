from brownie import accounts, reverts


def test_withdraw_uniswap_v2(safe, module, ulp, ulp_whale, deployer):
    token_amount = 100e18
    ulp.transfer(safe, token_amount, {"from": ulp_whale})
    ulp_balance = ulp.balanceOf(safe)
    assert ulp_balance >= token_amount
    assert ulp_balance > 0

    # ether_bal_before = accounts.at(safe, force=True).balance()

    module.uniswapV2Withdraw(ulp.address, {"from": deployer})

    assert ulp.balanceOf(safe) == 0

    # uncomment once weth withdrawal is implemented
    # assert accounts.at(safe, force=True).balance() > ether_bal_before


def test_withdraw_uniswap_v2_no_balance(safe, module, ulp, deployer):
    assert ulp.balanceOf(safe) == 0

    with reverts():
        module.uniswapV2Withdraw(ulp.address, {"from": deployer})


def test_withdraw_uniswap_v2_false_ulp(module, deployer):
    with reverts():
        module.uniswapV2Withdraw(accounts[5], {"from": deployer})
