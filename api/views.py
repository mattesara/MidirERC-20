from django.shortcuts import render, redirect
from django.http import JsonResponse
from web3 import Web3
import json
from .models import *
from eth_utils import to_checksum_address
from bson.objectid import ObjectId

with open('build/contracts/abi.json', 'r') as abi_file:             #in questo modo carico l'abi del contratto deployato da remix
        info_json = json.load(abi_file)

ganache_url = "http://127.0.0.1:7545"                               #definisco l'url per connettere la blockchain ganache
w3 = Web3(Web3.HTTPProvider(ganache_url))

contract_address = "0x95Cfd141203a8fDa4FB8410F17256ca73CC0b093"
abi = info_json

contract = w3.eth.contract(address=contract_address, abi=abi)


def home(request):                                                            
    return render(request, 'api/home.html')


def get_supply(request):                                                        #funzione che permette di visualizzare la supply totale
    supply = contract.functions.totalSupply().call()                            #del token
    return render(request, 'api/get_supply.html', {'supply': supply})

def balance_view(request):
    return render(request, 'api/balance.html')

def get_balance(request):                                                       #funzione che permette di inserire l'indirizzo di un
    address = request.GET.get('address')                                        #account per vederne il bilancio di token
    if address:
        balance = contract.functions.balanceOf(address).call()
        return render(request, 'api/get_balance.html', {'balance': balance, 'address':address})
    else:
        return redirect('home')
    
def allowance(request):
    return render(request, 'api/allowance.html')

def get_allowance(request):                                                     #funzione che permette di visualizzare quanti token può
    if request.method == 'POST':                                                #spendere un indirizzo per conto di un altro
        owner_address = request.POST['owner_address']
        spender_address = request.POST['spender_address']

        owner_address = to_checksum_address(owner_address)
        spender_address = to_checksum_address(spender_address)

        allowance = contract.functions.allowance(owner_address, spender_address).call()
    

        return render(request, 'api/get_allowance.html', {'allowance': allowance})
    else:
        return redirect('home')
    
def transfer(request):
    return render(request, 'api/transfer.html')

def get_transfer(request):                                                      #funzione che permette di effettuare transazione
    if request.method == 'POST':                                                #tra due indirizzi della blockchain
        private_key = request.POST['private_key']
        from_address = request.POST['from_address']
        to_address = request.POST['to_address']
        amount = request.POST['amount']

        from_address = to_checksum_address(from_address)
        to_address = to_checksum_address(to_address)
        amount = int(amount)
        w3.eth.default_account = from_address

        transfer = contract.functions.transfer(to_address, amount).build_transaction({
             'from': from_address,
             'gas': 100000,
             'gasPrice': w3.to_wei('50', 'gwei'),
             'nonce': w3.eth.get_transaction_count(from_address),
        })
        signed_txn = w3.eth.account.sign_transaction(transfer, private_key=private_key)
        tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
        receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    
        transaction_data = {                                                    #dati che permettono di salvare un modello transazione
        'id': ObjectId(),                                                       #nel database ogni volta che questa viene effettuata
        'tx_hash': tx_hash.hex,
        'sender': from_address,
        'recipient': to_address,
        'amount': amount
    }
        transaction = Transaction(**transaction_data)
        transaction.save()

        return render(request, 'api/get_transfer.html', {'transaction_hash': tx_hash.hex})
    else:
        return redirect('home')


def transferFrom(request):
    return render(request, 'api/transferFrom.html')

def get_transferFrom(request):                                                  #funzione di transazione che permette ad un indirizzo
    if request.method == 'POST':                                                #approvato di effettuare transazioni per conto di un altro
        spender_address = request.POST['spender_address']
        private_key = request.POST['private_key']
        from_address = request.POST['from_address']
        to_address = request.POST['to_address']
        amount = request.POST['amount']

        spender_address = to_checksum_address(spender_address)
        from_address = to_checksum_address(from_address)
        to_address = to_checksum_address(to_address)
        amount = int(amount)
        w3.eth.default_account = spender_address

        transferFrom = contract.functions.transferFrom(from_address, to_address, amount).build_transaction({
             'from': from_address,
             'gas': 100000,
             'gasPrice': w3.to_wei('50', 'gwei'),
             'nonce': w3.eth.get_transaction_count(from_address),
        })
        signed_txn = w3.eth.account.sign_transaction(transferFrom, private_key=private_key)
        tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
        receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    
        return render(request, 'api/get_transferFrom.html', {'transaction_hash': tx_hash.hex})
    else:
        return redirect('home')
    
def approve(request):
    return render(request, 'api/approve.html')

def get_approve(request):                                                           #funzione che permette di approvare un indirizzo
    if request.method == 'POST':                                                    #ad effettuare transazioni per conto di un altro
        owner_address = request.POST['owner_address']                               #e di scegliere il budget che il primo può utilizzare
        spender_address = request.POST['spender_address']
        amount = request.POST['amount']

        owner_address = to_checksum_address(owner_address)
        spender_address = to_checksum_address(spender_address)
        w3.eth.default_account = owner_address


        contract.functions.approve(spender_address, int(amount)).transact()

        return render(request, 'api/get_approve.html')
    else:
        return redirect('home')
     
    


