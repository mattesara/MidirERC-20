// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function burn(uint256 amount) external;
    function mint(uint256 amount) external;
    function stake(uint256 amount) external;
    function withdrawStakeAndRewards(uint256 amount) external;
    function stakedBalanceOf(address account) external view returns (uint256);
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
    mapping(address => uint256) private _stakes;
    uint256 private _totalStaked;
    uint256 private _totalRewards;
    struct StakingRecord {
    uint256 stakedAmount;
    uint256 startTime;
}
    mapping(address => StakingRecord) private _stakingRecords;


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

    // Funzione per ottenere il limite di trasferimento consentito per un determinato indirizzo
    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    // Funzione per bruciare i token
    function burn(uint256 amount) external override {
        address sender = msg.sender;
        require(sender != address(0), "Sender address cannot be zero");
        require(amount <= _balances[sender], "Insufficient balance");

        _balances[sender] -= amount;
        _totalSupply -= amount;
        emit Transfer(sender, address(0), amount);
    }

    function mint(uint256 amount) external {
        address minter = msg.sender;
        require(minter != address(0), "Minter address cannot be zero");
        require(amount > 0, "Amount must be greater than zero");

    
        _totalSupply += amount;

        emit Transfer(address(0), minter, amount);

    }

    // Funzione per staking dei token
    function stake(uint256 amount) external {
        address staker = msg.sender;
        require(staker != address(0), "Staker address cannot be zero");
        require(amount > 0, "Amount must be greater than zero");
        require(amount <= _balances[staker], "Insufficient balance");

        _balances[staker] -= amount;
        _stakes[staker] += amount;
        _totalStaked += amount;
        _stakingRecords[staker] = StakingRecord(amount, block.timestamp);
    }

    // Funzione per ritirare una quantità specifica dal deposito di staking e ricevere le ricompense basate sul tempo
    function withdrawStakeAndRewards(uint256 amount) external {
        address staker = msg.sender;
        StakingRecord storage record = _stakingRecords[staker];

        require(record.stakedAmount > 0, "No staked amount");
        require(amount <= record.stakedAmount, "Amount exceeds staked balance");

        uint256 stakedAmount = record.stakedAmount;
        uint256 startTime = record.startTime;
        uint256 endTime = block.timestamp;

        // Calcolo il tempo trascorso
        uint256 elapsedTime = endTime - startTime;
        uint256 annualInterestRate = 5;

        // Calcolo le ricompense in base al tempo trascorso
        uint256 rewardRate = (stakedAmount * annualInterestRate) / (100 * 365 days);
        uint256 stakerReward = rewardRate * elapsedTime;

        // Distribuisco le ricompense allo staker
        _totalSupply -= stakerReward;
        _balances[staker] += stakerReward;

        // Eseguo il ritiro dello staking
        _stakingRecords[staker] = StakingRecord(0, 0);
        _totalStaked -= amount;
        _balances[staker] += amount;
        stakerReward = 0;


         // Emetto gli eventi per il ritiro e la distribuzione delle ricompense
        emit Transfer(address(this), staker, amount);
        emit Transfer(address(this), staker, stakerReward);
    }


    // Funzione per ottenere il saldo staked di un indirizzo
    function stakedBalanceOf(address account) external view returns (uint256) {
        return _stakes[account];
    }
}