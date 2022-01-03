// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract MyErc20 {

    string NAME = "LegaultToken";
    string SYMBOL = "QCT";
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    
    mapping(address => uint) balances;
    address deployer;
    
    constructor(){
        deployer = msg.sender;
        balances[deployer] = 1000000 * 1e8; //1M to deployer esti
    }
    
    function name() public view returns (string memory) {
       return NAME; 
    }
    
    function symbol() public view returns (string memory) {
        return SYMBOL;
    }
    
    function decimals() public view returns (uint8) {
        return 8; // wei
    }
    
    function totalSupply() public view returns (uint256) {
        return 1000000; // 10M for QC population
    }
    
    function balanceOf(address _owner) public view returns (uint256 balance) {
                return balances[_owner];    
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        assert(balances[msg.sender] > _value);
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        return true;

        emit Transfer(msg.sender, _to, _value);
        
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if(balances[_from] < _value)
        return false;

        if(allowances[_from][msg.sender] < _value)
        return false;

        balances[_from] -= _value;
        balances[_to] += _value;
        allowances[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        
        return true;
    }

    mapping(address => mapping(address => uint)) allowances;
    
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }
    mapping(uint => bool) blockMined;
    uint totalMinted = 1000000 * 1e8; 
    
    function mine() public returns(bool success){
        if(blockMined[block.number]){ // rewards of this block already mined
            return false;
        }
        if(block.number % 10 != 0 ){ // not a 10th block
            return false;
        }
        
        balances[msg.sender] = balances[msg.sender] + 10*1e8;
        totalMinted = totalMinted + 10*1e8;
        blockMined[block.number] = true;
        
        return true;
    }
    
    function getCurrentBlock() public view returns(uint){
        return block.number;
    }
    
    function isMined(uint blockNumber) public view returns(bool) {
        return blockMined[blockNumber];
    }
    
}

    
