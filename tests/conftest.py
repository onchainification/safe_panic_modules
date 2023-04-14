import pytest
from brownie import interface


@pytest.fixture
def factory():
    return interface.ISafeProxyFactory("0x4e1DCf7AD4e460CfD30791CCC4F9c8a4f820ec67")
