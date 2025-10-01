*** Settings ***
Documentation    Testes do módulo de produtos
Resource         ../../resources/produtos_keywords.resource
Resource         ../../resources/auth_keywords.resource
Resource         ../../resources/usuarios_keywords.resource
Resource         ../../resources/carrinho_keywords.resource

Library          DateTime

Suite Setup      Setup Suite Produtos
Test Tags        produtos

*** Variables ***
${TOKEN_SUITE}    ${EMPTY}
${PRODUTO_ID}     ${EMPTY}

*** Keywords ***
Setup Suite Produtos
    [Documentation]    Variáveis e pré-requisitos para os testes de produtos
    
    ${token}=    Criar Usuario E Retornar Token
    Set Suite Variable    ${TOKEN_SUITE}    ${token}
    Log    Token: ${TOKEN_SUITE}

    ${produto}=    Gerar Dados de Produto
    ${response}=    Cadastrar Produto Com Token    ${produto}    ${TOKEN_SUITE}
    
    Validar Cadastro Produto Com Sucesso    ${response}
    
    ${id_temporario}=    Get From Dictionary    ${response.json()}    _id
    Set Suite Variable    ${PRODUTO_ID}    ${id_temporario}
    Log    Produto de base cadastrado com ID: ${PRODUTO_ID}

*** Test Cases ***
SCRUM-17: POST - Cadastrar produto com token de autenticação válido
    [Documentation]    Valida cadastro de produto com token válido
    [Tags]    POST    cadastro    positivo    smoke
    
    ${produto}=    Gerar Dados de Produto
    ${response}=    Cadastrar Produto Com Token    ${produto}    ${TOKEN_SUITE}
    Validar Cadastro Produto Com Sucesso    ${response}

SCRUM-18: GET - Buscar produto por ID sem token de autenticação
    [Documentation]    *** BUG DE SEGURANÇA ***
    [Tags]    GET    consulta    negativo    bug
    
    Log To Console    ID do produto usado: ${PRODUTO_ID}
    
    ${response}=    Buscar Produto Por ID Sem Token    ${PRODUTO_ID}
    Log To Console    Status Code: ${response.status_code}
    Log To Console    Response Body: ${response.text}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_401}
    Should Be Equal    ${response.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

SCRUM-19: GET - Listar produtos sem token de autenticação
    [Documentation]    *** BUG DE SEGURANÇA ***
    [Tags]    GET    consulta    negativo    bug    
    
    ${response}=    Listar Produtos Sem Token
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_401}
    Should Be Equal    ${response.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    
SCRUM-20: PUT - Editar produto pelo ID com token de autenticação válido
    [Documentation]    Valida edição de produto com token válido
    [Tags]    PUT    edicao    positivo
    
    ${produto_editado}=    Gerar Dados de Produto
    
    ${timestamp}=    Get Time    epoch
    Set To Dictionary    ${produto_editado}    nome=Produto Editado Teste ${timestamp}
    
    ${response}=    Editar Produto    ${PRODUTO_ID}    ${produto_editado}    ${TOKEN_SUITE}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_200}
    Should Be Equal    ${response.json()}[message]    Registro alterado com sucesso

    Log To Console    Status Code: ${response.status_code}
    Log To Console    Response Body: ${response.text}
    Log To Console    Produto editado com sucesso: ${produto_editado}

SCRUM-21: DELETE - Deletar produto pelo ID com token de autenticação válido
    [Documentation]    Valida exclusão de produto com token válido
    [Tags]    DELETE    exclusao    positivo
    
    ${produto_novo}=    Gerar Dados de Produto
    ${response_cadastro}=    Cadastrar Produto Com Token    ${produto_novo}    ${TOKEN_SUITE}
    ${id_para_deletar}=    Get From Dictionary    ${response_cadastro.json()}    _id

    ${response}=    Deletar Produto    ${id_para_deletar}    ${TOKEN_SUITE}
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_200}
    
    ${message}=    Get From Dictionary    ${response.json()}    message
    Should Match Regexp    ${message}    (Registro excluído com sucesso|Nenhum registro excluído)

SCRUM-25: DELETE - Deletar produto que está em carrinho
    [Documentation]    Valida que não é possível excluir um produto que está em um carrinho ativo
    [Tags]    DELETE    exclusao    negativo
    
    [Teardown]    Excluir Carrinho Com Token    ${TOKEN_SUITE}    concluir-compra
    
    ${carrinho}=    Criar Dados Carrinho    ${PRODUTO_ID}    quantidade=1
    ${response_carrinho}=    Cadastrar Carrinho Com Token    ${carrinho}    ${TOKEN_SUITE}
    Should Be Equal As Numbers    ${response_carrinho.status_code}    ${STATUS_201}
    
    ${response}=    Deletar Produto    ${PRODUTO_ID}    ${TOKEN_SUITE}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_400}
    Should Be Equal    ${response.json()}[message]    Não é permitido excluir produto que faz parte de carrinho
    
    Log To Console    Status Code: ${response.status_code}
    Log To Console    Response Body: ${response.text}

SCRUM-29: POST - Cadastrar Produto com quantidade 0
    [Documentation]    Valida que não é possível cadastrar um produto com quantidade igual a zero
    [Tags]    POST    cadastro    negativo    bug
    
    ${produto}=    Gerar Dados de Produto
    Set To Dictionary    ${produto}    quantidade=0
    
    ${response}=    Cadastrar Produto Com Token    ${produto}    ${TOKEN_SUITE}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_400}
    
    Log To Console    Status Code: ${response.status_code}
    Log To Console    Produto cadastrado com sucesso: ${response.text}

SCRUM-30: POST - Cadastrar produto com nome já existente
    [Documentation]    Valida que não é possível cadastrar um produto com nome já existente
    [Tags]    POST    cadastro    negativo
    
    ${produto}=    Gerar Dados de Produto
    ${response_1}=    Cadastrar Produto Com Token    ${produto}    ${TOKEN_SUITE}
    
    Validar Cadastro Produto Com Sucesso    ${response_1}
    
    ${nome_existente}=    Get From Dictionary    ${produto}    nome
    ${nome_duplicado}=    Gerar Dados de Produto
    Set To Dictionary    ${nome_duplicado}    nome=${nome_existente}
    
    ${response_2}=    Cadastrar Produto Com Token    ${nome_duplicado}    ${TOKEN_SUITE}
    
    Should Be Equal As Numbers    ${response_2.status_code}    ${STATUS_400}
    Should Be Equal    ${response_2.json()}[message]    Já existe produto com esse nome
    
    Log To Console    Status Code: ${response_2.status_code}
    Log To Console    Response Body: ${response_2.text}

SCRUM-31: PUT - Editar produto sem token de autenticação
    [Documentation]    Valida que não é possível editar um produto sem fornecer token de autenticação
    [Tags]    PUT      negativo
    
    ${produto_editado}=    Gerar Dados de Produto
    
    ${response}=    Editar Produto Sem Token    ${PRODUTO_ID}    ${produto_editado}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_401}
    Should Be Equal    ${response.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    
    Log To Console    Status Code: ${response.status_code}
    Log To Console    Response Body: ${response.text}