from brownie import RevokeModule, accounts


def main(deployer_label=None):
    deployer = accounts.load(deployer_label)

    goerli_msig = "0x206C89813cbDE8E14582Ff94F3F1A1728C39a300"
    return RevokeModule.deploy(goerli_msig, {"from": deployer, "gas_price": 30e9}, publish_source=True)
