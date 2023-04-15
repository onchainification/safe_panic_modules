from brownie import AaveWithdrawModule, accounts


def main(deployer_label=None, aave_addr=None):
    deployer = accounts.load(deployer_label)

    aave_module = AaveWithdrawModule.at(aave_addr)

    # default collateral token we used in testnets
    collateral_address = "0x65aFADD39029741B3b8f0756952C74678c9cEC93"

    aave_module.aaveV3Withdraw(
        collateral_address, {"from": deployer, "gas_price": 30e9}
    )
