import os
import json
import requests

from brownie import chain, RevokeModule

URL = "https://relay.gelato.digital/"
relayer_key = os.getenv("GELATO_API_KEY")


def main():
    revoke_module = RevokeModule.at("0x80C29777DC19F202DDD2Bb2782F360892870d95e")
    mod_addr = revoke_module.address
    gas_limit = str(300_000)
    chain_id = chain.id

    usdc_address = "0x65aFADD39029741B3b8f0756952C74678c9cEC93"
    spender = "0x8Be59D90A7Dc679C5cE5a7963cD1082dAB499918"
    encoded_data = revoke_module.revokeViaRelayer.encode_input(usdc_address, spender)
    print(encoded_data)

    relay_params = {
        "chainId": chain_id,
        "target": mod_addr,
        "data": encoded_data,
        "sponsorApiKey": relayer_key,
        "gasLimit": gas_limit,
    }

    # TODO: debug --> swagger docs: https://relay.gelato.digital/api-docs/
    # got cancelled: https://relay.gelato.digital/tasks/status/0x271354065780842244c8820fcae9aeeee5874ac4161e44857d5d9b4731002032
    res = requests.post(URL + "relays/v2/sponsored-call", json=json.dumps(relay_params))

    res.raise_for_status()

    print(res.json())
