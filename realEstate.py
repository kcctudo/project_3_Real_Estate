#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# %% Imports
import os
import json
from web3 import Web3
from web3.gas_strategies.time_based import medium_gas_price_strategy
from pathlib import Path
from dotenv import load_dotenv
import datetime
import calendar

# %%
load_dotenv()

# %% Define and connect a new Web3 provider
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))

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

# %% Create a function called `send_transaction` that creates a raw transaction, signs it, and sends it. Return the confirmation hash from the transaction
def send_transaction(account_address, contract_address , wei_value):
    """Send an authorized transaction."""
    
       
    raw_txt = {"from":account_address,
    "to": contract_address,
    "value": wei_value,
    }
    return w3.eth.sendTransaction(raw_txt)

# %% Function to convert USD to wei
def getUsdWei(dollar):
    usdEthPrice = 214139672966
    usdEth = usdEthPrice * 1e10
    usd = dollar * (10**18)
    wei = int((usd *(10**18))/ usdEth)
    
    return wei
    

# %% Create a function called `get_balance` that calls = converts the wei balance of the account to ether, and returns the value of ether
def get_balance(w3, address):
    """Using an Ethereum account address access the balance of Ether"""
    # Get balance of address in Wei
    wei_balance = w3.eth.get_balance(address)

    # Convert Wei value to ether
    ether = int(w3.fromWei(wei_balance, "ether"))

    # Return the value in ether
    return ether

# %% Create a function that accepts a month and year in string and convert to epoch time

def getCalendarEpoch(_Year, _Month):
    
    Year = int(_Year)
    Month = int(_Month)
    lastDOM = calendar.monthrange(Year, Month)[1]
    
    epochDate = int(datetime.datetime(Year, Month,lastDOM,0,0).timestamp())
    
    return epochDate





