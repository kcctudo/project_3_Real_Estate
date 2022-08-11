#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#%% import libraries

import os
#import json
from realEstate import w3, load_contract, send_transaction, get_balance, getUsdWei, getCalendarEpoch
from web3 import Web3
#from pathlib import Path
#from dotenv import load_dotenv
import streamlit as st
import time

# %%
#load_dotenv()

# %% Define and connect a new Web3 provider
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))


# %% Load the contract
contract = load_contract()

#%%######################################################
# User input the required trade details                 
#########################################################

#@st.cache(allow_output_mutation=True)

st.title("Enter trade required information")
firstName = st.text_input("Enter your first name")
lastName = st.text_input("Enter your last name")
address = st.text_input("Enter your wallet address")
tradeType = st.selectbox("Choose your trade type", ['Long', 'Short'])

limitPrice = st.number_input("Enter your limit price in dollar", )
limitPrice = getUsdWei(int(limitPrice))

tradeLimit = st.number_input("Choose your max loss in dollar", )
tradeLimit = getUsdWei(int(tradeLimit))

contractMonth = st.selectbox("Enter your contract month", ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'])
contractYear = st.selectbox("Enter your contract year", ['2022', '2023', '2024', '2025', '2026'])
expDate = getCalendarEpoch(contractYear, contractMonth)

city = ['','Central Toronto', 'Central Toronto-Alexandra Park', 'Central Toronto-Bay Street Corridor', 'Central Toronto-Forest Hill',
        'Toronto Old York', 'Toronto Old York-Baby Point','Toronto Scarborough-Guildwood','Miami, FL', 'St.Petersburg, FL', 
        'Key West, FL', 'Los Angeles, CA', 'Anaheim, CA', 'Beverly Hills, CA', 'Manhattan, NY', 'Brooklyn, NY']

neighborhood = st.selectbox("Choose your neighborhood", city)

if st.button("Submit Info"):     
    
    # Inputting user's entered info into the contract
    txHash = contract.functions.SetUserInfo(
            firstName, lastName, address, tradeType, limitPrice, tradeLimit, expDate, neighborhood).transact(
                {'from': address, 'gas': 1000000}
                )
    receipt = w3.eth.waitForTransactionReceipt(txHash)
    st.write("Transaction receipt mined:")
    st.write(dict(receipt))
    

if st.button("Deposit your max loss to contract"):
    # deposit account's trade limit to the contract
    time.sleep(5)
    transaction_hash = send_transaction(address, contract.address, tradeLimit)

    # Display the Etheremum Transaction Hash
    st.text("\n")
    st.text("\n")
    st.markdown("## Ethereum Transaction Hash:")

    st.write(transaction_hash)

if st.button("Check contract balance"):
    contrBalance = get_balance(w3, contract.address)
    st.text("")
    st.write("Contract balance(eth): " + str(contrBalance))
    
if st.button("Confirm your trade"):
    
    # Call setHouseInfo to set up a hard code mapping for city and avg home price.  Want to hook up to api later
    time.sleep(5)
    contract.functions.setHouseInfo().transact({'from': address, 'gas': 1000000})
    
    # Call the following functions to perform mapping for user
    time.sleep(5)
    contract.functions.setUserLimitPrice(address, neighborhood, limitPrice).transact({'from': address, 'gas': 1000000})
    time.sleep(5)
    contract.functions.setUserMaxLoss(address, neighborhood, tradeLimit).transact({'from': address, 'gas': 1000000})
    time.sleep(5)
    contract.functions.setUserMaxLoss(address, neighborhood, tradeLimit).transact({'from': address, 'gas': 1000000})
    time.sleep(5)
    
if st.button("Your trade's settlement"):
    checkBool = contract.functions.matchBuySell().transact({'from': address, 'gas': 1000000}) 
    if checkBool:
        st.text("\n")
        st.write("Check your wallet")
    else:
        st.text("\n")
        st.write("There is no match for your deal")
    
st.markdown("---")                                                                                       
    
                                                                                        
    
    



