# Safe Panic Module

## Installation

```
$ poetry install
$ git submodule update --init --recursive
```
That last command clones (or updates) the `erc20-subgraph-approvals` repo in `subgraphs/`.

You will also need [`ganache`](https://trufflesuite.com/docs/ganache/). If not installed yet:
```
$ npm install -g ganache
```

## Testing
Do not forget to pass the network, since this whole project is developed on Goerli:
```
$ brownie test --network goerli-fork
```
