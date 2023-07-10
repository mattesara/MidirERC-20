from django.http import JsonResponse
from web3 import Web3
import json
import request, render

def home(request):

    with open('build/contracts/MyContract.json', 'r') as abi_file:
        contract_abi = json.load(abi_file)

    ganache_url = "http://127.0.0.1:7545"
    web3 = Web3(Web3.HTTPProvider(ganache_url))

    contract_address = "0x37e8729471C4aB959a247965092885D93B153fd0"
    contract_abi = contract_abi

    contract = w3.eth.contract(address=contract_address, abi=contract_abi)


    balance = contract.functions.balanceOf('0xbb1Cb6eD4798FCBF35A0E571F4E33Fa52A3b6dDe').call()
    return render(request, 'api/home.html', {'balance': balance})