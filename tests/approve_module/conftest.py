import pytest
from brownie import ApprovalModule


OZ_DEPS = "OpenZeppelin/openzeppelin-contracts@4.5.0"


@pytest.fixture
def deployer(accounts):
    return accounts[0]


@pytest.fixture()
def rug_puller(accounts):
    return accounts[1]


@pytest.fixture()
def module(deployer):
    module = ApprovalModule.deploy({"from": deployer})
    return module


@pytest.fixture()
def token(pm, deployer):
    oz = pm(OZ_DEPS)
    fake_token = oz.ERC20.deploy("rugPullToken", "NGMI", {"from": deployer})
    return fake_token
