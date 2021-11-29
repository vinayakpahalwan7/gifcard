const { hexStripZeros } = require("@ethersproject/bytes")

const main = async() => {
    //This will compile the contract and generate necessary fules we need to work our contracts under the artifacts directory.
    //Hardhat will create a local eth network, after script completes - it is destroyed. Hardhat also create fake miners on the machine to imitate actual blockchain.
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
        ["Dave", "John", "Coach", "Kobe", "Ronaldo", "Lebron", "Steph"],
        ["https://i.imgur.com/zRKUVBS.mp4",
        "https://i.imgur.com/17djyaF.mp4",
        "https://i.imgur.com/frnXxyM.mp4",
        "https://i.imgur.com/Ms7PR7F.mp4",
        "https://i.imgur.com/1kSZ05R.mp4",
        "https://i.imgur.com/pOHFkGP.mp4",
        "https://i.imgur.com/kdOE35B.mp4"],
        [1000, 400, 200, 500, 400, 600, 500],
        [100, 100, 100, 100, 100, 100, 100]
    );
    await gameContract.deployed();
    console.log("Contract deployed to: ", gameContract.address);

    let txn;
    txn = await gameContract.mintCharacterNFT(6);
    await txn.wait();

    let returnedTokenUri = await gameContract.tokenURI(1);
    console.log("Token URI: ",returnedTokenUri);
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