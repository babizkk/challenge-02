*** Settings ***
Documentation    Keywords relacionadas ao módulo de carrinho
Library          RequestsLibrary
Library          Collections
Resource         variables.resource

*** Keywords ***
Criar Dados Carrinho
    [Documentation]    Cria os dados de um carrinho com um ou mais produtos
    [Arguments]    ${produto_id}    ${quantidade}=1
    
    ${produto_item}=    Create Dictionary
    ...    idProduto=${produto_id}
    ...    quantidade=${quantidade}
    
    ${produtos_list}=    Create List    ${produto_item}
    
    ${carrinho}=    Create Dictionary
    ...    produtos=${produtos_list}
    
    RETURN    ${carrinho}

Cadastrar Carrinho Com Token
    [Documentation]    Cadastra um carrinho com token de autenticação
    [Arguments]    ${carrinho_data}    ${token}
    
    ${headers}=    Create Dictionary
    ...    Authorization=${token}
    ...    Content-Type=${CONTENT_TYPE}
    
    Create Session    serverest    ${BASE_URL}    verify=True
    ${response}=    POST On Session
    ...    serverest
    ...    ${ENDPOINT_CARRINHOS}
    ...    json=${carrinho_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    RETURN    ${response}

Listar Carrinhos
    [Documentation]    Lista todos os carrinhos
    
    Create Session    serverest    ${BASE_URL}    verify=True
    ${response}=    GET On Session
    ...    serverest
    ...    ${ENDPOINT_CARRINHOS}
    ...    expected_status=any
    
    RETURN    ${response}

Excluir Carrinho Com Token
    [Documentation]    Exclui um carrinho (concluir compra ou cancelar)
    [Arguments]    ${token}    ${acao}=concluir-compra
    
    ${headers}=    Create Dictionary
    ...    Authorization=${token}
    ...    Content-Type=${CONTENT_TYPE}
    
    Create Session    serverest    ${BASE_URL}    verify=True
    ${response}=    DELETE On Session
    ...    serverest
    ...    ${ENDPOINT_CARRINHOS}/${acao}
    ...    headers=${headers}
    ...    expected_status=any
    
    RETURN    ${response}

Validar Cadastro Carrinho Com Sucesso
    [Documentation]    Valida que o carrinho foi cadastrado com sucesso
    [Arguments]    ${response}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_201}
    Dictionary Should Contain Key    ${response.json()}    message
    Dictionary Should Contain Key    ${response.json()}    _id
    Should Be Equal    ${response.json()}[message]    Cadastro realizado com sucesso

Validar Listagem de Carrinhos
    [Documentation]    Valida que a listagem de carrinhos foi bem sucedida
    [Arguments]    ${response}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_200}
    Dictionary Should Contain Key    ${response.json()}    quantidade
    Dictionary Should Contain Key    ${response.json()}    carrinhos

Validar Exclusão de Carrinho
    [Documentation]    Valida que o carrinho foi excluído/concluído
    [Arguments]    ${response}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_200}
    Dictionary Should Contain Key    ${response.json()}    message

Cadastrar Carrinho Sem Token
    [Documentation]    Tenta cadastrar um carrinho sem token de autenticação
    [Arguments]    ${carrinho_data}
    
    Create Session    serverest    ${BASE_URL}    verify=True
    ${response}=    POST On Session
    ...    serverest
    ...    ${ENDPOINT_CARRINHOS}
    ...    json=${carrinho_data}
    ...    expected_status=any
    
    RETURN    ${response}

Validar Erro Cadastro Carrinho Sem Token
    [Documentation]    Valida que o cadastro de carrinho falhou por falta de autenticação
    [Arguments]    ${response}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_401}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Validar Erro Cadastro Carrinho Duplicado
    [Documentation]    Valida que o cadastro de carrinho falhou por produto duplicado
    [Arguments]    ${response}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_400}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Não é permitido ter mais de 1 carrinho

Validar Erro Cadastro Carrinho Produto Inexistente
    [Documentation]    Valida que o cadastro de carrinho falhou por produto inexistente
    [Arguments]    ${response}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_400}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Produto não encontrado

Validar Erro Excluir Carrinho Inexistente
    [Documentation]    Valida que a exclusão de carrinho falhou por carrinho inexistente
    [Arguments]    ${response}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_200}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Não foi encontrado carrinho para esse usuário