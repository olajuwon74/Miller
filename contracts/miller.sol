// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";


contract RandomNumberGen is VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomNumber;
    uint[] expandedValues;



    address addressK;
    function setAdress(address add) external{
        addressK = add;
    }

    constructor(
        address _vrfCoordinator,
        address _link,
        bytes32 _keyHash,
        uint256 _fee
    ) VRFConsumerBase(_vrfCoordinator, _link) {
        keyHash = _keyHash;
        fee = _fee;
    }

    event ChosenOnes(uint[] expandedValues);

        function getRandomness() public returns (bytes32) {
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Inadequate Link to fund this transaction"
        );
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        randomNumber = randomness;
    }


    // To get the list of random numbers between the range of the _index (the amount of people who indicated to join the karokee session)
    // NumberSelected is the amount of candidates to be chosen
    // epandedValues returns the array of numbers in a range.

     function getRandomAddresses(uint256 _randomNumber, uint numberSelected, uint _index) public returns (uint256[] memory _expandedValues){
         expandedValues = _expandedValues;
         assert(numberSelected < _index);
         randomNumber = _randomNumber;
         Karoke karoke = Karoke(addressK);
        _index = karoke.viewTotalApplicants();
        expandedValues = new uint256[](numberSelected);
        for(uint256 i = 0; i < numberSelected; i++){
            expandedValues[i] = uint256(keccak256(abi.encode(randomNumber, i))) % _index;
        }

        emit ChosenOnes(expandedValues);
        return expandedValues;
        
    }

}


contract Karoke{

    address payable Owner;
    uint startDate;
    uint endDate;
    uint uploadFee = 2000 wei;
    uint public balance;

    constructor(address payable _owner, uint _startDate, uint _endDate){
        Owner = _owner;
        startDate = _startDate;
        endDate = _endDate;
    }
    modifier onlyOwner(){
        require(Owner == msg.sender, "Not Allowed");
        _;
    }
    struct AddressesIndicated{
        address singerAdress;
        bool added;
    }

    struct SelectedAddresses{
        address secAddress;
        bool chosen;
    }

    AddressesIndicated[] Selected;

    enum Status {
        On,
        Off
    }

    uint public index = 1;
    // uint Index = 1;

    mapping(address => AddressesIndicated) public addressAdded;
    mapping(address => SelectedAddresses) public addressSelected;

    // mapping(uint => AddressesIndicated) public addAdded;
    // mapping(uint => SelectedAddresses) public addrSelected;

    event SessionIsOn(uint staDate, uint endingDate);

     function withdraw(address addr, uint amount) public onlyOwner{
        payable (addr).transfer(amount);
     }

     function indicate() public {
         assert(!addressAdded[msg.sender].added);
         AddressesIndicated storage indicated = addressAdded[msg.sender];
         indicated.singerAdress = msg.sender;
         indicated.added = true;
         index++;
     }

     function tip(address _addr, uint amount) public {
        payable (_addr).transfer(amount);
     }

     function setDate(Status _status, uint sDate, uint eDate) public onlyOwner {
         if(_status == Status.On){
            assert(eDate > sDate);
            sDate = startDate;
            eDate = endDate;
            emit SessionIsOn(sDate, eDate);
            if(eDate == eDate){
                _status = Status.Off;
            }
         }
         else{
            
         }
         
     }

     function upload() payable public {
         assert(addressSelected[msg.sender].chosen);
         require(msg.value >= uploadFee);
         balance+= msg.value;
     }

    function viewTotalApplicants () public view returns (uint) {
      return index;
    }

     function finalist(uint _select, uint _select2, uint _select3, uint _select4, uint _select5 ) public onlyOwner returns (address, address, address, address, address){
         SelectedAddresses storage selectee = addressSelected[Selected [_select].singerAdress];
         selectee.secAddress = Selected [_select].singerAdress;
         selectee.secAddress = Selected [_select2].singerAdress;
         selectee.secAddress = Selected [_select3].singerAdress;
         selectee.secAddress = Selected [_select4].singerAdress;
         selectee.secAddress = Selected [_select5].singerAdress;
        return ((Selected [_select].singerAdress), (Selected [_select2].singerAdress), (Selected [_select3].singerAdress), (Selected [_select4].singerAdress), (Selected [_select5].singerAdress));
        
    }
}