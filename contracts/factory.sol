// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.8;

// import our child contract
import "./miller.sol";
import "./clone.sol";

contract Factory is CloneFactory {
    // stores an array of all child contract
    Karoke[] public karokeArray;
    address public masterContract;
    address public Owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    


    constructor(address _masterContract) {
        masterContract = _masterContract; 
    }

    modifier superAd(){
        require (msg.sender == Owner, "stop");
        _;
    }

    event DataStored(address createdClubAddress);

    function createClub() external superAd{
        Karoke session = Karoke(createClone(masterContract));
        karokeArray.push(session);
        emit DataStored(address(session));
    }
}
