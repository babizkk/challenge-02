*** Settings ***
Documentation    Testes de cadastro e autenticação de usuários
Resource         ../../resources/usuarios_keywords.resource
Resource         ../../resources/auth_keywords.resource
Test Tags        usuarios

*** Test Cases ***
SCRUM-9: Cadastrar usuário válido
    [Documentation]    Valida o cadastro de um usuário com dados válidos
    [Tags]    POST    cadastro    positivo    smoke
    
    ${usuario}=    Gerar Dados de Usuário
    ${response}=    Cadastrar Usuario    ${usuario}
    Validar Cadastro Usuario Com Sucesso    ${response}
    Log To Console    Usuário cadastrado: ${usuario}[email]

SCRUM-10: Cadastrar usuário com e-mail inválido
    [Documentation]    Valida que não é possível cadastrar usuário com e-mail inválido
    [Tags]    POST    cadastro    negativo
    
    ${usuario}=    Gerar Dados de Usuário

    Set To Dictionary    ${usuario}    email=emailRandom
    ${response}=    Cadastrar Usuario    ${usuario}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_400}
    Should Be Equal    ${response.json()}[email]    email deve ser um email válido

SCRUM-11: Cadastrar usuário com senha igual a 5 caracteres
    [Documentation]    Valida que não é possível cadastrar usuário com senha curta
    [Tags]    POST    cadastro    negativo
    
    ${usuario}=    Gerar Dados de Usuário

    Set To Dictionary    ${usuario}    password=12345
    ${response}=    Cadastrar Usuario    ${usuario}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_400}
    Should Be Equal    ${response.json()}[password]    password deve ter pelo menos 6 caracteres

SCRUM-12: Cadastrar usuário com e-mail já existente
    [Documentation]    Valida que não é possível cadastrar usuário com e-mail duplicado
    [Tags]    POST    cadastro    negativo

    ${usuario}=    Gerar Dados de Usuário
    ${response1}=    Cadastrar Usuario    ${usuario}
    Should Be Equal As Numbers    ${response1.status_code}    ${STATUS_201}
    
    ${response2}=    Cadastrar Usuario    ${usuario}
    Validar Email Duplicado    ${response2}

SCRUM-14: Login válido
    [Documentation]    Valida login com credenciais válidas
    [Tags]    POST    login    positivo    smoke
    
    ${usuario}=    Gerar Dados de Usuário
    ${response_cadastro}=    Cadastrar Usuario    ${usuario}
    Should Be Equal As Numbers    ${response_cadastro.status_code}    ${STATUS_201}
    
    ${response}=    Realizar Login    ${usuario}[email]    ${usuario}[password]
    Validar Login    ${response}
    
    ${token}=    Extrair Token Da Resposta    ${response}
    Should Not Be Empty    ${token}
    Log To Console    Token obtido: ${token}

SCRUM-15: Login com e-mail inválido (não cadastrado)
    [Documentation]    Valida erro ao tentar login com e-mail não cadastrado
    [Tags]    POST    login    negativo
    
    ${email_inexistente}=    Gerar Email
    ${senha_valida}=    Gerar Senha    tamanho=8 
    
    ${response}=    Realizar Login    ${email_inexistente}    ${senha_valida}
    Validar Erro De Login    ${response}    Email e/ou senha inválidos

SCRUM-16: Login com senha inválida
    [Documentation]    Valida erro ao tentar login com senha incorreta
    [Tags]    POST    login    negativo
    
    ${usuario}=    Gerar Dados de Usuário
    ${response_cadastro}=    Cadastrar Usuario    ${usuario}
    Should Be Equal As Numbers    ${response_cadastro.status_code}    ${STATUS_201}
    
    ${senha_invalida}=    Gerar Senha    tamanho=8 
    
    ${response}=    Realizar Login    ${usuario}[email]    ${senha_invalida}
    Validar Erro De Login    ${response}    Email e/ou senha inválidos

SCRUM-27: Cadastrar usuário com senha > 10 caracteres
    [Documentation]    Não deve ser possível cadastrar usuário com senha maior que 10 caracteres
    [Tags]    POST    cadastro    negativo    bug

    ${senha_longa}=    Gerar Senha    tamanho=11

    ${usuario}=    Gerar Dados de Usuário
    Set To Dictionary    ${usuario}    password=${senha_longa}
    ${response}=    Cadastrar Usuario    ${usuario}
    Validar Cadastro Usuario Com Sucesso    ${response}

    Log To Console    Senha cadastrada: ${senha_longa}

    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_400}

SCRUM-28: Cadastrar usuário com email com @gmail.com
    [Documentation]    Valida que é possível cadastrar usuário com email @gmail.com
    [Tags]    POST    cadastro    negativo    bug
    
    ${inicio_email}=    Gerar Senha    tamanho=6 
    
    ${email_gmail}=    Catenate    SEPARATOR=    ${inicio_email}    @gmail.com
    
    ${usuario}=    Gerar Dados de Usuário
    
    Set To Dictionary    ${usuario}    
    ...    email=${email_gmail}
    ...    password=teste123
    
    ${response}=    Cadastrar Usuario    ${usuario}
    Validar Cadastro Usuario Com Sucesso    ${response}

    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_400}
    Log To Console    Usuário cadastrado com email Gmail: ${email_gmail}

