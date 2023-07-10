Name Project: MID

Mid is a ERC20 token for my API, this API allows you to connect to the smart contract to read and update it.
The code represents the site interface to connect to the contract, i also leave the smart contract code written using openzeppelin's ERC20 contract on Remix.
The blockchain used is ganache and using the api you can view address balances and transact between them.

For run the project, before, you need to open the folder project with: cd smartcontract and after that, you need to install django in your code editor with:

pip install django (for windows) and also djongo, with: pip install djongo

now you need to make migrations with command in terminal: python manage.py makemigrations

for application the migrations: python manage.py migrate

now, you can run the server and visit the page will appear in your terminal for use the site python manage.py runserver