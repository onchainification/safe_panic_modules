from brownie import reverts


def test_withdraw(module, safe, deployer, a_token, collateral, module_set_up):
    assert a_token.balanceOf(safe) > 0
    assert collateral.balanceOf(safe) == 0
    a_token_balance = a_token.balanceOf(safe)
    tx = module.withdraw(safe, collateral, {"from": deployer})
    assert a_token.balanceOf(safe) == 0
    assert collateral.balanceOf(safe) > 0

    emerg_wd_event = tx.events["EmergencyWithdraw"]
    assert emerg_wd_event["asset"] == collateral.address
    # TODO: calc rate i guess between atoken <> token
    assert emerg_wd_event["amount"] > a_token_balance
    assert emerg_wd_event["signer"] == deployer


def test_withdraw_not_rights(module, safe, collateral, module_set_up, accounts):
    with reverts():
        module.withdraw(safe, collateral, {"from": accounts[4]})