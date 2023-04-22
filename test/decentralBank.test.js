const Tether = artifacts.require('Tether');
const RWD = artifacts.require('RWD');
const DecentralBank = artifacts.require('DecentralBank');


require('chai')
.use(require('chai-as-promised'))
.should()

contract('DecentralBank', ([owner, invistor]) => { //all the code goes here
    //variables for loading contracts       
    let  tether,rwd, decentralbank



    //create function to convert to ether
    function tokens(number){
        return (web3.utils.toWei(number,'ether'))
    }

    before(async () => {
        // Loads contracts
        tether = await Tether.new()
        rwd = await RWD.new()
        decentralbank = await DecentralBank.new(rwd.address, tether.address)


        
        // transfer all tokems to decentralbank 1 million
        await rwd.transfer(decentralbank.address, tokens('1000000'))

        // transfer 100 token to invistor
        await tether.transfer(invistor, tokens('100'), {from: owner})

    })

    describe('Mock Tether Deployment', async()=>{
        it('matches name successfully', async()=>{
            const name = await tether.name()
            assert.equal(name,'Mock Tether Token')
        })
    })
    describe('Rowads Token Deployment', async()=>{
        it('matches name successfully', async()=>{
            const name = await rwd.name()
            assert.equal(name,'Rowads Token')
        })
    })

    describe('decentralbank Deployment', async()=>{
        it('matches name successfully', async()=>{
            const name = await decentralbank.name()
            assert.equal(name,'Decentral Bank')
        })
        it('contract has tokens', async () => {
            let balance = await rwd.balanceOf(decentralbank.address)
            assert.equal(balance, tokens('1000000'))
        })
    })

    describe('yield farming', async()=>{
        it('reward tokens for staking ', async()=>{
            let result;
            //check balance of invistor
            result = await tether.balanceOf(invistor)
            assert.equal(result, tokens('100'))
        })

        it('deposit 100 tokens', async ()=>{
            //run first approve function
            await tether.approve(decentralbank.address, tokens('100'), {from: invistor})
            await decentralbank.depositTokens(tokens('100'), {from: invistor}) //DEPOSITE 100 tokens
            
            //check balnce of insvistor after staking
            let result2 = await tether.balanceOf(invistor)

            // check balance of bank after staking
            let result3 = await tether.balanceOf(decentralbank.address)

            assert.equal(result2.toString(), tokens('0'))
            assert.equal(result3.toString(), tokens('100'))

            //check if isstaked is true

            let stakingState = await decentralbank.isStaked(invistor)
            assert.equal(stakingState, true)


            
        })

        it('give reward to stakers depends on amount they have staked', async()=>{
            
            //calling function
            await decentralbank.issueTokens({from: owner})
            //check taht noone can call this function 
            await decentralbank.issueTokens({from:invistor}).should.be.rejected;

            //check balance of invistor after rewarding
            let balance1 = await rwd.balanceOf(invistor)
            assert.equal(balance1, tokens('10'))
        })

        it('unstake blance from bank' , async()=>{
            //call unstaking function
            await decentralbank.unstakingTokens({from: invistor})

            //check balance of invistor after staking
            let result = await tether.balanceOf(invistor)
            assert.equal(result.toString(), tokens('100'))

            //check bank of invistor after staking
            let result3 = await tether.balanceOf(decentralbank.address)
            assert.equal(result3.toString(), tokens('0'))

            //check stakingbalance of invistor after staking
            let result4 = await decentralbank.stakingBalance(invistor)
            assert.equal(result4.toString(), tokens('0'))

            //check isStaking ti be flase  of invistor after staking
            let result5 = await decentralbank.isStaked(invistor)
            assert.equal(result5, false)

        })
    } )
})