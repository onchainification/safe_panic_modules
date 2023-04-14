import pytest
from brownie import accounts, interface, ZERO_ADDRESS
from brownie.convert.datatypes import EthAddress


@pytest.fixture(scope="session")
def factory():
    # https://github.com/safe-global/safe-contracts/blob/feature/1.4.0-deployment/CHANGELOG.md#factory-contracts
    return interface.ISafeProxyFactory("0x4e1DCf7AD4e460CfD30791CCC4F9c8a4f820ec67")


@pytest.fixture(scope="session")
def safe_v1_4_0():
    # https://github.com/safe-global/safe-contracts/blob/feature/1.4.0-deployment/CHANGELOG.md#core-contracts
    return "0xc962E67D9490E154D81181879ddf4CD3b65D2132"


@pytest.fixture(scope="session")
def deployer():
    return accounts[0]


@pytest.fixture(scope="session")
def safe(factory, safe_v1_4_0, deployer):
    tx = factory.createProxyWithNonce(safe_v1_4_0, b"", 42, {"from": deployer})
    proxy_addr = tx.events["ProxyCreation"]["proxy"]  # or via tx.new_contracts[0]
    assert type(proxy_addr) == EthAddress
    assert proxy_addr != ZERO_ADDRESS

    safe = interface.ISafe(proxy_addr, deployer)
    safe.setup(
        [deployer],  # address[] calldata _owners,
        1,  # uint256 _threshold,
        ZERO_ADDRESS,  # address to,
        b"",  # bytes calldata data,
        ZERO_ADDRESS,  # address fallbackHandler,
        ZERO_ADDRESS,  # address paymentToken,
        0,  # uint256 payment,
        ZERO_ADDRESS,  # address payable paymentReceiver
        {"from": deployer},
    )
    return safe
