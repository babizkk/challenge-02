*** Settings ***
Documentation    Testes do módulo de carrinho
Resource         ../../resources/carrinho/carrinho_keywords.resource
Resource         ../../resources/produtos/produtos_keywords.resource
Resource         ../../resources/autenticação/auth_keywords.resource
Resource         ../../resources/usuarios/usuarios_keywords.resource

Suite Setup      Dados de Teste

Suite Teardown   Excluir Carrinho Com Token    ${TOKEN_SUITE}    cancelar-compra
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
    
Excluir Carrinho Limpeza
    [Arguments]    ${token}
    ${response}=    Excluir Carrinho Com Token    ${token}    acao=concluir-compra

*** Test Cases ***
SCRUM-22: POST - Cadastrar carrinho
    [Documentation]    Valida cadastro de carrinho com produto válido
    [Tags]    POST    cadastro    positivo    smoke
    
    [Teardown]    Excluir Carrinho Com Token    ${TOKEN_SUITE}    concluir-compra 
    
    ${carrinho}=    Criar Dados Carrinho    ${PRODUTO_ID}    quantidade=2
    ${response}=    Cadastrar Carrinho Com Token    ${carrinho}    ${TOKEN_SUITE}
    Log To Console    Carrinho cadastrado: ${response.json()}
    Validar Cadastro Carrinho Com Sucesso    ${response}

SCRUM-23: GET - Listar carrinhos sem token
    [Documentation]    Valida listagem de todos os carrinhos
    [Tags]    GET    consulta    positivo    smoke
    
    ${response}=    Listar Carrinhos

    IF  '${response.status_code}' == '${STATUS_200}'
        Log To Console    Carrinhos listados indevidamente: ${response.json()}
        Validar Listagem de Carrinhos    ${response}
    ELSE
        Log To Console    Acesso negado: ${response.json()}
        Validar Listagem de Carrinhos    ${response}
    END

    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_401}

SCRUM-24: DELETE - Excluir carrinho
    [Documentation]    Valida exclusão/conclusão de carrinho
    [Tags]    DELETE    exclusao    positivo
    
    ${token_novo}=    Criar Usuario E Retornar Token
    [Teardown]    Excluir Carrinho Limpeza    ${token_novo}
    
    ${carrinho}=    Criar Dados Carrinho    ${PRODUTO_ID}    quantidade=1
    ${response_cadastro}=    Cadastrar Carrinho Com Token    ${carrinho}    ${token_novo}
    Should Be Equal As Numbers    ${response_cadastro.status_code}    ${STATUS_201}
    
    ${response}=    Excluir Carrinho Com Token    ${token_novo}    acao=concluir-compra
    Log To Console    Carrinho excluído: ${response.json()}
    Validar Exclusão de Carrinho    ${response}

SCRUM-32: POST - Cadastrar carrinho sem token
    [Documentation]    Valida que não é possível cadastrar carrinho sem token
    [Tags]    POST    cadastro    negativo
    
    ${carrinho}=    Criar Dados Carrinho    ${PRODUTO_ID}    quantidade=1
    ${response}=    Cadastrar Carrinho Sem Token    ${carrinho}
    Log To Console    Token ausente: ${response.json()}

    Validar Erro Cadastro Carrinho Sem Token    ${response}

SCRUM-33: POST - Cadastrar carrinho duplicado
    [Documentation]    Valida que não é possível cadastrar o mesmo carrinho duas vezes
    [Tags]    POST    cadastro    negativo
    
    ${token_limpo}=    Criar Usuario E Retornar Token
    [Teardown]    Excluir Carrinho Limpeza    ${token_limpo}
    
    ${carrinho}=    Criar Dados Carrinho    ${PRODUTO_ID}    quantidade=1
    ${response1}=    Cadastrar Carrinho Com Token    ${carrinho}    ${token_limpo}
    Should Be Equal As Numbers    ${response1.status_code}    ${STATUS_201}
    
    ${response2}=    Cadastrar Carrinho Com Token    ${carrinho}    ${token_limpo}
    Log To Console    Carrinho duplicado: ${response2.json()}
    Validar Erro Cadastro Carrinho Duplicado    ${response2}

SCRUM-34: POST - Cadastrar carrinho com produto inexistente
    [Documentation]    Valida que não é possível cadastrar carrinho com produto inexistente
    [Tags]    POST    cadastro    negativo
    
    ${token_limpo}=    Criar Usuario E Retornar Token
    [Teardown]    Excluir Carrinho Limpeza    ${token_limpo}
    
    ${ID_INVALIDO}=    Gerar Senha    tamanho=16
    
    ${carrinho}=    Criar Dados Carrinho    ${ID_INVALIDO}    quantidade=1
    ${response}=    Cadastrar Carrinho Com Token    ${carrinho}    ${token_limpo}
    Log To Console    Produto inexistente: ${response.json()}
    
    Validar Erro Cadastro Carrinho Produto Inexistente    ${response}

SCRUM-35: DELETE - Excluir carrinho inexistente
    [Documentation]     Valida que a API retorna mensagem de erro correta para a exclusão de um carrinho não encontrado.
    [Tags]      DELETE      exclusao      negativo
    
    ${token_novo}=      Criar Usuario E Retornar Token
    
    Run Keyword And Ignore Error    Excluir Carrinho Com Token      ${token_novo}       acao=cancelar-compra
    
    ${response}=        Excluir Carrinho Com Token      ${token_novo}       acao=cancelar-compra
    Log To Console      Carrinho inexistente: ${response.json()}
    
    Should Be Equal As Numbers      ${response.status_code}     ${STATUS_200}
    Should Be Equal     ${response.json()}[message]     Não foi encontrado carrinho para esse usuário