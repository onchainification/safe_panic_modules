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
Do not forget to pass the network, since this project supports multiple chains:
```
$ brownie test --network goerli-fork
```

## Current modules

Proof-of-concepts exist for arbitrary revocations for ERC20 tokens, withdrawals of LP positions and the closing of lending positions on money markets.

1. `RevokeModule`: allows to revoke outstanding approvals for any given token and spender, as long as it is triggered by one of the owners of the safe or the Gelato relayer.

2. `UniswapWithdrawModule`: this module allows for any signer to singlehandedly call (and execute!) a withdrawal of any Uniswap V2 lp position: `uniswapV2Withdraw(lpTokenAddress)`.

3. `AaveWithdrawModule`: allows emergency withdrawals from any V3 aToken position by letting a single signer call `aaveV3Withdraw(aTokenAddress)`. The module will withdraw on behalf of the multisig, indiffferent of the actual signer's threshold needed by the safe (`Safe.getThreshold`).

Said modules can be deployed from the `ModuleFactory`, which takes the Safe address as its only constructor argument. Once deployed, the module needs to be enabled in a regular multisig transaction (`Safe.enableModule`).

## Account abstraction experimentation: integration with Gelato Relayer

We defined the concept of "guardians", which are entities working tightly together with the Safe signers in the security space. Transaction sponsors provide the "guardians" with the `GELATO_API_KEY` which will allow them to trigger the modules in case of an emergency.

These emergency methods are tightly scoped and can be executed with relatively low risk. Gas is prepaid, cannot be used for other purposes and is thus completely abstracted away from the guardian.

Imagine a world in which security experts such as [@peckshield](https://twitter.com/peckshield) or [@ZachXBT](https://twitter.com/zachxbt) are appointed as a trusted guardian, and can revoke, withdraw or close positions across a collection of multisigs in case of war room situations.

## Push notification support

Modules are hooked up automatically to a `channel` belonging to the Safe. This channel provides a way for signers to communicate and always stay up-to-date on when high level emergency transactions gets executed.

![alt text](https://user-images.githubusercontent.com/84875062/232185090-fe7c574b-8b04-40a0-9e98-79fc879b5569.png)

## Vision for UX

All these modules could be managed through a dapp. This dapp would provide a smoother experience when it comes to deploying, managing and monitoring the modules. Both deployment and enabling of the module could then be done in one transaction, which is only possible atomically due to `Safe`'s [GS031](https://github.com/safe-global/safe-contracts/blob/main/docs/error_codes.md#general-auth-related).

We experimented with deploying an [ERC20 approvals subgraph](https://github.com/gosuto-inzasheru/erc20-subgraph-approvals) to inform Safe users on their outstanding approvals. This could even enable batch revokes, in case of multiple outstanding (inifinite) approvals.

Push protocol chat and notifications could be made visible here, as could monitoring of supported positions.

## Deployments

- `Safe` (v1.3.0+L2)
  - Goerli: [`0x206C89813cbDE8E14582Ff94F3F1A1728C39a300`](https://app.safe.global/home?safe=gor:0x206C89813cbDE8E14582Ff94F3F1A1728C39a300)
  - Gnosis: [`0xa4A4a4879dCD3289312884e9eC74Ed37f9a92a55`](https://app.safe.global/home?safe=gno:0xa4A4a4879dCD3289312884e9eC74Ed37f9a92a55)
  - Polygon: [`0xaC15894d64024e4853b78470e68c448Ba9e04Ea4`](https://app.safe.global/home?safe=matic:0xaC15894d64024e4853b78470e68c448Ba9e04Ea4)
- `Safe` (v.1.4.0)
  - Goerli:

- `ModuleFactory`
  - Goerli: [`0x23B2968c92558d47d2C293FebC2B3f81619ADbad`](https://goerli.etherscan.io/address/0x23B2968c92558d47d2C293FebC2B3f81619ADbad)
  - Gnosis: [`0xa4A4a4879dCD3289312884e9eC74Ed37f9a92a55`](https://gnosisscan.io/address/0x8ff2d0baa60219ab2320029053eb77f8791b8fcc)
  - Polygon: [`0x7F86dC36db7ec0eBF9E697a6267f88623Eb7D649`](https://polygonscan.com/address/0x7F86dC36db7ec0eBF9E697a6267f88623Eb7D649)

- `UniswapWithdrawModule`
  - Goerli: [`0x4de04c364EaF1C5b10A44b776140b2CAC47A5A41`](https://goerli.etherscan.io/address/0x4de04c364EaF1C5b10A44b776140b2CAC47A5A41)
  - Polygon: [`0x4dc22908b17125ac79a16f389a7c873170251d03`](https://polygonscan.com/address/0x4dc22908b17125ac79a16f389a7c873170251d03)

- `RevokeModule`
  - Goerli: [`0xa62068345D27c316350bc726d417f8bA54e0522D`](https://goerli.etherscan.io/address/0xa62068345D27c316350bc726d417f8bA54e0522D)
  - Polygon: [`0x6304225e3bc9db47e96ac28728cffee72e62e9b9`](https://polygonscan.com/address/0x6304225e3bc9db47e96ac28728cffee72e62e9b9)

- `AaveWithdrawModule`
  - Goerli: [`0x95bE92728cBd7007352b44De6FDDc241EE5D01dC`](https://goerli.etherscan.io/address/0x95bE92728cBd7007352b44De6FDDc241EE5D01dC)
  - Polygon: [`0x23af31b6a2cc1c38b21c433c01a6fbad29f93259`](https://polygonscan.com/address/0x23af31b6a2cc1c38b21c433c01a6fbad29f93259)

## Goerli testnet transactions

Some successful executions of these ideas on Görli to showcase these proof-of-concepts:

- Signer `0xef42` calls `aaveV3Withdraw(aTokenAddress)` on the `AaveWithdrawModule` installed on their Safe. The transaction does not need to reach threshold as normal; one alert signer is in this case enough to trigger the emergency withdrawal [[tx hash]](https://goerli.etherscan.io/tx/0x141978884ff42a91b3b0f5ea5873399a6e8795488a1da787f64b91112f915a41).
- This Gelato task https://relay.gelato.digital/tasks/status/0x9c0a4ef4e2adfa31e0b97c356c8deec8e5253f15511c85c8b8a590c55bc9b903, initiated by a web2 guardian, triggering a revoke on-chain (`approve(owner, spender, 0)`) on an arbitrary token and spender [[tx hash]](https://goerli.etherscan.io/tx/0xde89ceb3ade10fc08e5ca6ac1c4e440870bb6b68e37cce6c822253453c387932). Signers pre-approved (the scope of) the module in advance, and were not needed to sign [[tx hash]](https://goerli.etherscan.io/tx/0xc985b717b864e05cab676c05a79e12ead62f3a96be71fecba45732c8162b53dd). Gas was paid for in advance as well [[tx hash]](https://goerli.etherscan.io/tx/0x3609db40824e899b5e61d0596fc2de84d68820e5dc759901feaac49f35e569fc).
