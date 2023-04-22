// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0; 


contract RWD{

    string public name = 'Rowads Token';
    string public symbol = 'RWD';
    uint256 public totalSupply = 1000000000000000000000000; //1 milion tokens (search for total suply)
    uint8 public decimals = 18;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender ,
        uint _value
    );

    //mapp every adress to it's balance
    mapping (address => uint256) public balanceOf;

    //mapp every address that approve the second address to make transfer
    /* allowance allow a third party to have the right to carry out a transaction of a 
    certain amount of our tokens, which are associated with our address. */
       
    mapping (address  => mapping (address => uint256)) public allowance;


    constructor()public{
        balanceOf[msg.sender] = totalSupply;
    }

    //simple transfer between two addresses
    function transfer (address _to, uint _value) public returns(bool sucess){

        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value )public returns(bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    //transfer with a third_party like dapp or dex

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool sucess){
    //balance of from should be > value
        require(_value <= balanceOf[_from]);
    /*Then they msg.sender can transfer amounts less
         than or equal to the amount allocated by  from to other users.*/
        require(_value <= allowance[_from][msg.sender]);//_value <= value alowwed by _from
        balanceOf[_to] +=  _value;
        balanceOf[_from] -=  _value;
    /*this function means that msg.sender gives a smart contract or thir-party 
        permission to take tokens from _from*/
        allowance [_from][msg.sender] -= _value; //allowance amount - value
        emit Transfer(_from, _to, _value);
        return true;
    }

}