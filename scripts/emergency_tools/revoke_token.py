from brownie import RevokeModule, accounts


def main(deployer_label=None, revoke_addr=None):
    deployer = accounts.load(deployer_label)

    revoke_module = RevokeModule.at(revoke_addr)

    # default token and spender we used in testnets
    usdc_address = "0x65aFADD39029741B3b8f0756952C74678c9cEC93"
    spender = "0x8Be59D90A7Dc679C5cE5a7963cD1082dAB499918"

    revoke_module.revoke(usdc_address, spender, {"from": deployer, "gas_price": 30e9})
