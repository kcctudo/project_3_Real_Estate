#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Aug  5 23:34:15 2022

@author: hannahtudo
"""

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

with open(Path('/Users/hannahtudo/UofT/project_3_Real_Estate/transactions_abi.json')) as f:
    transactions_abi = json.load(f)

# %% Set the contract address (this is the address of the deployed contract)
contract_address = os.getenv("SMART_CONTRACT_ADDRESS")

# Get the contract
contract = w3.eth.contract(
address=contract_address,
abi=transactions_abi
)
#0xCcAD331B578483A72F0cb9bAe32E4afD914547B1

# %%

#contract.functions.mybalance().call()
import time
time.sleep(5)
contract.functions.mybalance().call()
# %% this didn't work
import time
time.sleep(10)   
contract.functions.deposit().transact() 
    
# %%
# w3.eth.send_transaction({'to': receiver , 'from': sender , ‘gas’: gas, 'value': value})

myaddress = "0x289Cea0051b64E9dddF032AaBED0aCdB81288c7A"
#toaddress = "0xCcAD331B578483A72F0cb9bAe32E4afD914547B1"
toaddress = contract.address

gas = 21,000
value = w3.toWei(2, 'ether')


w3.eth.sendTransaction(
    {"from": myaddress,
   "to": toaddress,
   "data": w3.eth.abi.encodeFunctionSignature('deposit()'),
   "value": value,
})

#%%
w3.eth.sendTransaction(
    {"from": myaddress,
   "to": toaddress,
   "value": value,
})    

    
    

#%%


raw_tx = {
    "to": receiver,
    "from": account.address,
    "value": wei_value,
    "gas": gas_estimate,
    "gasPrice": 0,
    "nonce": w3.eth.getTransactionCount(account.address)
}





contract = new web3.eth.Contract(contractJson, contractAddress)
  var transfer = contract.methods.transfer("0x...", 490);
  var encodedABI = transfer.encodeABI();

  var tx = {
    from: "0x...",
    to: contractAddress,
    gas: 2000000,
    data: encodedABI
  }; 

  web3.eth.accounts.signTransaction(tx, privateKey).then(signed => {
    var tran = web3.eth.sendSignedTransaction(signed.rawTransaction);

    tran.on('confirmation', (confirmationNumber, receipt) => {
      console.log('confirmation: ' + confirmationNumber);
    });

    tran.on('transactionHash', hash => {
      console.log('hash');
      console.log(hash);
    });

    tran.on('receipt', receipt => {
      console.log('reciept');
      console.log(receipt);
    });

    tran.on('error', console.error);
  });

