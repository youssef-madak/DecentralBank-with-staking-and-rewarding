// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import './RWD.sol';
import './Tether.sol';

contract DecentralBank{
    string public name = 'Decentral Bank';
    address owner;

    Tether public  tether;
    RWD public reward;
    address[] public stakers; //stakers arrray

//tracking staking balance 
mapping(address => uint) public stakingBalance; 
mapping(address => bool) public hasStaked;
mapping(address => bool) public isStaked;

    constructor(RWD _rwd,  Tether _tether)public{
        reward = _rwd;
        tether = _tether;
        owner = msg.sender;
    }

    //staking function 

    function depositTokens(uint _amount) public{
        // require staking amount to be greather than zero
        require(_amount > 0);
        //transfer tokens to contract address 
        tether.transferFrom(msg.sender, address(this), _amount);

        // update staking balance of each person
        stakingBalance[msg.sender] = stakingBalance[msg.sender] += _amount;

        //check if has not stake before
        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }
        // update stakers existance
        isStaked[msg.sender] = true;
        hasStaked[msg.sender] = true;

    }

    // Unstaking Function 
    function unstakingTokens() public{
        //require balance > 0
        uint balance = stakingBalance[msg.sender];
        require(balance > 0);

        // transfer from contract to the staker wallet address

        tether.transfer(msg.sender, balance);
        stakingBalance[msg.sender] = stakingBalance[msg.sender] -= balance;

        isStaked[msg.sender] = false;
    }

    //function to give rewards to stakers

    function issueTokens()public {
        //require thta only the owner can call this function
        require(msg.sender == owner);

        for(uint i=0; i < stakers.length; i++){
            address recipient = stakers[i];
            uint balance = (stakingBalance[recipient] /10); // dakchi li staka 1/9 meno
            
            if(balance > 0){
                
                reward.transfer(recipient, balance);

            }
            
        }
    }
}