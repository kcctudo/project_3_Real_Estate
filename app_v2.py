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
tradeId = st.number_input("Enter your trade ID", )
tradeId = int(tradeId)
address = st.text_input("Enter your wallet address")
tradeType = st.selectbox("Choose your trade type", ['Long', 'Short'])

limitPrice = st.number_input("Enter your limit price in dollar", )
limitPrice = getUsdWei(int(limitPrice))

tradeLimit = st.number_input("Choose your max loss in dollar", )
tradeLimit = getUsdWei(int(tradeLimit))

contractMonth = st.selectbox("Enter your contract month", ['12'])  # Only December is available for testing purpose
contractYear = st.selectbox("Enter your contract year", ['2022', '2023'])
expDate = getCalendarEpoch(contractYear, contractMonth)

city = ['', 'Key West, FL', 'Beverly Hills, CA',]

neighborhood = st.selectbox("Choose your neighborhood", city)

if st.button("Submit Info"):     
    
    # SetUserInfo function will be called from the contract.  This function will enter the user's info and create a array in storage
    
    txHash = contract.functions.SetUserInfo(
            firstName, lastName, address, tradeId, tradeType, limitPrice, tradeLimit, expDate, neighborhood).transact(
                {'from': address, 'gas': 1000000}
                )
    receipt = w3.eth.waitForTransactionReceipt(txHash)
    st.write("Transaction receipt mined:")
    st.write(dict(receipt))
    
st.text("\n")
st.write("You need to deposit your max loss amount to an escrow contract account")
if st.button("Deposit"):
    # deposit account's trade limit to the contract
    time.sleep(5)
    transaction_hash = send_transaction(address, contract.address, tradeLimit)

    # Display the Etheremum Transaction Hash
    st.text("\n")
    st.markdown("## Ethereum Transaction Hash:")

    st.write(transaction_hash)

if st.button("Check contract balance"):
    contrBalance = get_balance(w3, contract.address)
    st.text("\n")
    st.write("Contract balance(eth): " + str(contrBalance))
    
if st.button("Confirm your trade"):
    
    # Call setHouseInfo to set up a hard code mapping for city and avg home price.  Want to hook up to api later
    time.sleep(5)
   
    contract.functions.setHouseInfo().transact({'from': address, 'gas': 1000000})
    

st.text("\n")
updatedID = st.number_input("Enter trade ID you wish to update", )    
updatedID = int(updatedID)

    
if st.button("Update your trade"):
    contract.functions.matchBuySell(updatedID).transact({'from': address, 'gas': 1000000}) 
    
    checkBool = contract.functions.getTradeStatus(False,False,False,False,False).transact({'from': address, 'gas': 1000000}) 
    
    if checkBool[2]:
        st.text("\n")
        st.write("Your trade has been settled...check your wallet!")
    elif checkBool[1]:
        st.text("\n")
        st.write("No match with your trade yet..")
    elif checkBool[3]:
        st.write("Your trade is the one only on the blockchain so far") 
    elif checkBool[4]:
        st.text("\n")
        st.write("You don't a trade registered...sign up now!")
    elif checkBool[5]:
        st.text("\n")
        st.write("Your deposit has been depleted...please top up to trade")
    
st.markdown("---")                                                                                       
    
                                                                                        
    
    



