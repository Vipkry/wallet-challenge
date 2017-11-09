# Wallet Challenge
API em Rails de um sistema de gerenciamento de cartões de crédito

Ruby version: 2.4.0
Rails version: 5.1.4

Heroku url: https://wallet-challenge.herokuapp.com/ (atualizado em 08/11/17)

Testes: GREEN

## Observações sobre o desafio
	-> Estou considerando que na data de vencimento o valor da fatura do cartão necessariamente vai ser
	pago pelo usuário, ou seja, o limite gira automaticamente após a data de vencimento da fatura do cartão
	caso o usuário não tenha informado o pagamento em /cards/pay

## Como usar

	Execute localmente usando 'rails server'.
	Verifique a porta que o servidor vai utilizar (3000 se você não tiver feito nenhuma alteração)
	e você pode acessar por localhost:3000/ (mantive a página padrão "You're on rails")

	Obs: Use 'rails server -b $IP -p $PORT' se estiver usando a cloud9 IDE

	Todos parametros de requisição assim como de resposta são esperados em JSON

### POST /users/create
	-> Aqui você consegue criar um novo usuário. (obs: id_nat é o CPF)
	-> Parametros: user(name, password, id_nat) (Ex: '{"user": {"name": "Gustavo", "id_nat": "12345678901", "password": "123"}}')
	-> Retorna: O objeto JSON do usuário criado (HTTP 200) ou com o erro de criação caso haja um (HTTP 422).

### POST /users/login
	-> Retorna o token de login do usuário (caso haja sucesso na autenticação) junto com o id do usuário. Use o token para manipular o restante da API como o usuário correto logado. (Incluindo
		o token no header 'Authorization')
	-> Parametros: id_nat, password 
	-> Retorna: auth_token

### GET /user_wallets/show
	-> Retorna o limite real que o usuário logado escolheu pra sua wallet(custom_limit), o limite máximo(limit), e o total de crédito disponível(credit_available). Requer autenticação.
	-> Header: Authorization
	-> Parametros: nenhum
	-> Retorna: custom_limit, limit, credit_available

### GET /user_wallets/show_cards
	-> Aqui o usuário logado consegue visualizar seus cartões.
	-> Header: Authorization
	-> Parametros: nenhum
	-> Retorna: Lista de objetos JSON representando os cards do usuário logado

### POST /cards/create
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
						      "due_date_day": "10",
						      "due_date_month": "09",
						      "name": "MyDummyCard", 
						      "name_written": "Justine Henderson", 
						      "limit": "15000.8" 
						      }
						 }
		-> Retorna: O objeto JSON do card criado (HTTP 200) ou com o erro de criação caso haja um (HTTP 422).

### DELETE /cards/
	-> Aqui o usuário logado consegue apagar algum cartão da wallet dele. Quando ele apaga um cartão, o valor do limite desse cartão diminui o limite máximo da wallet desse usuário. Caso esse novo valor seja menor que o limite personalizado do usuário, o limite personalizado é reduzido para ficar igual ao valor máximo.
	-> Header: Authorization
	-> Parametros: id (id do cartão, pode ser checado em GET /user_wallet/show_cards)
	-> Retorna: no content (204)

### GET /cards/pay/
	-> Aqui o usuário logado consegue pagar uma parte de algum cartão da wallet dele. Quando ele paga um cartão, o limite atual é restaurado de acordo com o valor pago. A data de pagamento, entretanto, se mantém. (Se o usuário não pagar até a data de vencimento da fatura, após essa data o atributo 'spent' reseta). Se o usuário disser que pagou além do que o sistema tem registrado como 'spent', o atributo 'spent' zera.
	-> Header: Authorization
	-> Parametros: id (id do cartão, pode ser checado em GET /user_wallet/show_cards), ammount
	-> Retorna: JSON do objeto do cartão (200)

