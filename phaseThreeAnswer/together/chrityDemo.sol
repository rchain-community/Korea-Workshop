pragma solidity ^0.4.24;
contract Charity{
    address owner;
    mapping (address => Receiver) receiverInfo;
    mapping (address => Donator) donateInfo;
    mapping (address => Ngo) ngoInfo;
    bool[] requestBooleanArray;
    struct Receiver{
        string receiverName;
        uint request;
        uint sumRequest;
        bool requestSuccess;
    }
    struct Donator{
        string donatorName;
        uint donate;
        uint sumDonate;
    }
    struct Ngo{
        uint sumdonate;
        address[] requests;
        string[] requestsName;
    }
    function newReceiver(string _name) public{
        receiverInfo[msg.sender].receiverName=_name;
        receiverInfo[msg.sender].request=0;
        receiverInfo[msg.sender].sumRequest=0;
        receiverInfo[msg.sender].requestSuccess=false;
    }
    function newDonator(string _name) public{
        donateInfo[msg.sender].donatorName=_name;
        donateInfo[msg.sender].donate=0;
        donateInfo[msg.sender].sumDonate=0;
    }
    function newNgo() public{
        ngoInfo[msg.sender].sumdonate=0;
    }
    function setRequest(uint _value,address _ngoAddress) external{
        receiverInfo[msg.sender].request=_value;
        receiverInfo[msg.sender].sumRequest+=_value;
        ngoInfo[_ngoAddress].requests.push(msg.sender);
        ngoInfo[_ngoAddress].requestsName.push(receiverInfo[msg.sender].receiverName);
    }
    function setDonate(uint _value,address _ngoAddress) external{
        donateInfo[msg.sender].donate=_value;
        donateInfo[msg.sender].sumDonate+=_value;
        ngoInfo[_ngoAddress].sumdonate+=_value;
    }
    function getRequest(address _user)view public returns(string,uint,uint){
        return (receiverInfo[_user].receiverName,receiverInfo[_user].request,receiverInfo[_user].sumRequest);
    }
    function getDonate(address _user)view public returns(string,uint,uint){
        return (donateInfo[_user].donatorName,donateInfo[_user].donate,donateInfo[_user].sumDonate);
    }
    function ngoDistribute() payable external{
        for(uint i=0;i<ngoInfo[msg.sender].requests.length;i++){
            if(ngoInfo[msg.sender].sumdonate>=receiverInfo[ngoInfo[msg.sender].requests[i]].request){
                ngoInfo[msg.sender].sumdonate-=receiverInfo[ngoInfo[msg.sender].requests[i]].request;
                receiverInfo[ngoInfo[msg.sender].requests[i]].request=0;
                receiverInfo[ngoInfo[msg.sender].requests[i]].requestSuccess=true;
            }
        }
    }
    function getRequestSuccess(address _ngoAddress)public payable returns(bool[]){
        if(requestBooleanArray.length==ngoInfo[_ngoAddress].requests.length){
            return requestBooleanArray;
        }else{
            for(uint i=0;i<ngoInfo[_ngoAddress].requests.length;i++){
            requestBooleanArray.push(receiverInfo[ngoInfo[_ngoAddress].requests[i]].requestSuccess);
            }
        }
        return requestBooleanArray;
    }
    function getNgoHaveAmount(address _ngoAddress)view public returns(uint){
        return ngoInfo[_ngoAddress].sumdonate;
        //not yet
    }
}