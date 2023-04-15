import pytest
from brownie import AaveWithdrawModule, interface


@pytest.fixture()
def a_token_whale(accounts):
    # https://goerli.etherscan.io/token/0xADD98B0342e4094Ec32f3b67Ccfd3242C876ff7a?a=0x93a7c39d7f848a1e9c479c6fe1f8995015ea2fb9
    return accounts.at("0x93a7c39d7f848A1e9C479C6FE1F8995015Ea2fb9", force=True)


@pytest.fixture()
def a_token():
    # aDAI
    # https://goerli.etherscan.io/address/0xADD98B0342e4094Ec32f3b67Ccfd3242C876ff7a
    a_token = interface.IAToken("0xADD98B0342e4094Ec32f3b67Ccfd3242C876ff7a")
    return a_token


@pytest.fixture
def module(safe, a_token, deployer, a_token_whale):
    # deployment
    module = AaveWithdrawModule.deploy(safe, {"from": deployer})

    # set-up config
    token_amount = 100e18
    a_token.transfer(safe, token_amount, {"from": a_token_whale})

    assert a_token.balanceOf(safe) >= token_amount

    safe.enableModule(module.address, {"from": safe})
    address_one = "0x0000000000000000000000000000000000000001"
    assert module.address in safe.getModulesPaginated(address_one, 10)[0]

    return module


@pytest.fixture()
def collateral():
    # https://goerli.etherscan.io/address/0xBa8DCeD3512925e52FE67b1b5329187589072A55
    token = interface.IERC20("0xBa8DCeD3512925e52FE67b1b5329187589072A55")
    return token
