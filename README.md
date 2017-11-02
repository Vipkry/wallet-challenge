# wallet-challenge
API em Rails de um sistema de gerenciamento de cartões de crédito

Ruby version: 2.4.0
Rails version: 5.1.4

Heroku url: TODO

Testes: GREEN

# Como usar

	Execute localmente usando 'rails server', verifique a porta que o servidor vai utilizar (3000 se você não tiver feito nenhuma alteração) e você pode acessar por localhost:3000/ (mantive a página padrão "You're on rails")

	Todos parametros de requisição assim como de resposta são esperados em JSON

-- POST /user/create --
	-> Aqui você consegue criar um novo usuário. (obs: id_nat é o CPF)
	-> Parametros: user(name, password, id_nat) (Ex: '{"user": {"name": "Gustavo", "id_nat": "12345678901", "password": "123"}}')
	-> Retorna: O objeto JSON do usuário criado (HTTP 200) ou HTPP(422) com o erro de criação caso haja um.

-- POST /user/login --
	-> Retorna o token de login do usuário (caso haja sucesso na autenticação). Use o token para manipular o restante da API como o usuário correto logado.
	-> Parametros: id_nat, password 
	-> Retorna: token de autenticação.




