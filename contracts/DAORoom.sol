//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/// @title A simulator of one room, pay fee to occupy it!
/// @notice Pay fee to occupy a room!
contract DAORoom {

    address payable public owner;

    uint public cost;

    enum Status {Vacant, Occupied}

    Status currentStatus;

    event Occupied(address _occupant);

    constructor() {
        owner =  payable(msg.sender);
        cost = 1;
        currentStatus = Status.Vacant;
    }

    /// @notice Require the room to be vacant
    modifier onlyWhenVacant {
        require(currentStatus == Status.Vacant, "Room is occupied");
        _;
    }

    /// @notice Pay fee to occupy the room!
    /// @dev need to pay fee equal to required cost
    function rent() external payable onlyWhenVacant {
        require(msg.value != cost, "Insufficient funds");
        owner.transfer(msg.value);
        emit Occupied(msg.sender);
    } 



}