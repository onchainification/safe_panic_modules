import pytest
from brownie import UniswapWithdrawModule, interface


@pytest.fixture(scope="session")
def ulp():
    # UNI/WETH
    # https://goerli.etherscan.io/address/0x28cee28a7C4b4022AC92685C07d2f33Ab1A0e122
    return interface.IUniswapV2Pair("0x28cee28a7C4b4022AC92685C07d2f33Ab1A0e122")


@pytest.fixture(scope="session")
def uni_v2_router():
    return interface.IUniswapV2Router02("0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D")


@pytest.fixture()
def ulp_whale(accounts):
    # https://goerli.etherscan.io/token/0x28cee28a7c4b4022ac92685c07d2f33ab1a0e122#balances
    return accounts.at("0x41653c7d61609D856f29355E404F310Ec4142Cfb", force=True)


@pytest.fixture()
def module(safe, deployer):
    module = UniswapWithdrawModule.deploy(safe, {"from": deployer})
    safe.enableModule(module.address, {"from": safe})
    address_one = "0x0000000000000000000000000000000000000001"
    assert module.address in safe.getModulesPaginated(address_one, 10)[0]

    return module
