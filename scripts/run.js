const { hexStripZeros } = require("@ethersproject/bytes")

const main = async() => {
    //This will compile the contract and generate necessary fules we need to work our contracts under the artifacts directory.
    //Hardhat will create a local eth network, after script completes - it is destroyed. Hardhat also create fake miners on the machine to imitate actual blockchain.
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy();
    await gameContract.deployed();
    console.log("Contract deployed to: ", gameContract.address);
};

const runMain = async() => {
    try {
        await main();
        process.exit(0);
    } catch(error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();