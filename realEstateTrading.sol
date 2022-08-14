[
	{
		"inputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "constructor"
	},
	{
		"payable": true,
		"stateMutability": "payable",
		"type": "fallback"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "indx",
				"type": "uint256"
			}
		],
		"name": "GetUserInfo",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "address payable",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "string",
				"name": "_firstName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_lastName",
				"type": "string"
			},
			{
				"internalType": "address payable",
				"name": "_tradeAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_tradeID",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_tradeType",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_limitPrice",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_maxLoss",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_expDate",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_area",
				"type": "string"
			}
		],
		"name": "SetUserInfo",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "contractBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "deposit",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "ownerTradeID",
				"type": "uint256"
			}
		],
		"name": "foundOwner",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "bool",
				"name": "_noMatch",
				"type": "bool"
			},
			{
				"internalType": "bool",
				"name": "_allSettled",
				"type": "bool"
			},
			{
				"internalType": "bool",
				"name": "_onlyOne",
				"type": "bool"
			},
			{
				"internalType": "bool",
				"name": "_noTradeReg",
				"type": "bool"
			},
			{
				"internalType": "bool",
				"name": "_depletedDeposit",
				"type": "bool"
			}
		],
		"name": "getTradeStatus",
		"outputs": [
			{
				"internalType": "bool[]",
				"name": "",
				"type": "bool[]"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "housePrice",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "ownerTradeID",
				"type": "uint256"
			}
		],
		"name": "matchBuySell",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "setHouseInfo",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "settledIndexPairs",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index1",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "index2",
				"type": "uint256"
			}
		],
		"name": "tradePayout",
		"outputs": [
			{
				"internalType": "address payable",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "address payable",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index1",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "index2",
				"type": "uint256"
			}
		],
		"name": "tradeSettledIndex",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index1",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "index2",
				"type": "uint256"
			}
		],
		"name": "tradeSettlement",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "userinfo",
		"outputs": [
			{
				"internalType": "string",
				"name": "firstName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "lastName",
				"type": "string"
			},
			{
				"internalType": "address payable",
				"name": "tradeAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "tradeID",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "tradeType",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "limitPrice",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "maxLoss",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "expDate",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "area",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			},
			{
				"internalType": "address payable",
				"name": "recipient",
				"type": "address"
			}
		],
		"name": "withdraw",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	}
]