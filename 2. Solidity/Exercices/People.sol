// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract People {

    struct Person {

        string name;
        uint age;
    }
/*
    Person public moi;

    function modifyPerson(string memory _name, uint _age) public {
        moi.name = _name;
        moi.age = _age;
    }
*/

    Person[] public persons;

    function addPerson(string memory _name, uint _age) public {
        persons.push(Person(_name, _age));
    }


    function removePerson() public {
        require(persons.length > 0, "No person to remove.");
        persons.pop();
    }
    
}