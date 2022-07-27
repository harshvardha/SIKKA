//SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.0;

abstract contract ERC20_STD {
    function name() public view virtual returns (string memory);

    function symbol() public view virtual returns (string memory);

    function decimals() public view virtual returns (uint8);

    function totalSupply() public view virtual returns (uint256);

    function balanceOf(address _account) public view virtual returns (uint256);

    function transfer(address _to, uint256 _value)
        public
        virtual
        returns (bool);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public virtual returns (bool);

    function approve(address _spender, uint256 _value)
        public
        virtual
        returns (bool);

    function allowance(address _owner, address _spender)
        public
        virtual
        returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
}

contract Ownership {
    address public contractOwner;
    address public newOwner;

    event TransferOwnership(address _from, address _to);

    constructor() {
        contractOwner = msg.sender;
    }

    function transferOwnership(address _to) public {
        require(
            msg.sender == contractOwner,
            "Only contract owner can access this function"
        );
        newOwner = _to;
    }

    function acceptOwner() public {
        require(msg.sender == newOwner, "Only owner can access this function");
        contractOwner = newOwner;
        newOwner = address(0);
    }
}

contract Sikka is ERC20_STD, Ownership {
    string public _name;
    string public _symbol;
    uint8 public _decimals;
    uint256 public _totalSupply;
    address public _minter;
    mapping(address => uint256) public tokenBalances;
    mapping(address => mapping(address => uint256)) public allowed;

    constructor(address minter) {
        _name = "SIKKA";
        _symbol = "SIKKE";
        _totalSupply = 10000000;
        _minter = minter;
        tokenBalances[_minter] = _totalSupply;
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _account)
        public
        view
        override
        returns (uint256)
    {
        return tokenBalances[_account];
    }

    function transfer(address _to, uint256 _value)
        public
        override
        returns (bool)
    {
        require(tokenBalances[msg.sender] >= _value, "Insufficient Balance");
        tokenBalances[msg.sender] -= _value;
        tokenBalances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override returns (bool) {
        uint256 allowedBalance = allowance(_from, msg.sender);
        require(allowedBalance >= _value, "Insufficient Balance");
        tokenBalances[_from] -= _value;
        tokenBalances[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value)
        public
        override
        returns (bool)
    {
        require(tokenBalances[msg.sender] >= _value, "Insufficent Balance");
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender)
        public
        view
        override
        returns (uint256)
    {
        return allowed[_owner][_spender];
    }
}
