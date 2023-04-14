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
