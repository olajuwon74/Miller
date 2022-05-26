// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.8;

// import our child contract
import "./miller.sol";
import "./clone.sol";

contract Factory is CloneFactory {
    // stores an array of all child contract
    Karoke[] public KarokeArray;

    address public masterContract;


    constructor(address _masterContract) {
        masterContract = _masterContract;
    }

    event DataStored(address createdClubAddress);

    function createClub() external {
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
