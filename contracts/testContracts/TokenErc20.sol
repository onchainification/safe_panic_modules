// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/mocks/ERC20Mock.sol";

contract TokenErc20 is ERC20Mock {
    constructor(string memory name, string memory symbol, address initialAccount, uint256 initialBalance)
        ERC20Mock(name, symbol, initialAccount, initialBalance)
    {}
}
