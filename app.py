#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#%% import libraries

import os
import json
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st
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
tradeLimit = st.selectbox("Choose your max loss in eth", ['5','10','15','20','30','40','50','100','500','1000','10000'])
tradeLimit = int(tradeLimit)
city = ['','Central Toronto', 'Central Toronto-Alexandra Park', 'Central Toronto-Bay Street Corridor', 'Central Toronto-Forest Hill',
        'Toronto Old York', 'Toronto Old York-Baby Point','Toronto Scarborough-Guildwood','Miami, FL', 'St.Petersburg, FL', 
        'Key West, FL', 'Los Angeles, CA', 'Anaheim, CA', 'Beverly Hills, CA', 'Manhattan, NY', 'Brooklyn, NY']
neighborhood = st.selectbox("Choose your neighborhood", city)

if st.button("Submit Trade"):     
    txHash = contract.functions.SetUserInfo(
            firstName, lastName, address, tradeType, tradeLimit, neighborhood).transact({'from': address, 'gas': 1000000}
            )
    receipt = w3.eth.waitForTransactionReceipt(txHash)
    st.write("Transaction receipt mined:")
    st.write(dict(receipt))
    import time
    time.sleep(10)
    contract.functions.GetUserInfo(address).call()
st.markdown("---")                                                                                        
    
                                                                                        
    




