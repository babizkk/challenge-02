*** Settings ***
Documentation    Keywords relacionadas ao módulo de usuários
Library          RequestsLibrary
Library          Collections
Library          ../libraries/FakerHelper.py
Resource         variables.resource

*** Keywords ***
Gerar Dados de Usuário
    [Documentation]    Gera dados válidos para cadastro de novo usuário
    [Arguments]    ${administrador}=true
    
    ${nome}=        Gerar Nome
    ${email}=       Gerar Email
    ${password}=    Gerar Senha    tamanho=8
    
    ${usuario}=    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${password}
    ...    administrador=${administrador}
    
    RETURN    ${usuario}

Cadastrar Usuario
    [Documentation]    Cadastra um novo usuário
    [Arguments]    ${usuario_data}
    
    Create Session    serverest    ${BASE_URL}    verify=True
    ${response}=    POST On Session
    ...    serverest
    ...    ${ENDPOINT_USUARIOS}
    ...    json=${usuario_data}
    ...    expected_status=any
    
    RETURN    ${response}

Validar Cadastro Usuario Com Sucesso
    [Documentation]    Valida cadastro de usuário com sucesso
    [Arguments]    ${response}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_201}
    Dictionary Should Contain Key    ${response.json()}    message
    Dictionary Should Contain Key    ${response.json()}    _id
    Should Be Equal    ${response.json()}[message]    Cadastro realizado com sucesso

Validar Erro Cadastro Usuario
    [Documentation]    Valida erro no cadastro de usuário
    [Arguments]    ${response}    ${status_esperado}    ${campo}    ${mensagem_esperada}
    
    Should Be Equal As Numbers    ${response.status_code}    ${status_esperado}
    ${campo_erro}=    Get From Dictionary    ${response.json()}    ${campo}
    Should Be Equal    ${campo_erro}    ${mensagem_esperada}

Validar Email Duplicado
    [Documentation]    Valida erro de email já cadastrado
    [Arguments]    ${response}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_400}
    Should Be Equal    ${response.json()}[message]    Este email já está sendo usado