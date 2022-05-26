// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.8;

// import our child contract
import "./miller.sol";
import "./clone.sol";

contract Factory is CloneFactory {
    // stores an array of all child contract
    Karoke[] public KarokeArray;
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
        KarokeArray.push(session);
        emit DataStored(address(session));
    }

    // function getChildren() external view returns (Karoke[] memory) {
    //     return KarokeArray;
    // }

    // function gfSetClub(
    //     uint256 _KarokeArray,
    //     uint128 numberOfPeople,
    //     uint128 perPeople
    // ) public {
    //     Karoke(address(KarokeArray[_KarokeArray])).createClub(
    //         numberOfPeople,
    //         perPeople
    //     );
    // }
}
