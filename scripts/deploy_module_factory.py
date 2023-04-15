from brownie import ModuleFactory, accounts


def main(deployer_label=None):
    deployer = accounts.load(deployer_label)

    return ModuleFactory.deploy({"from": deployer}, publish_source=True)
