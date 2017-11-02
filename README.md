# wallet-challenge
API em Rails de um sistema de gerenciamento de cartões de crédito

Ruby version: 2.4.0
Rails version: 5.1.4

Testes: GREEN

# Como usar
	heroku url: TODO

	Execute localmente usando 'rails server', verifique a porta que o servidor vai utilizar (3000 se você não tiver feito nenhuma alteração) e você pode acessar por localhost:3000/ (mantive a página padrão "You're on rails")

	Todos parametros de requisição assim como de resposta são esperados em JSON

-- POST /user/create --
	-> Aqui você consegue criar um novo usuário. (obs: id_nat é o CPF)
	-> Parametros: user(name, password, id_nat)
	-> Retorna: O objeto JSON do usuário criado (HTTP 200) ou HTPP(422) com o erro de criação caso haja um.

-- GET /user/index --
	-> Aqui você consegue o objeto JSON com todos os usuários no sistema e suas infos. (útil para alguns testes mas melhor remover em breve)
	-> Retorna: Lista de objetos JSON que representa todos os usuários do BD (HTTP 200)

-- POST /user/login --
	-> Retorna o token de login do usuário (caso haja sucesso na autenticação)
	-> Parametros: id_nat, password 
	-> Retorna: token de autenticação


