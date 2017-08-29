pragma solidity ^0.4.10;

contract ERC20Interface {
     // Get the total token supply
    function totalSupply() constant returns (uint8 totalSupply);
   
    // Get the account balance of another account with address _owner
    function balanceOf(address _owner) constant returns (uint8 balance);
   
    // Send _value amount of tokens to address _to
    function transfer(address _to, uint8 _value) returns (bool success);
  
    // Send _value amount of tokens from address _from to address _to
    function transferFrom(address _from, address _to, uint8 _value) returns (bool success);
  
    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    // this function is required for some DEX functionality
    function approve(address _spender, uint8 _value) returns (bool success);
  
    // Returns the amount which _spender is still allowed to withdraw from _owner
    function allowance(address _owner, address _spender) constant returns (uint8 remaining);
  
    // Triggered when tokens are transferred.
    event Transfer(address indexed _from, address indexed _to, uint8 _value);
  
    // Triggered whenever approve(address _spender, uint8 _value) is called.
    event Approval(address indexed _owner, address indexed _spender, uint8 _value);
}

contract Iou is ERC20Interface {
    string public constant symbol = "IOU";
    string public constant name = "I owe you";
    string public constant longDescription = "Buy or trade IOUs from Connor";
    uint8 public decimals = 0;
    uint8 public _totalSupply = 5;
    bool public constant isToken = true;

    address public owner;
    
    // Store the token balance for each user
    mapping(address => uint8) balances;

    mapping(address => mapping(address => uint8)) allowed;

    // Basically a decorator _; is were the main function will go
    modifier onlyOwner() 
    {
        require(msg.sender == owner);
        _;
    }

    function Iou() 
    {
        owner = msg.sender;
        balances[owner] = _totalSupply;
    }

    function changeOwner(address _newOwner) 
        onlyOwner()
    {
        owner = _newOwner;
    }

    function transfer(address _to, uint8 _value)
        returns (bool success)
    {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint8 _value)
        returns (bool success)
    {
        require(allowance(msg.sender, _from) >= _value);
        balances[_from] = balances[_from] - _value;
        balances[_to] = balances[_to] + _value;
        allowed[msg.sender][_from] = allowed[msg.sender][_from] - _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) 
        constant returns (uint8 balance)
    {
        return balances[_owner];
    }

    function approve(address _spender, uint8 _value) 
        returns (bool success)
    {
        require(balances[msg.sender] >= _value);
        allowed[_spender][msg.sender] = allowed[_spender][msg.sender] + _value;
        return true;
    }

    function allowance(address _owner, address _spender)
        constant returns (uint8 allowance)
    {
        return allowed[_owner][_spender];
    }
}