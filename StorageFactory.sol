//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// import "./SimpleStorage.sol"; // one way
import {SimpleStorage} from "./SimpleStorage.sol"; // another way

contract StorageFactory {
    //type visibility name
    SimpleStorage[] public ListOfSimpleStorage ;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        ListOfSimpleStorage.push(newSimpleStorageContract);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {
        ListOfSimpleStorage[_simpleStorageIndex].store(_newSimpleStorageNumber);
    }

    function sfGet (uint256 _simpleStorageIndex) public view returns (uint256){
        return ListOfSimpleStorage[_simpleStorageIndex].retrieve();
    }
}