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