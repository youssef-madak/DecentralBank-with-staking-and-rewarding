

const Tether = artifacts.require('Tether');
const RWD = artifacts.require('RWD');
const DecentralBank = artifacts.require('DecentralBank');



module.exports = async function(deployer, network, accounts){
    //deploy mock tether
    await deployer.deploy(Tether)
    const tether = await Tether.deployed() 

    //deploy mock RWD
    await deployer.deploy(RWD)
    const rwd = await RWD.deployed()

    //deploy mock DecentralBank
    await deployer.deploy(DecentralBank, rwd.address, tether.address)
    const decentralbank = await DecentralBank.deployed() 
    //transfer tokens to decentral Bank
    await rwd.transfer(decentralbank.address, '1000000000000000000000000')

    //transfer 100 tether token to invistor

    await tether.transfer(accounts[1], '100000000000000000000')
}