import os
import requests

from brownie import chain, RevokeModule

RELAYER_URL = "https://relay.gelato.digital/relays/v2/sponsored-call"
TASK_TRACKER_URL = "https://relay.gelato.digital/tasks/status/"
relayer_key = os.getenv("GELATO_API_KEY")


def main():
    revoke_module = RevokeModule.at("0xAEC2D07d754e39789013c591A9094c8A12d05605")
    mod_addr = revoke_module.address
    gas_limit = str(300_000)
    chain_id = chain.id

    usdc_address = "0x65aFADD39029741B3b8f0756952C74678c9cEC93"
    spender = "0x8Be59D90A7Dc679C5cE5a7963cD1082dAB499918"
    encoded_data = revoke_module.revoke.encode_input(usdc_address, spender)

    relay_params = {
        "chainId": chain_id,
        "target": mod_addr,
        "data": encoded_data,
        "sponsorApiKey": relayer_key,
        "gasLimit": gas_limit,
    }

    # swagger docs: https://relay.gelato.digital/api-docs/
    res = requests.post(RELAYER_URL, json=relay_params)

    res.raise_for_status()

    task_id = res.json()["taskId"]

    print(f"{TASK_TRACKER_URL}{task_id}")
