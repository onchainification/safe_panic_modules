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

## Modules supported 

1. Revoke module: allows to set allowance zero for a specific token and spender as long as it is trigger from any of the safe signers or gelato relayer.

2. AaveV3 module: allows withdrawing from an aToken position given its underlying collateral as an argument in case of emergency from any safe signers or gelato relayer.

## Integration with Gelato Relayer for AA experimentation

We defined the concept of `guardians` which are entities working tightly together with the gnosis safe signers in the security space. Transaction sponsor provides the `guardians` with the `GELATO_API_KEY` which will allow them to trigger in case of emergency scoped methods from the safes without needing to worry about gas expenditure.

Example: [taskId](https://relay.gelato.digital/tasks/status/0x9c0a4ef4e2adfa31e0b97c356c8deec8e5253f15511c85c8b8a590c55bc9b903) triggerin [tx hash](https://goerli.etherscan.io/tx/0xde89ceb3ade10fc08e5ca6ac1c4e440870bb6b68e37cce6c822253453c387932).

## Push notification support

Modules are hooked-up automatically to a `channel` belonging to the safe where they are enabled. This channel serves as a purpose of communication for signers in case that any of the emergency transactions gets executed.

![alt text](https://user-images.githubusercontent.com/84875062/232185090-fe7c574b-8b04-40a0-9e98-79fc879b5569.png)

## Gotchas during development

We thought that the factory could hook up the deployed module automatically, but due to security reasons (see [GS031](https://github.com/safe-global/safe-contracts/blob/main/docs/error_codes.md#general-auth-related)) the enabling of the module is only possible from the safe itself. It will require another action from the signers to enable the deployed module in order to fully onboard it.

## Goerli testnet deployment

- `ModuleFactory`
  - Goerli: [0xbaAcd51a21e9047E8E58249574532F3dc55BFC28](https://goerli.etherscan.io/address/0xbaAcd51a21e9047E8E58249574532F3dc55BFC28)