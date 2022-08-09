#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#%% import libraries

import os
import json
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st
import datetime
import calendar
# %%
load_dotenv()

# %% Define and connect a new Web3 provider
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))

# %% ################################################################################
# Contract Helper function:
# 1. Loads the contract once using cache
# 2. Connects to the contract using the contract address and ABI
#####################################################################################


@st.cache(allow_output_mutation=True)

def load_contract():

    # Load the contract ABI
    with open(Path('/Users/hannahtudo/UofT/project_3_Real_Estate/houseTrading_abi.json')) as f:
        houseTrading_abi = json.load(f)

    # Set the contract address (this is the address of the deployed contract)
    contract_address = os.getenv("SMART_CONTRACT_ADDRESS")

    # Get the contract
    contract = w3.eth.contract(
    address=contract_address,
    abi=houseTrading_abi
    )

    return contract


# %% Load the contract
contract = load_contract()

#%%######################################################
# User input the required trade details
#########################################################


st.title("Enter trade required information")
firstName = st.text_input("Enter your first name")
lastName = st.text_input("Enter your last name")
address = st.text_input("Enter your wallet address")
tradeType = st.selectbox("Choose your trade type", ['Long', 'Short'])
limitPrice = st.number_input("Enter your limit price", )
limitPrice = int(limitPrice)
tradeLimit = st.selectbox("Choose your max loss in eth", ['1','5','10','15','20','30','40','50','100','500','1000','10000'])
tradeLimit = int(tradeLimit)
contractMonth = st.selectionbox("Enter your contract month", ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'])
contractYear = st.number_input("Enter your contract year", )
contractYear = int(contractYear)
lastDOM = calendar.monthrange(contractYear, contractMonth)[1]
expDate = datetime.datetime(contractYear, contractMonth,lastDOM)

city = ['','Central Toronto', 'Central Toronto-Alexandra Park', 'Central Toronto-Bay Street Corridor', 'Central Toronto-Forest Hill',
        'Toronto Old York', 'Toronto Old York-Baby Point','Toronto Scarborough-Guildwood','Miami, FL', 'St.Petersburg, FL', 
        'Key West, FL', 'Los Angeles, CA', 'Anaheim, CA', 'Beverly Hills, CA', 'Manhattan, NY', 'Brooklyn, NY']
neighborhood = st.selectbox("Choose your neighborhood", city)

if st.button("Submit Trade"):     
    
    # Inputting user's entered info into the contract
    txHash = contract.functions.SetUserInfo(
            firstName, lastName, address, tradeType, limitPrice, tradeLimit, neighborhood, expDate).transact({'from': address, 'gas': 1000000}
            )
    receipt = w3.eth.waitForTransactionReceipt(txHash)
    st.write("Transaction receipt mined:")
    st.write(dict(receipt))
    
    # Depositing max loss amount from user's address into the contract
    # Convert eth amount to Wei
    wei_value = w3.toWei(tradeLimit, "ether")
    
    w3.eth.sendTransaction(
        {"from": address,
       "to": contract.address,
       "value": wei_value,
    })    
    
    
    
    #import time
    #time.sleep(10)
    #st.write(contract.functions.GetUserInfo(address).call())
st.markdown("---")                                                                                        
    
                                                                                        
    
#contract.functions.matchBuySell().transact()



