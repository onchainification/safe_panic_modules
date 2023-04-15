import pytest
from brownie import ModuleFactory


@pytest.fixture()
def module_factory(accounts):
    factory = ModuleFactory.deploy({"from": accounts[8]})
    return factory
