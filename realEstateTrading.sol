/ SPDX-License-Identifier: MIT
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

    function getSettleAmount(int256 usdSettlemAmount) public view returns (int256) {
        int256 usdEthPrice = 214139672966;
        int256 usdEth = usdEthPrice * 1e10;
        int256 usd = usdSettlemAmount * (10**18);
        int256 weiSettlementAmount = (usd *(10**18))/ usdEth;
        return weiSettlementAmount;
    }
    
    function abs(int256 x) private pure returns (int256) {
        return x >= 0 ? x : -x;
    }

    function min(int256 x, int256 y) private pure returns (int256) {
        return x <= y ? x : y;
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

    mapping(address => mapping(string => uint)) public limitPrice;
    function setUserLimitPrice(
        address userAddress, string memory userArea, uint userLimitPrice
        ) 
        public {
        limitPrice[userAddress][userArea] = userLimitPrice;
    }

    mapping(address => mapping(string => uint))  public maxLoss;
    function setUserMaxLoss(
        address userAddress, string memory userArea, uint userMaxLoss
        ) 
        public {
        maxLoss[userAddress][userArea] = userMaxLoss;
    }

    mapping(address => mapping(string => uint))  public expDate;
    function setUserExpDate(
        address userAddress, string memory userArea, uint userExpDate
        ) 
        public {
        expDate[userAddress][userArea] = userExpDate;
    }



    // Create nested map to hold info about real estate areas:

    //uint areaDate;
    //uint areaPrice;
    //string areaLocation;
    
    mapping(string => mapping(uint => uint)) public housePrice;
    function setHouseInfo(
        string memory area, uint price, uint date
        ) 
        public {
        housePrice[area][date] = price;
    }

    /*
    This function will accept addresses for the two trade participants.  It retrieves the average sold price for the area
    that both participants chose, it does this by using the nested mapping.  It will output the winner and loser's address and
    the settlement amount.  The function ensure that settlement will be within the account's max loss, it uses other 
    function to convert USD to Wei.  It uses utility function to calculate the absolute and min value.  
    */

    function tradePayout(
        address payable _address1, address payable _address2
        ) view public returns(
            address payable, address payable, uint
            )
        {
        string memory areaMapping = userinfo[indx1].Area;
        int256 dateMapping = _address1.ExpDate;
        int256 _price = housePrice[areaMapping][dateMapping];
        int256 _limitPrice = _address1._limitPrice;
        int256 _settlementPrice = _price - _limitPrice;
        int256 winnerSettleAmount;
        int256 weiSettleAmount = getSettleAmount(abs(_settlementPrice));
        int256 _settlementMaxLoss = min(_address1.MaxLoss, _address2.MaxLoss);
        address payable winnerAddress;
        address payable loserAddress;

        if(_settlementPrice > 0){

            if(keccak256(abi.encodePacked(_address1.TradeType)) == "Long"){
                // _address1 is the winner and _address2 is the loser in the trade
                winnerAddress = _address1;
                loserAddress = _address2;
                winnerSettleAmount = min(weiSettleAmount, _settlementMaxLoss);
            }
            else{
                // _address2 is the winner and _address1 is the loser in the trade
                winnerAddress = _address2;
                loserAddress = _address1;
                winnerSettleAmount = min(weiSettleAmount, _settlementMaxLoss);
            }
        }
        else{
            if(keccak256(abi.encodePacked(_address1.TradeType)) == "Short"){
                // _address1 is the winner and _address2 is the loser in the trade
                winnerAddress = _address1;
                loserAddress = _address2;
                winnerSettleAmount = min(weiSettleAmount, _settlementMaxLoss);

            }
            else{
                // _address2 is the winner and _address1 is the loser in the trade
                winnerAddress = _address2;
                loserAddress = _address1;
                winnerSettleAmount = min(weiSettleAmount, _settlementMaxLoss);
            }
        }

        return(winnerAddress, loserAddress, winnerSettleAmount);
    }

    

    /*
    This function accepts the winner's address, loser's address, settle amount.  It withdraw the settle amount from the 
    contract and transfer to the winner's wallet address.  It'll then reduce the loser's MaxLoss field by the settlemt amount.
    */

    function tradeSettlement(address payable _address1, address payable _address2) public {
        address payable winnerAddress;
        address payable loserAddress;
        int256 tradePayment;
        (winnerAddress, ,) = tradePayout(_address1, _address2);
        (, loserAddress, ) = tradePayout(_address1, _address2);
        (, , tradePayment) = tradePayout(_address1, _address2);
        withdraw(tradePayment, winnerAddress);
        loserAddress.MaxLoss = --tradePayment;
    }
    
    
    function deposit() public payable {}
    
    function contractBalance() view public returns(uint) {
        return address(this).balance;
    }
    function withdraw(uint amount, address payable recipient) public {
        return recipient.transfer(amount);
    }
    uint public a = 100;
    //uint public dec = --a;
    function matchBuySell() public returns(bool){
        //UserInfo storage _userinfo = userinfo[0];
        // Loop through userinfo array
        for(uint i = 0; i < userinfo.length; i++){
            for(uint j = 0; j < userinfo.length; j++){
                if(i != j)
                {
                    if(
                        keccak256(abi.encodePacked(userinfo[i].Area)) == keccak256(abi.encodePacked(userinfo[j].Area))
                       && keccak256(abi.encodePacked(userinfo[i].TradeType)) != keccak256(abi.encodePacked(userinfo[j].TradeType))
                       && userinfo[i].ExpDate == userinfo[j].ExpDate
                       && userinfo[i].LimitPrice == userinfo[j].LimitPrice
                       )
                       {
                        
                        // check if account has enough money to settle the trade
                        // delay the transaction so account can very the settlement details
                        // depletes the losing account by the withdrawal's amount
                        
                        //withdraw(3000000000000000000, userinfo[j].MyAddress);
                        //userinfo[i].MaxLoss = --a;





                        
                        return true;
                        

                        }
                    else 
                        {
                        return false;
                        }
                }
            }
        }
    }


    
    //function() external payable {}

    fallback() external payable {}

    function GetUserInfo(uint indx) 
    public view returns 
        (
            string memory, 
            string memory, 
            address, 
            string memory,
            uint, 
            uint,
            string memory
        ) 
        {
        UserInfo memory _userinfo = userinfo[indx];
        return
        (
            _userinfo.FirstName, 
            _userinfo.LastName, 
            _userinfo.MyAddress, 
            _userinfo.TradeType, 
            _userinfo.LimitPrice, 
            _userinfo.MaxLoss, 
            _userinfo.Area
        );
    }

}