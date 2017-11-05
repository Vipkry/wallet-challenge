# Wallet Challenge
API em Rails de um sistema de gerenciamento de cartões de crédito

Ruby version: 2.4.0
Rails version: 5.1.4

Heroku url: https://wallet-challenge.herokuapp.com/ 

Testes: GREEN

## Como usar

	Execute localmente usando 'rails server'.
	Verifique a porta que o servidor vai utilizar (3000 se você não tiver feito nenhuma alteração)
	e você pode acessar por localhost:3000/ (mantive a página padrão "You're on rails")

	Obs: Use 'rails server -b $IP -p $PORT' se estiver usando a cloud9 IDE

	Todos parametros de requisição assim como de resposta são esperados em JSON

### POST /user/create
	-> Aqui você consegue criar um novo usuário. (obs: id_nat é o CPF)
	-> Parametros: user(name, password, id_nat) (Ex: '{"user": {"name": "Gustavo", "id_nat": "12345678901", "password": "123"}}')
	-> Retorna: O objeto JSON do usuário criado (HTTP 200) ou HTPP(422) com o erro de criação caso haja um.

### POST /user/login
	-> Retorna o token de login do usuário (caso haja sucesso na autenticação) junto com o id do usuário. Use o token para manipular o restante da API como o usuário correto logado. (Incluindo
		o token no header 'Authorization')
	-> Parametros: id_nat, password 
	-> Retorna: auth_token

### GET /user_wallet/show
	-> Retorna o limite real que o usuário logado escolheu pra sua wallet(custom_limit), o limite máximo(limit), e o total de crédito disponível(credit_available). Requer autenticação.
	-> Header: Authorization
	-> Parametros: nenhum
	-> Retorna: custom_limit, limit, credit_available

### POST card/create
		-> Aqui o usuário logado consegue adicionar um novo cartão à sua wallet. 
		-> Header: Authorization
		-> Parametros: card(number, cvv, expiration_year, expiration_month, name, name_written, limit)
		Exemplo:  {
								"card": 
						      {
						      "number": "42353913010563908", 
						      "cvv": "4556",
						      "expiration_year": "2022", 
						      "expiration_month": "08",
						      "name": "MyDummyCard", 
						      "name_written": "Justine Henderson", 
						      "limit": "15000.8" 
						      }
						 }
		-> Retorna: o objeto JSON do card criado
