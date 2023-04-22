//why we use babel-register

/*if we want to run babel without a build step like webpack or rollup, and run files
using babel 'on the fly' we need to register babel into node's runtime The require
hook will bind itself to node’s require and automatically compile files on at runtime.
*/

require('babel-register');
require('babel-polyfill');

module.exports = {

    //setup network config from ganache
    networks :{
        developement:{
            host: '127.0.0.1',
            port: '7545',
            network_id : '*', //connect to any network
        },
    },

    contracts_directory : './src/contracts/', //The default output directory for **uncompiled** contract

    contracts_build_directory: './src/truffle-abis', // The default output directory for **compiled** contract

    //setup of our compiler "solc"

    compilers : {
        solc:{
            version : '^0.8.0',
            optimizer : {
                enabled: true,
                runs: 200,
            },
        },
    },

}
