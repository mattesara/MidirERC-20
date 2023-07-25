// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// Implementazione dello standard ERC-20
contract Midir is IERC20 {
    string public constant name = "Midir"; 
    string public constant symbol = "MID"; 
    uint8 public constant decimals = 18; 

    uint256 private _totalSupply; 
    mapping(address => uint256) private _balances; 
    mapping(address => mapping(address => uint256)) private _allowances; 

    // Emissione iniziale del token e assegnazione all'indirizzo del creatore del contratto
    constructor(uint256 totalSupply_) {
        _totalSupply = totalSupply_ * 10 ** uint256(decimals);
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // Funzione per ottenere la quantità totale di token in circolazione
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    // Funzione per ottenere il saldo di un indirizzo specifico
    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    // Funzione per trasferire token ad un altro indirizzo
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        address sender = msg.sender;
        require(sender != address(0), "Sender address cannot be zero");
        require(recipient != address(0), "Recipient address cannot be zero");
        require(amount <= _balances[sender], "Insufficient balance");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // Funzione per consentire a un indirizzo di trasferire token per conto di un proprietario
    function approve(address spender, uint256 amount) external override returns (bool) {
        address owner = msg.sender;
        require(owner != address(0), "Owner address cannot be zero");
        require(spender != address(0), "Spender address cannot be zero");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
        return true;
    }

    // Funzione per effettuare un trasferimento da un indirizzo autorizzato
    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        address spender = msg.sender;
        require(spender != address(0), "Spender address cannot be zero");
        require(sender != address(0), "Sender address cannot be zero");
        require(recipient != address(0), "Recipient address cannot be zero");
        require(amount <= _balances[sender], "Insufficient balance");
        require(amount <= _allowances[sender][spender], "Allowance exceeded");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        _allowances[sender][spender] -= amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // Funzione per ottenere il limite di trasferimento per un determinato indirizzo
    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }
}