#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Aug  6 19:01:24 2022

@author: hannahtudo
"""

#%% Imports

import os
import json
import requests
from dotenv import load_dotenv
load_dotenv()
from pathlib import Path
from web3 import Account
from web3 import middleware
from web3.gas_strategies.time_based import medium_gas_price_strategy
from web3 import Web3


# %% Define and connect a new Web3 provider
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))

# %% 
load_dotenv()

# %% 
# Contract Helper function:
# 1. Loads the contract once using cache
# 2. Connects to the contract using the contract address and ABI

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

#%%

contract = load_contract()

# Except user's deposit and deposit to the contract

def deposit_contract(deposit_amount, user_address):
    
    wei_value = w3.toWei(deposit_amount, "ether")
    w3.eth.sendTransaction(
        {"from": user_address,
       "to": contract.address,
       "value": wei_value,
    })    
    

# %% 

# Trade settlement 
# - Check user's target price with official released price
# - Withdraw the appropriate fund from contract and deposit to the user's address

def trade_settlement(user_address):
    

    
    
    
    
    
    