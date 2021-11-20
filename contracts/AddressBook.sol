//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/// @title A simulator for address book
/// @author lightbird
/// @notice Use it to store or get address base on current message sender
/// @dev simple simulator, will not strictly check your address inputed
/// @custom:learning This is an contract for solidity learning.
contract AddressBook {

    //struct for a type of "address" // this allows every user to have their address book//
    struct Record {
        string name;
        address addr;
        string note;
    }

    //mapping to link user with their addressbook//
    mapping (address => Record[]) private _aBook;

    /// @notice Get length of a specific string
    /// @dev transfer the string to bytes and use bytes.length to get the length 
    /// @param _str a string
    /// @return length of the string passed
    function getStringLength(string memory _str) public pure returns (uint256){
        bytes memory bts = bytes(_str);
        return bts.length;
    }

    /// @notice Add an address(name: `_name`, address: `_addr`, note: `note`) to the persistent address book
    /// @dev construct a new record and store it to the storage `_aBook`
    /// @param _name who is the address indexed to
    /// @param _addr the concrate address
    /// @param _note additional information about the address
    function addAddress(string memory _name, address _addr,string memory _note) public   {
        require(getStringLength(_name) >= 1, "Name can not be empty");
        Record memory newRecord = Record(_name, _addr, _note);
        _aBook[msg.sender].push(newRecord);
    }
    
    /// @notice Get address records of the message sender
    /// @dev one can only get the address of his or her address
    /// @return address records of the message sender
    function getAddrBook() public view returns (Record[] memory){
        return _aBook[msg.sender];
    }

}