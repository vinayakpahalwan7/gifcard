// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "./libraries/Base64.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

contract MyEpicGame is ERC721 {
    //Character attributes
    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string vidURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }
    //unique id 
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    CharacterAttributes[] defaultCharacters;

    //mapping from token id->nft attributes
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;
    //mapping from address to token id
    mapping(address => uint256) public nftHolders;

    //Pass values into the contract from run.js
    constructor(
        string[] memory characterNames,
        string[] memory characterVidURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg
        //unique identifier symbol for the nft added below (SS)
    )
    ERC721("SuperSaiyan","SS")
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
        //increment token id
        _tokenIds.increment();
    }
    //to mint
    function mintCharacterNFT(uint _characterIndex) external {
        //get token id, starts with 1 and assign token id to the wallet address.
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);

        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            vidURI: defaultCharacters[_characterIndex].vidURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].maxHp,
            attackDamage: defaultCharacters[_characterIndex].attackDamage
        });
        console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);
        nftHolders[msg.sender] = newItemId;
        _tokenIds.increment();
    }
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];
         string memory strHp = Strings.toString(charAttributes.hp);
         string memory strMaxHp = Strings.toString(charAttributes.maxHp);
         string memory strAttackDamage = Strings.toString(charAttributes.attackDamage);
         string memory json = Base64.encode(
             bytes(
                 string(
                     abi.encodePacked(
                         '{"name": "',
                         charAttributes.name,
                         ' -- NFT #: ',
                         Strings.toString(_tokenId),
                         '", "description": "This is an NFT that lets people play in the game Metaverse Slayer!", "image": "',
                         charAttributes.vidURI,
                         '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,', "max_value":',strMaxHp,'}, { "trait_type": "Attack Damage", "value": ',
                         strAttackDamage,'} ]}'
                     )
                 )
             )
         );
         string memory output = string(
             abi.encodePacked("data:application/json;base64,", json)
         );
         return output;
    }
}