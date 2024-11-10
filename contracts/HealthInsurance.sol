// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract HealthInsurance{

address public SmartContractOwner; // The owner of the smart contract

struct person{
bool authorised;
string name;
uint insuranceAmount;
}

mapping(address=>person) public personmapping; // Mapping of user addresses to their details
mapping(address=>bool) public doctormapping ; //Mapping doctor address to boolean for validation

constructor() {
SmartContractOwner = msg.sender;
}

modifier onlySmartContractOwner(){
require(SmartContractOwner == msg.sender);
_;
}

  function  setDoctor(address _address) public onlySmartContractOwner{
        require(!doctormapping[_address]);
        doctormapping[_address] = true;
    }

 function setPerson(string memory _name,uint _insuranceAmount) public onlySmartContractOwner returns (address){
        address uid = address(bytes20(sha256(abi.encodePacked(msg.sender,block.timestamp))));
        require(!personmapping[uid].authorised);
        personmapping[uid].authorised = true;
        personmapping[uid].name = _name;
        personmapping[uid].insuranceAmount  = _insuranceAmount;
        
        return uid;
    }
    
    function claimInsurance(address _uid,uint _insuranceAmountUsed) public returns (string memory){
        require(!doctormapping[msg.sender]);
        if(personmapping[_uid].insuranceAmount < _insuranceAmountUsed){
            revert();
        }
        
        personmapping[_uid].insuranceAmount -= _insuranceAmountUsed;
        return "Amount debited from your insurance";
    }
}