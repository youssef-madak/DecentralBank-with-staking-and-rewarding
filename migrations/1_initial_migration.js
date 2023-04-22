/*
Migrations are JavaScript files that help you deploy contracts to the Ethereum network.
These files are responsible for staging your deployment tasks, and they're written under
the assumption that your deployment needs will change over time. As your project evolves,
you'll create new migration scripts to further this evolution on the blockchain. 
A history of previously run migrations is recorded on-chain through a special Migrations 
contract.
*/


const Migrations = artifacts.require('Migrations');

module.exports = function (deployer){
    deployer.deploy(Migrations);
};