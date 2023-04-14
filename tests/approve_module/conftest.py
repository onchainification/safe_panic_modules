import pytest
from brownie import accounts, interface, ApprovalModule


@pytest.fixture
def deployer():
    return accounts[0]


def module(deployer):
    module = ApprovalModule.deploy({"from": deployer})
