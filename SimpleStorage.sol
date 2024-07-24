
//EVM -> Ethereum Virtual Machine
// Ethereum Polygon Arbitrum Optimism Zksync

// SPDX-License-Identifier: MIT
pragma solidity 0.8.18; // Only this version will work with the code
// pragma solidity ^0.8.18; // This and all the greater versions of solidity will work
// pragma solidity >= 0.8.18 <0.9.0 // To define versions within a range.

contract SimpleStorage {
 
    uint256 myfavouriteNumber ; // uint 256 - default value => 0
    struct Person{
        uint256 favouriteNumber;
        string name;
    }
    // Person public myfriend = Person(7, "Sameer");
    Person[] public friends; // dynamic array
    // Person[3] public friends; // static array

    mapping(string => uint256) public nameToFavNumber; // default value to a non existent mapping is default value of uint256 in this case which is 0.



    // calldata, memory, storage 
    //memory variable can be altered, meanwhile calldata can not be. its immutable

    //structs mappings or array need to be given the memory keyword.
    //strings work with memory keyword.


    function updateFriends(string memory name, uint256 _favNumber) public {
        // friends.push( Person(_favNumber, name) ); // solidity is smart enough to parameterise the value in the push function first then execute push function

        Person memory tempPerson = Person(_favNumber, name);
        friends.push(tempPerson);

        nameToFavNumber[name] = _favNumber; 
    }


    function store(uint256 _favouriteNumber) public virtual {
        myfavouriteNumber = _favouriteNumber;
    }
   
   

    // view, pure -> not updating, not a transcation, can not update a vaule in this"view" type function

    function retrieve() public view returns (uint256) {
        return myfavouriteNumber;
    }
    //0xd9145CCE52D386f254917e481eB44e9943F39138
    //
}

contract SimpleStorage2 {
    
}