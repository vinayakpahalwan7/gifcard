// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract MyEpicGame {
    //Character attributes
    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string vidURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }
    //Default data for all characters.
    CharacterAttributes[] defaultCharacters;

    //Pass values into the contract from run.js
    constructor(
        string[] memory characterNames,
        string[] memory characterVidURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg
    )
    {
        //loop through all characters, to save their values in our contract.
        for(uint i = 0; i<characterNames.length; i+=1) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
                name: characterNames[i],
                vidURI: characterVidURIs[i],
                hp: characterHp[i],
                maxHp: characterHp[i],
                attackDamage: characterAttackDmg[i]
            }));

            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done initializing %s w/ HP %s, img %s", c.name, c.hp, c.vidURI);
        }
    }
}