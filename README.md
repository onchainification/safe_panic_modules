# Safe Panic Module

## Installation

```
$ poetry install
```

You will also need [`ganache`](https://trufflesuite.com/docs/ganache/). If not installed yet:
```
$ npm install -g ganache
```

## Testing
Do not forget to pass the network, since this whole project is developed on Goerli:
```
$ brownie test --network goerli-fork
```

## Gotchas during development

We though that the factory could hook-up automatically the module deployed, but due to security reasons see [GS031](https://github.com/safe-global/safe-contracts/blob/main/docs/error_codes.md#general-auth-related) the enabling of the module is only possible from the safe itself to avoid undesired actions. It will require another action from the signers to enable the module deployed to fully onboard the freshly deployed module.

## Goerli testnet deployment

- `ModuleFactory`
  - Goerli: [0xbaAcd51a21e9047E8E58249574532F3dc55BFC28](https://goerli.etherscan.io/address/0xbaAcd51a21e9047E8E58249574532F3dc55BFC28)