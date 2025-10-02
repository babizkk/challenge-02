<h1 align="center"> Challenge-02 @ Compass UOL </h1>

<p align="left">

  ᯓᡣ𐭩.ᐟ ⊹ Este projeto é a construção de uma solução de testes automatizados para a API [ServeRest](https://compassuol.serverest.dev/#) desenvolvido em Robot Framework. Cada report e execução foi documentada através do [Jira](https://barbaracpad.atlassian.net/jira/software/projects/SCRUM/boards/1?atlOrigin=eyJpIjoiNDU0N2ZkOTIxZjcxNDVkOThjMzc3ODc5N2ExMTU2OWEiLCJwIjoiaiJ9), com o auxílio do plug-in QAlity.

</p>

---

## ᯓᡣ𐭩.ᐟ ⊹ 📂 Estrutura

A organização do repositório está estruturada da seguinte forma:

```
.
├── .config/
│   └── environment_resources
├── libraries/
│   ├── FakeHelper.py
├── resources/
│   ├── autenticacao/
│   │   └── auth_keywords.resource
│   ├── carrinho/
│   │   └── carrinho_keywords.resource
│   ├── produtos/
│   │   └── produtos_keywords.resource
│   ├── usuarios/
│   │   └── usuarios_keywords.resource
│   └── variables.resource
├── tests/
│   ├── carrinho/
│   │   └── tests_carrinho.robot
│   ├── produtos/
│   │   └── tests_produtos.robot
│   └── usuarios/
│       └── tests_cadastro_login.robot
├── .gitignore
├── README.md
└── requirements.txt
```

- **`config/`**: Contém o arquivo de configuração das variáveis de ambiente necessárias para o teste.
- **`resources/`**: Contém a lógica principal da automação, dividida por módulos da API.
- **`tests/`** Contém os arquivos de teste principais (os test suites).
  <br>
→ **`carrinho/tests_carrinho.robot`**: Arquivo de testes que executa cenários do módulo de Carrinho. <br>
→ **`produtos/tests_produtos.robot`**: Arquivo de testes que executa cenários do módulo de Produtos. <br>
→ **`usuarios/tests_cadastro_login.robot`**: Arquivo de testes que executa cenários de Cadastro e Login de usuários.

---

## ᯓᡣ𐭩.ᐟ ⊹ 🧪 Testes

Os testes automatizados, anteriormente feitos no Postman, foram refinados e cobrem os seguintes fluxos de negócio na API ServeRest:

- `CRUD (Create, Read, Update, Delete)`: Cobertura completa para as rotas de Usuários e Produtos. <br>
- `Autenticação (POST /login)`: Geração e validação do Token JWT para rotas protegidas. <br>

→ Além disso, cobre testes de segurança, testes de cenários limite e de fluxo.

---

## ᯓᡣ𐭩.ᐟ ⊹ ⚙️ Execução

Para conseguir executar os testes criados, siga o seguinte fluxo abaixo:

1. Certifique-se de que você tem o Python e o pip instalados.
2. Instale o Robot Framework e as bibliotecas necessárias com o seguinte comando:

```
pip install -r requirements.txt
```

3. Navegue até o diretório raiz do projeto

Para rodar todos os testes, execute:

```
robot ServeRest/tests
```

Para rodar uma suite específica:

```
robot tests/carrinho/tests_carrinho.robot
```

Para ver o relatório: <br>
→ Após a execução, o Robot Framework gera automaticamente os arquivos `report.html` e `log.html`. Abra no browser para ver o resumo ou detalhamento dos testes.

---

## ᯓᡣ𐭩.ᐟ ⊹ 📋 Documentação

Além da documentação oficial do código e seus respectivos módulos, há também um detalhamento da suíte de testes através do Jira. <br>
Foi implementado um Test Cycle com o plug-in QAlity para registro da execução dos testes, e isso trouxe um relatório mais detalhado sobre execução. Há também o detalhamento dos bugs, passos para a execução e os resultados esperados vs resultados obtidos.
<br>
→ [ServeRest - Challenge 02 on JIRA](https://barbaracpad.atlassian.net/jira/software/projects/SCRUM/boards/1?atlOrigin=eyJpIjoiNDU0N2ZkOTIxZjcxNDVkOThjMzc3ODc5N2ExMTU2OWEiLCJwIjoiaiJ9)

