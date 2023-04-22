
/*   In Solidity, “approve” means to approve or allow a specified address to transfer a specified
 number of tokens. After “approve” is done, the tokens are still in the holder’s account. 
 It only means the specified address can spend the specified number of tokens from the holder’s 
 account. 

For instance, when an external address interacts with a smart contract and that smart contract 
needs to spend a number of tokens held in that external address, the smart contract should have 
the approval of spending the token before it can actually spend. After that external address has 
approved the smart contract to do so, then the interaction would proceed successfully otherwise 
the interaction wouldn’t be able to continue. Therefore this “approve” is a must-have step for 
the interaction to proceed.

However, this “approve” would introduce risks. For instance, if an external
address carelessly approves a malicious smart contract to spend a type of token in it, 
the tokens held in that external address might be spent any time by that malicious contract. 
This would expose the address’ tokens to huge risks.  */


// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0; 


contract Tether{


    string public name = 'Mock Tether Token';
    string public symbol = 'USDT';
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


    constructor() public{
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