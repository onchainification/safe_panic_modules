import time

from brownie import ZERO_ADDRESS, chain


def test_get_chain_id(factory):
    chain_id = factory.getChainId()
    assert chain_id == chain.id


def test_deploy_safe(safe, deployer):
    assert safe.address != ZERO_ADDRESS
    assert safe.getThreshold() == 1
    assert safe.getOwners()[0] == deployer.address


def test_clean_exit():
    time.sleep(1)
    return
