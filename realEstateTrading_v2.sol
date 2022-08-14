// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.9.0;  // must use this version in order to iterate mapping

/*
- This contract will match a long and short real estate transaction, it will then calculate the settlement amount for that trade and it transfer the eth to the rightful winner
  of that trade.  The specific term of the real estate deal is one address is Long and another address is Short of a of a chosen location of real estate at a agreed price for future
  settlement date.  A official released price of the real estate for that location is assumed for that settlement.  This price will then compare to the agreed trade price by two
  addresses.  A settlement function will calculate the settlement amount and will transfer the amount to the rightful winner of the trade.
- The flow of the code is organized in the followings:
  A struct is declared to hold user's inputs 
  A set function to set user's input and stored them in array
  A user will trigger of settlement process from an input on the front
  Settlement will begin by locate the array index of the trade that wish to settle.  Each record in an array will be compared to the settlement trade to find a match.  Once a match is
  found payment is calculated and transfer to the right address.
  Once a trade has settled a mapping of trades will be updated.
*/

contract HouseTrading
{   
    constructor () payable public {}
    
    function getSettleAmount(uint usdSettlemAmount) private pure returns (uint) {
        uint usdEthPrice = 214139672966;
        uint usdEth = usdEthPrice * 1e10;
        uint usd = usdSettlemAmount * (10**18);
        uint weiSettlementAmount = (usd *(10**18))/ usdEth;
        return weiSettlementAmount;
    }
    
    function min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }

    function max(uint x, uint y) private pure returns (uint) {
        return x >= y ? x : y;
    }

    // Create structure to hold user's trade info:
    
    struct UserInfo 
    {
        string firstName;
        string lastName;
        address payable tradeAddress;
        uint tradeID;
        string tradeType;
        uint limitPrice; 
        uint maxLoss; 
        uint expDate; 
        string area;
    }

    UserInfo[] public userinfo;
    
    function SetUserInfo( 
        string memory _firstName, 
        string memory _lastName, 
        address payable _tradeAddress, 
        uint _tradeID,
        string memory _tradeType, 
        uint _limitPrice, 
        uint _maxLoss, 
        uint _expDate,
        string memory _area
    ) public {
        userinfo.push(UserInfo
        (
            _firstName, 
            _lastName, 
            _tradeAddress, 
            _tradeID,
            _tradeType, 
            _limitPrice,
            _maxLoss, 
            _expDate,
            _area
        )
        );
    }

    // This function accepts a userID and returns the index of the array that holds all owner's trade details.  
    // the index will then be used to verify and match with other trades and send payment accordingly.
    uint ownerIndex = 9999999999;
    function foundOwner(uint ownerTradeID) 
        public returns(uint) {
        for(uint i = 0; i < userinfo.length; i++){
            if(userinfo[i].tradeID == ownerTradeID){
                ownerIndex = i;
                return ownerIndex;
            }       
        }
       
    }

    // This function will map the pair of trades that have been settled.  It will this mapping to determine whether a pair of trades are active or settled.
    mapping(uint => mapping(uint => bool)) public settledIndexPairs;
    function tradeSettledIndex(uint index1, uint index2) public {
        settledIndexPairs[index1][index2] = true;
        settledIndexPairs[index2][index1] = true; 
    }

    bool noMatch = false;
    bool allSettled = false;
    bool onlyOne = false;
    bool noTradeReg = false;
    bool depletedDeposit = false;
    bool [] tradeStatus;
    
    function getTradeStatus(bool _noMatch, bool _allSettled, bool _onlyOne, bool _noTradeReg, bool _depletedDeposit) public returns(bool [] memory){
        return tradeStatus = [_noMatch, _allSettled, _onlyOne, _noTradeReg, _depletedDeposit];
    }
    
    // Create nested map to hold info about real estate areas:  We just hard code this section for testing purpose.
    
    string [] areaLocation =["Beverly Hills, CA", "Key West, FL"];
    uint [] areaPrice = [2801900000000000000, 2801900000000000000];
    uint [] areaDate = [1672462800,1703998800];

    mapping(string => mapping(uint => uint)) public housePrice;
    function setHouseInfo() public {
        for(uint i = 0; i < areaLocation.length; i++){
            for(uint j = 0; j < areaLocation.length; j++){
                housePrice[areaLocation[i]][areaDate[j]] = areaPrice[i];
            }  
        }
    }

    /*
    This function will accept addresses for the two trade participants.  It retrieves the average sold price for the area
    that both participants chose, it does this by using the nested mapping.  It will output the winner and loser's address and
    the settlement amount.  The function ensure that settlement will be within the account's max loss, it uses other 
    function to convert USD to Wei.  It uses utility function to calculate the absolute and min value.  
    */
    struct tradeVariables {
        uint dateMapping;
        uint _price;
        uint _limitPrice;
        uint _settlementPrice;
        uint weiSettleAmount;
        uint _settlementMaxLoss;
    }

    function tradePayout(
        uint index1, uint index2
        ) view public returns(
            address payable, address payable, uint, uint
            )
        {
        
        tradeVariables memory _tradeVariables;
        string memory areaMapping = userinfo[index1].area;
        _tradeVariables.dateMapping = userinfo[index1].expDate;
        _tradeVariables._price = housePrice[areaMapping][_tradeVariables.dateMapping];
        _tradeVariables._limitPrice = userinfo[index1].limitPrice;
        _tradeVariables._settlementPrice = max(_tradeVariables._price,_tradeVariables._limitPrice) - min(_tradeVariables._price,_tradeVariables._limitPrice);
        uint winnerSettleAmount;
        
        _tradeVariables.weiSettleAmount = getSettleAmount(_tradeVariables._settlementPrice);
        _tradeVariables._settlementMaxLoss = min(userinfo[index1].maxLoss, userinfo[index2].maxLoss);
        address payable winnerAddress;
        address payable loserAddress;
        uint  loserIndex;

        if(_tradeVariables._price > _tradeVariables._limitPrice){

            if(keccak256(abi.encodePacked(userinfo[index1].tradeType)) == keccak256(abi.encodePacked("Long"))){
                // _address1 is the winner and _address2 is the loser in the trade
                winnerAddress = userinfo[index1].tradeAddress;
                loserAddress = userinfo[index2].tradeAddress;
                loserIndex = index2;
                winnerSettleAmount = min(_tradeVariables.weiSettleAmount, _tradeVariables._settlementMaxLoss);
            }
            else{
                // _address2 is the winner and _address1 is the loser in the trade
                winnerAddress = userinfo[index2].tradeAddress;
                loserAddress = userinfo[index1].tradeAddress;
                loserIndex = index1;
                winnerSettleAmount = min(_tradeVariables.weiSettleAmount, _tradeVariables._settlementMaxLoss);
            }
        }
        else{
            if(keccak256(abi.encodePacked(userinfo[index1].tradeType)) == keccak256(abi.encodePacked("Short"))){
                // _address1 is the winner and _address2 is the loser in the trade
                winnerAddress = userinfo[index1].tradeAddress;
                loserAddress = userinfo[index2].tradeAddress;
                loserIndex = index2;
                winnerSettleAmount = min(_tradeVariables.weiSettleAmount, _tradeVariables._settlementMaxLoss);

            }
            else{
                // _address2 is the winner and _address1 is the loser in the trade
                winnerAddress = userinfo[index2].tradeAddress;
                loserAddress = userinfo[index1].tradeAddress;
                loserIndex = index1;
                winnerSettleAmount = min(_tradeVariables.weiSettleAmount, _tradeVariables._settlementMaxLoss);
            }
        }

        return(winnerAddress, loserAddress, winnerSettleAmount,loserIndex);
    }

    /*
    This function accepts the winner's address, loser's address, settle amount.  It withdraw the settle amount from the 
    contract and transfer to the winner's wallet address.  It'll then reduce the loser's MaxLoss field by the settlemt amount.
    */

    function tradeSettlement(uint index1, uint index2) public {
        address payable winnerAddress;
        address payable loserAddress;
        uint tradePayment;
        uint maxPayment;
        uint loserIndx;
        uint loserMaxBal = 0;
        
        (winnerAddress, loserAddress, tradePayment, loserIndx) = tradePayout(index1, index2);

        maxPayment = min(userinfo[loserIndx].maxLoss, tradePayment);
        withdraw(tradePayment, winnerAddress);

        loserMaxBal = userinfo[loserIndx].maxLoss - maxPayment;
        userinfo[loserIndx].maxLoss = loserMaxBal;
    }
    
    function matchBuySell(uint ownerTradeID) public {
        
        ownerIndex = foundOwner(ownerTradeID);
        
        
        if (userinfo.length == 1) {
            onlyOne = true;
        }
        if (ownerIndex == 9999999999){
           noTradeReg = true;
        }
        if(userinfo[ownerIndex].maxLoss <= 0){
            depletedDeposit = true;
        }
        
        require(userinfo.length > 1, "You're the only participant in the contract so far...");
        require(ownerIndex != 99999999999, "You don't have a trade registered");
        require(userinfo[ownerIndex].maxLoss > 0, "Your full deposited has been depleted from the contract");
        
        for(uint i = 0; i < userinfo.length; i++){
                
            if(i != ownerIndex){   

                if(settledIndexPairs[i][ownerIndex] == false && settledIndexPairs[ownerIndex][i] == false){

                    if(
                        keccak256(abi.encodePacked(userinfo[i].area)) == keccak256(abi.encodePacked(userinfo[ownerIndex].area))
                        && keccak256(abi.encodePacked(userinfo[i].tradeType)) != keccak256(abi.encodePacked(userinfo[ownerIndex].tradeType))
                        && userinfo[i].expDate == userinfo[ownerIndex].expDate
                        && userinfo[i].limitPrice == userinfo[ownerIndex].limitPrice
                        )
                        {
                        tradeSettlement(i, ownerIndex);
                        
                        tradeSettledIndex(i, ownerIndex);

                        allSettled = true;
                        
                    }
                    else {
                        noMatch = true; // haven't found a match for this trade
                    }
                }
                else{
                    allSettled = true;
                }
            }   
        }
        tradeStatus = [noMatch, allSettled, onlyOne, noTradeReg, depletedDeposit];
        getTradeStatus(noMatch, allSettled, onlyOne, noTradeReg, depletedDeposit);
    }
    
    function deposit() public payable {}
    
    function contractBalance() view public returns(uint) {
        return address(this).balance;
    }
    function withdraw(uint amount, address payable recipient) public {
        return recipient.transfer(amount);
    }
    
    fallback() external payable {}

    function GetUserInfo(uint indx) 
    public view returns (
        string memory, 
        string memory, 
        address payable, 
        string memory,
        uint, 
        uint,
        uint,
        string memory
        ) 
        {
        UserInfo memory _userinfo = userinfo[indx];
        return(
            _userinfo.firstName, 
            _userinfo.lastName, 
            _userinfo.tradeAddress, 
            _userinfo.tradeType, 
            _userinfo.limitPrice, 
            _userinfo.maxLoss, 
            _userinfo.expDate,
            _userinfo.area
        );
    }

}
