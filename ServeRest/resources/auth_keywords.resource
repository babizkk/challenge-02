*** Settings ***
Documentation    Keywords relacionadas à autenticação
Library          RequestsLibrary
Library          Collections
Resource         variables.resource
Resource         usuarios_keywords.resource

*** Keywords ***
Realizar Login
    [Arguments]    ${email}    ${password}
    
    ${body}=    Create Dictionary
    ...    email=${email}
    ...    password=${password}
    
    Create Session    serverest    ${BASE_URL}    verify=True
    ${response}=    POST On Session
    ...    serverest
    ...    ${ENDPOINT_LOGIN}
    ...    json=${body}
    ...    expected_status=any
    
    RETURN    ${response}

Extrair Token Da Resposta
    [Documentation]    Extrai o token de autorização da resposta de login
    [Arguments]    ${response}
    
    ${token}=    Get From Dictionary    ${response.json()}    authorization
    RETURN    ${token}

Validar Login
    [Documentation]    Valida que o login foi realizado com sucesso
    [Arguments]    ${response}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_200}
    Dictionary Should Contain Key    ${response.json()}    message
    Dictionary Should Contain Key    ${response.json()}    authorization
    Should Be Equal    ${response.json()}[message]    Login realizado com sucesso

Validar Erro De Login
    [Documentation]    Valida mensagem de erro no login
    [Arguments]    ${response}    ${mensagem_esperada}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_401}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    ${mensagem_esperada}

Criar Usuario E Retornar Token
    [Documentation]    Cria um usuário administrador e retorna o token de autenticação
        
    ${usuario}=    Gerar Dados de Usuário    administrador=true
    ${response_cadastro}=    Cadastrar Usuario    ${usuario}
    Should Be Equal As Numbers    ${response_cadastro.status_code}    ${STATUS_201}
    
    ${response_login}=    Realizar Login    ${usuario}[email]    ${usuario}[password]
    ${token}=    Extrair Token Da Resposta    ${response_login}
    
    RETURN    ${token}