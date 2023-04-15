from brownie import AaveWithdrawModule, accounts


def main(deployer_label=None):
    deployer = accounts.load(deployer_label)

    goerli_msig = "0x206C89813cbDE8E14582Ff94F3F1A1728C39a300"
    return AaveWithdrawModule.deploy(
        goerli_msig, {"from": deployer}, publish_source=True
    )
