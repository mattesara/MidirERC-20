// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract MyContract is ERC20 {
    constructor() ERC20("Midir", "MID") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}