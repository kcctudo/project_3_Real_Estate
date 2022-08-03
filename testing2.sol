pragma solidity ^0.5.0;

contract HouseTrading{
    struct UserInfo {
    string FirstName;
    string LastName;
    address MyAddress;
    string TradeType;
    uint TradeLimit;
    string Area;
    }
    mapping (address => UserInfo) AllUsers;

    function SetUserInfo(string memory _FirstName, string memory _LastName, address _MyAddress, 
        string memory _TradeType, uint _TradeLimit, string memory _Area) public {
        
        AllUsers[_MyAddress].FirstName = _FirstName;
        AllUsers[_MyAddress].LastName = _LastName;
        AllUsers[_MyAddress].TradeType = _TradeType;
        AllUsers[_MyAddress].TradeLimit = _TradeLimit;
        AllUsers[_MyAddress].Area = _Area;
        
        // require(TradeLimit < 100, "Wallet doesn't not have sufficient fund");
    }

    function GetUserInfo(address _MyAddress) public view returns (string memory, string memory, string memory, uint, 
        string memory) {
        return(AllUsers[_MyAddress].FirstName, AllUsers[_MyAddress].LastName, AllUsers[_MyAddress].TradeType, 
        AllUsers[_MyAddress].TradeLimit, AllUsers[_MyAddress].Area);
    }
}