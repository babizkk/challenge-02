*** Settings ***
Documentation    Testes do módulo de carrinho
Resource         ../../resources/carrinho_keywords.resource
Resource         ../../resources/produtos_keywords.resource
Resource         ../../resources/auth_keywords.resource
Resource        ../../resources/usuarios_keywords.resource

Suite Setup      Dados de Teste
Test Tags        carrinho

*** Variables ***
${TOKEN_SUITE}      ${EMPTY}
${PRODUTO_ID}       ${EMPTY}

*** Keywords ***
Dados de Teste
    [Documentation]    Preparação dos dados e pré requisitos para execução dos testes
    
    ${token}=    Criar Usuario E Retornar Token
    Set Suite Variable    ${TOKEN_SUITE}    ${token}
    
    ${produto}=    Gerar Dados de Produto
    ${response}=    Cadastrar Produto Com Token    ${produto}    ${token}
    ${produto_id}=    Get From Dictionary    ${response.json()}    _id
    Set Suite Variable    ${PRODUTO_ID}    ${produto_id}

*** Test Cases ***
SCRUM-22: POST - Cadastrar carrinho
    [Documentation]    Valida cadastro de carrinho com produto válido
    [Tags]    POST    cadastro    positivo    smoke
    
    ${carrinho}=    Criar Dados Carrinho    ${PRODUTO_ID}    quantidade=2
    ${response}=    Cadastrar Carrinho Com Token    ${carrinho}    ${TOKEN_SUITE}
    Validar Cadastro Carrinho Com Sucesso    ${response}

SCRUM-23: GET - Listar carrinhos
    [Documentation]    Valida listagem de todos os carrinhos
    [Tags]    GET    consulta    positivo    smoke
    
    ${response}=    Listar Carrinhos
    Validar Listagem de Carrinhos    ${response}

SCRUM-24: DELETE - Excluir carrinho
    [Documentation]    Valida exclusão/conclusão de carrinho
    [Tags]    DELETE    exclusao    positivo
    
    ${token_novo}=    Criar Usuario E Retornar Token
    ${carrinho}=    Criar Dados Carrinho    ${PRODUTO_ID}    quantidade=1
    ${response_cadastro}=    Cadastrar Carrinho Com Token    ${carrinho}    ${token_novo}
    Should Be Equal As Numbers    ${response_cadastro.status_code}    ${STATUS_201}
    
    ${response}=    Excluir Carrinho Com Token    ${token_novo}    acao=concluir-compra
    Validar Exclusão de Carrinho    ${response}

SCRUM-32: POST - Cadastrar carrinho sem token
    [Documentation]    Valida que não é possível cadastrar carrinho sem token
    [Tags]    POST    cadastro    negativo
    
    ${carrinho}=    Criar Dados Carrinho    ${PRODUTO_ID}    quantidade=1
    ${response}=    Cadastrar Carrinho Sem Token    ${carrinho}

    Validar Erro Cadastro Carrinho Sem Token    ${response}
    Log To Console    Response: ${response.json()}

SCRUM-33: POST - Cadastrar carrinho duplicado
    [Documentation]    Valida que não é possível cadastrar o mesmo carrinho duas vezes
    [Tags]    POST    cadastro    negativo
    
    ${carrinho}=    Criar Dados Carrinho    ${PRODUTO_ID}    quantidade=1
    ${response1}=    Cadastrar Carrinho Com Token    ${carrinho}    ${TOKEN_SUITE}
    Should Be Equal As Numbers    ${response1.status_code}    ${STATUS_201}
    
    ${response2}=    Cadastrar Carrinho Com Token    ${carrinho}    ${TOKEN_SUITE}
    Validar Erro Cadastro Carrinho Duplicado    ${response2}
    Log To Console    Response: ${response2.json()}

SCRUM-34: POST - Cadastrar carrinho com produto inexistente
    [Documentation]    Valida que não é possível cadastrar carrinho com produto inexistente
    [Tags]    POST    cadastro    negativo
    
    ${carrinho}=    Criar Dados Carrinho    produtoId=23232323    quantidade=1
    ${response}=    Cadastrar Carrinho Com Token    ${carrinho}    ${TOKEN_SUITE}
    
    Validar Erro Cadastro Carrinho Produto Inexistente    ${response}
    Log To Console    Response: ${response.json()}

SCRUM-35: DELETE - Excluir carrinho inexistente
    [Documentation]    Valida que não é possível excluir um carrinho inexistente
    [Tags]    DELETE    exclusao    negativo
    
    ${response}=    Excluir Carrinho Com Token    ${TOKEN_SUITE}    acao=cancelar-compra
    Validar Erro Excluir Carrinho Inexistente    ${response}

    Log To Console    Response: ${response.json()}

