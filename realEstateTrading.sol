ragma solidity >0.5.0 <0.9.0;

contract HouseTrading
{
    // Create structure to hold user's trade info:
    struct UserInfo 
    {
        string FirstName;
        string LastName;
        address payable MyAddress;
        string TradeType;
        uint LimitPrice; // in dollar
        uint MaxLoss; // in ether
        uint ExpDate; // 
        string Area;
    }

    UserInfo[] public userinfo;
    mapping (address => UserInfo[]) public infoByUser;

    // Create struct to hold info about real estate areas:
    uint date;
    uint price;
    string area;
    string _area;
    uint memory _date;
    uint memory _price;
    uint memory _limitPrice;
    uint memory _settlementPrice;

    mapping(string => mapping(uint => uint)) public housePrice;
    
    function setHouseInfo(string memory _area, uint _price, uint _date) public {
        housePrice[_area][_date] = _price;
    }

    // Compare Limit price with official average price.  Check for address trade direction(Long/Short) and transfer
    // the settlement to the appropriate address(winner in the trade).  Reduce the loser's max loss by the settlement amount 
    function tradePayout(address payable _address1, address payable _address2) view public returns(address payable, uint){
        _area = _address1.Area;
        _date = _address1.ExpDate;
        _price = housePrice[_area][_date];
        _limitPrice = _address1._limitPrice;
        _settlementPrice = _price - _limitPrice;

        if(_settlementPrice > 0){
            if(keccak256(abi.encodePacked(_address1.TradeType)) == "Long"){
                // _address1 is the winner
            }
            else{
                // _address2 is the winner
            }
        }
        else{
            if(keccak256(abi.encodePacked(_address1.TradeType)) == "Short"){
                // _address1 is the winner
            }
        }





    }
    
    function SetUserInfo( 
        string memory _FirstName, 
        string memory _LastName, 
        address payable _MyAddress, 
        string memory _TradeType, 
        uint _LimitPrice, 
        uint _MaxLoss, 
        uint _ExpDate,
        string memory _Area
    ) public 
    {
        userinfo.push(UserInfo
        (
            _FirstName, 
            _LastName, 
            _MyAddress, 
            _TradeType, 
            _LimitPrice,
            _MaxLoss, 
            _ExpDate,
            _Area
        )
        );

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
                        // make sure both accounts have the same expired date   
                        // check make sure if account has not expired
                        // check if account has enough money to settle the trade
                        // delay the transaction so account can very the settlement details
                        // only withdraw the balance of the amount that equates to the losing account's balance
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


    
    function() external payable {}

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