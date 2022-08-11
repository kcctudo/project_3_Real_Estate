// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.9.0;  // must use this version in order to iterate mapping

//import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract HouseTrading

    
{   /*
    This function connects to an external site to retrieve real time eth price in usd from ethUsdPriceFeed.  It will then
    accepts USD and convert into eth
    
    uint256 public usdSettlemAmount;
    AggregatorV3Interface internal PriceFeed;
    constructor () {
        priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    }

    // need to include minimum of $50 usd requirement later

    function getSettleAmount(int256 usdSettlemAmount) public view returns (uint256) {
        (, int256 usdEthPrice, , ,) = ethUsdPriceFeed.latestRoundData();
        int256 usdEth = usdEthPrice * 1e10;
        int256 usd = usdSettlemAmount * (10**18);
        return int256(usd / usdEth);
    }
    
    int256 weiSettlementAmount = getSettleAmount(usdSettlemAmount);
    */

    function getSettleAmount(uint usdSettlemAmount) private pure returns (uint) {
        uint usdEthPrice = 214139672966;
        uint usdEth = usdEthPrice * 1e10;
        uint usd = usdSettlemAmount * (10**18);
        uint weiSettlementAmount = (usd *(10**18))/ usdEth;
        return weiSettlementAmount;
    }
    
    //function abs(int256 x) private pure returns (uint) {
    //    int256 y;
    //    y = x >= 0 ? x : -x;
    //    return uint(y);
    //}

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
        string tradeType;
        uint limitPrice; // in dollar
        uint maxLoss; // in wei - make sure to add a requirement that MaxLoss has to be at least $50 in order to trade
        uint expDate; // 
        string area;
    }

    UserInfo[] public userinfo;
    
    //mapping (address => UserInfo[]) public infoByUser;

    function SetUserInfo( 
        string memory _firstName, 
        string memory _lastName, 
        address payable _tradeAddress, 
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
            _tradeType, 
            _limitPrice,
            _maxLoss, 
            _expDate,
            _area
        )
        );
    }


    /*
    This function creates a nested mapping for participant's addresses to its trade's details.  A nested mapping is
    is required as one wallet address can have different values for a variable.  For example, a same wallet address
    can have a tradeType Long for one area and short for a different area
    mapping(address => string) public userTradeType.

    Should mention about the challenge associated with multiple variables and nested mapping

    */

    mapping(address => mapping(string => string)) public tradeType;
    function setUserTradeType(
        address userAddress, string memory userArea, string memory userTradeType
        ) 
        public {
        tradeType[userAddress][userArea] = userTradeType;
    }

    mapping(address => mapping(string => int256)) public limitPrice;
    function setUserLimitPrice(
        address userAddress, string memory userArea, int256 userLimitPrice
        ) 
        public {
        limitPrice[userAddress][userArea] = userLimitPrice;
    }

    mapping(address => mapping(string => int256))  public maxLoss;
    function setUserMaxLoss(
        address userAddress, string memory userArea, int256 userMaxLoss
        ) 
        public {
        maxLoss[userAddress][userArea] = userMaxLoss;
    }

    mapping(address => mapping(string => int256))  public expDate;
    function setUserExpDate(
        address userAddress, string memory userArea, int256 userExpDate
        ) 
        public {
        expDate[userAddress][userArea] = userExpDate;
    }



    // Create nested map to hold info about real estate areas:

    //uint areaDate;
    //uint areaPrice;
    //string areaLocation;
    
    
    string [] areaLocation =["Beverly Hills, CA", "Key West, FL"];
    uint [] areaPrice = [2801900000000000000, 2801900000000000000];
    uint [] areaDate = [123,123];

    mapping(string => mapping(uint => uint)) public housePrice;
    function setHouseInfo()
        //string memory area, uint price, uint date 
        //) 
        public {
            for(uint i = 0; i < areaLocation.length; i++){
                //housePrice[area][date] = price;
                housePrice[areaLocation[i]][areaDate[i]] = areaPrice[i];
    }       }

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
    
    // limitPrice 466985000000000000
    // home price 2801900000000000000
    // maxLoss 4669800000000000000
    // 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 - acc with index 0
    // 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 - acc with index 1

        /*
        uint dateMapping = userinfo[index1].expDate;
        uint _price = housePrice[areaMapping][dateMapping];
        uint _limitPrice = userinfo[index1].limitPrice;
        uint _settlementPrice = max(_price,_limitPrice) - min(_price,_limitPrice);
        uint winnerSettleAmount;
        uint weiSettleAmount = getSettleAmount(_settlementPrice);
        uint _settlementMaxLoss = min(userinfo[index1].maxLoss, userinfo[index2].maxLoss);
        */

        _tradeVariables.dateMapping = userinfo[index1].expDate;
        _tradeVariables._price = housePrice[areaMapping][_tradeVariables.dateMapping];
        _tradeVariables._limitPrice = userinfo[index1].limitPrice;
        _tradeVariables._settlementPrice = max(_tradeVariables._price,_tradeVariables._limitPrice) - min(_tradeVariables._price,_tradeVariables._limitPrice);
        uint winnerSettleAmount;
        //_tradeVariables.weiSettleAmount = getSettleAmount(_tradeVariables._settlementPrice);
        _tradeVariables.weiSettleAmount = _tradeVariables._settlementPrice;
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
        uint loserIndx;
        (winnerAddress, , , ) = tradePayout(index1, index2);
        ( , loserAddress, , ) = tradePayout(index1, index2);
        ( , , tradePayment , ) = tradePayout(index1, index2);

        withdraw(tradePayment, winnerAddress);
        userinfo[loserIndx].maxLoss = --tradePayment;
    }
    //returns(
     //       address payable, address payable, uint, uint
    
    function deposit() public payable {}
    
    function contractBalance() view public returns(uint) {
        return address(this).balance;
    }
    function withdraw(uint amount, address payable recipient) public {
        return recipient.transfer(amount);
    }
    
    
    function matchBuySell() public returns(bool){
        //UserInfo storage _userinfo = userinfo[0];
        // Loop through userinfo array
        for(uint i = 0; i < userinfo.length; i++){
            for(uint j = 0; j < userinfo.length; j++){
                if(i != j)
                {
                    if(
                        keccak256(abi.encodePacked(userinfo[i].area)) == keccak256(abi.encodePacked(userinfo[j].area))
                       && keccak256(abi.encodePacked(userinfo[i].tradeType)) != keccak256(abi.encodePacked(userinfo[j].tradeType))
                       && userinfo[i].expDate == userinfo[j].expDate
                       && userinfo[i].limitPrice == userinfo[j].limitPrice
                       )
                       {
                        
                        // check if account has enough money to settle the trade
                        // delay the transaction so account can very the settlement details
                        // depletes the losing account by the withdrawal's amount
                        
                        //withdraw(3000000000000000000, userinfo[j].tradeAddress);
                        
                        tradeSettlement(i, j);
                        
                        return true;
                        
                        }
                    else {
                        return false;
                    }
                }
            }
        }
    }

    //function runOtherFunction() public {
        //withdraw(3000000000000000000, userinfo[0].tradeAddress);
    //    matchBuySell();
    //}
    
    //function() external payable {}


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