import pytest
from brownie import RevokeModule, TokenErc20


@pytest.fixture()
def rug_puller(accounts):
    return accounts[1]


@pytest.fixture()
def token(deployer):
    fake_token = TokenErc20.deploy(
        "rugPullToken", "NGMI", deployer, 100e18, {"from": deployer}
    )
    return fake_token


@pytest.fixture()
def module(safe, token, rug_puller, deployer):
    # deploy module
    module = RevokeModule.deploy(safe, {"from": deployer})

    # set-up module config
    approve_amount = 100e18
    token.approve(rug_puller, approve_amount, {"from": safe})

    assert token.allowance(safe, rug_puller) == approve_amount

    safe.enableModule(module.address, {"from": safe})
    address_one = "0x0000000000000000000000000000000000000001"
    assert module.address in safe.getModulesPaginated(address_one, 10)[0]

    return module
