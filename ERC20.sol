// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeMath {

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}


contract MyERC is SafeMath {

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply_;
    address owner;

    // this event is stored in blockchain as a logs
  event Transfer (address indexed from, address indexed to, uint256 value); 
  
 // way of storing user balance using mappping as a dict
  mapping(address => uint256) balances;
  // nested user allowance mapping 
  mapping(address => mapping(address => uint256)) allowed;

  constructor(){
    name = "YogeshERC20";
    symbol = "YRC";
    decimals = 18;
    totalSupply_ = 10 ether;

    balances[msg.sender] = totalSupply_;  
  }
  

    modifier sufficientBalance(address _spender, uint _value){
    require(_value <= balances[_spender] , "Insufficient Balance for User");
    _;
  }
    


  function _mint(address _to, uint256 _amount)public payable returns (bool) {
    // balances[tx.origin] = add(balances[tx.origin] ,_amount);
    balances[_to] = add(balances[_to] ,_amount);
    emit Transfer(address(0), _to, _amount);
    return true;
  }



  function totalSupply() public view returns(uint256){
    return totalSupply_;
  }

  function balanceOf(address _who) public view returns(uint256){
    return balances[_who];
  }

  function transfer(address to, uint256 value) public returns(bool){
    balances[msg.sender] = balances[msg.sender] - value;
    // subtracting from sender
    balances[to] = balances[to] + value;
    // adding to receiver
    emit Transfer(msg.sender, to, value);
    // saving logs 
    totalSupply_ = totalSupply_ -value;
    return true;
  }

   function burn(address account, uint256 amount) external {
    _burn(account, amount);
  }

  function _burn(address account, uint256 amount) internal {
    require(amount != 0);
    require(amount <= balances[account]);
    totalSupply_ = sub(totalSupply_, amount);
    balances[account] = sub(balances[account], amount);
    emit Transfer(account, address(0), amount);
  }


  
}
