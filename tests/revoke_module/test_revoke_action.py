from brownie import reverts


def test_revoke(module, safe, deployer, token, rug_puller):
    assert token.allowance(safe, rug_puller) > 0
    tx = module.revoke(safe, token, rug_puller, {"from": deployer})
    assert token.allowance(safe, rug_puller) == 0

    revoke_event = tx.events["Revoked"]
    assert revoke_event["safe"] == safe.address
    assert revoke_event["token"] == token.address
    assert revoke_event["spender"] == rug_puller


def test_revoke_not_rights(module, safe, token, rug_puller, accounts):
    with reverts():
        module.revoke(safe, token, rug_puller, {"from": accounts[4]})
