# project-3---Real-Estate# project-3---Real-Estate
# Housing Futures Smart Contract
Use this application to create a smart contract with another investor around the world on the blockchain. Would you like to hedge the value of your home in worry that the housing market will dip? Are you looking to invest in the performance of other housing markets without buying a house? Look no futher, make a trade!

### How It Works
Our smart contract acts as an autonomous third party that allows investors to create future contracts in the housing market. Each investor will use our streamlit front end application to create an open trade containing the terms of their trade. When the user hits the submit button, their open trade will be matched with other open trades that are held within the smart contract. The smart contract will check that each investor has the required funds to make the trade and hold those funds in escrow until the trade is complete. Upon completion of the trade, the smart contract will remit all funds to the winner of the future contract.

### An Example
Lets say Anthony owns a house in Los Angeles, California. The housing market in LA has sky rocketed and Anthony's house has increased in value by $1,000,000. Anthony is worried that the value of his house will decrease by $500,000 over the next three months. Ruth is a Canadian real estate investor who would like to invest in the LA housing market and has $500,000 which is not enough to purchase a home there. Anthony and Ruth will enter into a futures contract betting on the average sale price of homes in the LA area. Anthony will bet that the value of the average house will decrease by $500,000 while Ruth will bet that the value will increase by $500,000 in the next three months. If the average sale price of homes in LA increases by $500,000, Ruth will win the trade and earn that amount. If the housing price decreases by $500,000, Anthony will win the trade and earn $500,000 (therefore hedging the value of his home).

### Why Use Blockchain?
Blockchain is immutable, transparent, and decentralized. Immutability means that when investors make a trade on the blockchain, no one can change the terms of the trade after it has been agreed to. Because the blockchain is transparent, everyone can see that the trade has been agreed to, what the terms of the trade are, and who won the trade. Finally, the blockchain is decentralized meaning that no third party is involved when setting up the trade, holding funds in escrow, or sending the profits to the winner of the trade (the smart contract has functions for each of these actions).

### Technologies Used (Installation Requirements)
- APIFY (install)
- Streamlit (install)
- Solidity
- Remix
- Python (install)
- Numpy (install)
- Pandas (install)
- Dotenv (install)
- Json (install)
- Web3 (install)
- Pathlib (install)
- Ganache (install)
- Metamask (install)

### Development
Our application development consists of a streamlit frontend that collects a users trade information and sends that information to the smart contract. The smart contract was developed using the Solidty programming language and tested, compilled, and deployed in RemixID on a local blockchain network using Ganache, and Metamask. Once tested on Ganache, we deployed the contract on an injected Web3 test network called Rinkeby. 

### Development Challenges
Connecting the streamlit to our application required us to load our contract into streamlit.


Because of the volume of user information, we used nested mappings to create a data structure that we could access the contents of. 


To iterate through open trades that were stored as mappings, we created nested if statements that checked if any of the trades matched one another in the form of an array.  If there was a match, the function returned the wallet addresses of the investors to see who wins the trade and remit the respective payments.

We found that some pragma versions were able to iterate though mappings while others were not. We also found that some pragma versions were not able to pay addresses.

### Code description
This contract will match a long and short real estate transaction, it will then calculate the settlement amount for that trade and it transfer the eth to the rightful winner of that trade.  The specific term of the real estate deal is one address is Long and another address is Short of a of a chosen location of real estate at a agreed price for future settlement date.  A official released price of the real estate for that location is assumed for that settlement.  This price will then compare to the agreed trade price by two addresses.  A settlement function will calculate the settlement amount and will transfer the amount to the rightful winner of the trade.

### The flow of the code is organized in the followings:
  A struct is declared to hold user's inputs 
  A set function to set user's input and stored them in array
  A user will trigger of settlement process from an input on the front end
  Settlement will begin by locating the array index of the trade that wish to settle.  Each record in an array will be compared to the settlement trade to   find a match.  Once a match is found payment is calculated and transfer to the right address.
  Once a trade has settled a mapping of trades will be updated to indicate that trade has been settled between the two addresses.
  
### How to run & required files:
_.env as environment variable.
houseTrading_abi.json - abi file from a deployed contract
realEstate.py - python code that runs web3 
app_v2.py - python that runs streamlit front end interface.

### Running the app
Copy _.env and saved as environment variable
Save houseTrading_abi to local
run streamlit from terminal and run app_v2.py

### Video screen shot
The video describes the flows and application of smart contract.  The video shows the front end application, where user inputs their required information for the trade.  Note that the first step Account 2 was chosen to long the trade in real estate area of Key West, FL.  The account 2 initially has 55 Eth prior the engagement of the trade.  The following users pick their trade direction as "short".  The realEstateTrading_v2.sol is the backbone of the smart contract.  In it we hard coded the official price of Key West, FL.  When a trade is updated, the contract will initiate the settlement process.  Because the official price is higher than the limit price, user1(Peter1) wins the trade against the others.  His Eth Account2 went up as Eth was transferred to the account as a payment for the trade.  The rest of the users lost.  And the settlement is higher than the the trade max loss.  Those accounts are no longer able to trade, as captured in the error message.

