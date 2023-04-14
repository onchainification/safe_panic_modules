from brownie import reverts


def test_approve(module, safe, deployer, token, rug_puller, module_set_up):
    assert token.allowance(safe, rug_puller) > 0
    tx = module.approve(safe, token, rug_puller, {"from": deployer})
    assert token.allowance(safe, rug_puller) == 0

    revoke_event = tx.events["Revoked"]
    assert revoke_event["safe"] == safe.address
    assert revoke_event["token"] == token.address
    assert revoke_event["spender"] == rug_puller


def test_approve_not_rights(module, safe, token, rug_puller, module_set_up, accounts):
    with reverts():
        module.approve(safe, token, rug_puller, {"from": accounts[4]})
