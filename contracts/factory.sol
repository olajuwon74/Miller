// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.8;

// import our child contract
import "./miller.sol";
import "./clone.sol";

contract Factory is CloneFactory {
    // stores an array of all child contract
    Karoke[] public karokeArray;

    address public masterContract;


    constructor(address _masterContract) {
        masterContract = _masterContract;
    }

    event DataStored(address createdClubAddress);

    function createClub() external {
        Karoke session = Karoke(createClone(masterContract));
        karokeArray.push(session);
        emit DataStored(address(session));
    }
}
