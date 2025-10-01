*** Settings ***
Documentation    Keywords relacionadas ao módulo de produtos
Library          RequestsLibrary
Library          Collections
Library          ../libraries/FakerHelper.py
Resource         variables.resource
Resource         auth_keywords.resource
Resource         usuarios_keywords.resource

*** Keywords ***
Gerar Dados de Produto
    [Documentation]    Gera dados válidos para cadastro de produto
    
    ${nome}=        Gerar Nome Produto
    ${preco}=       Gerar Preco    minimo=100    maximo=9999
    ${descricao}=   Gerar Descricao
    ${quantidade}=  Gerar Quantidade    minimo=1    maximo=100
    
    ${produto}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}
    
    RETURN    ${produto}

Cadastrar Produto Com Token
    [Documentation]    Cadastra um produto com token de autenticação
    [Arguments]    ${produto_data}    ${token}
    
    ${headers}=    Create Dictionary
    ...    Authorization=${token}
    ...    Content-Type=${CONTENT_TYPE}
    
    Create Session    serverest    ${BASE_URL}    verify=True
    ${response}=    POST On Session
    ...    serverest
    ...    ${ENDPOINT_PRODUTOS}
    ...    json=${produto_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    RETURN    ${response}

Buscar Produto Por ID Sem Token
    [Documentation]    Busca um produto por ID sem autenticação
    [Arguments]    ${produto_id}
    
    ${endpoint_com_id}=    Catenate    SEPARATOR=/    ${ENDPOINT_PRODUTOS}    ${produto_id}
    Log To Console    Confirmando rota: ${endpoint_com_id} 
    
    Create Session    serverest    ${BASE_URL}    verify=True
    ${response}=    GET On Session
    ...    serverest
    ...    ${endpoint_com_id}   
    ...    expected_status=any
    
    RETURN    ${response}

Listar Produtos Sem Token
    [Documentation]    Lista todos os produtos sem autenticação
    
    Create Session    serverest    ${BASE_URL}    verify=True
    ${response}=    GET On Session
    ...    serverest
    ...    ${ENDPOINT_PRODUTOS}
    ...    expected_status=any
    
    RETURN    ${response}

Editar Produto
    [Documentation]    Edita um produto existente com token
    [Arguments]    ${produto_id}    ${produto_data}    ${token}
    
    ${headers}=    Create Dictionary
    ...    Authorization=${token}
    ...    Content-Type=${CONTENT_TYPE}
    
    Create Session    serverest    ${BASE_URL}    verify=True
    ${response}=    PUT On Session
    ...    serverest
    ...    ${ENDPOINT_PRODUTOS}/${produto_id}
    ...    json=${produto_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    RETURN    ${response}

Editar Produto Sem Token
    [Documentation]    Edita um produto existente sem token
    [Arguments]    ${produto_id}    ${produto_data}
    
    Create Session    serverest    ${BASE_URL}    verify=True
    ${response}=    PUT On Session
    ...    serverest
    ...    ${ENDPOINT_PRODUTOS}/${produto_id}
    ...    json=${produto_data}
    ...    expected_status=any
    
    RETURN    ${response}

Deletar Produto
    [Documentation]    Deleta um produto com token de autenticação
    [Arguments]    ${produto_id}    ${token}
    
    ${headers}=    Create Dictionary
    ...    Authorization=${token}
    ...    Content-Type=${CONTENT_TYPE}
    
    Create Session    serverest    ${BASE_URL}    verify=True
    ${response}=    DELETE On Session
    ...    serverest
    ...    ${ENDPOINT_PRODUTOS}/${produto_id}
    ...    headers=${headers}
    ...    expected_status=any
    
    RETURN    ${response}

Validar Cadastro Produto Com Sucesso
    [Documentation]    Valida que o produto foi cadastrado com sucesso
    [Arguments]    ${response}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_201}
    Dictionary Should Contain Key    ${response.json()}    message
    Dictionary Should Contain Key    ${response.json()}    _id
    Should Be Equal    ${response.json()}[message]    Cadastro realizado com sucesso

Validar Listagem Produtos
    [Documentation]    Valida que a listagem de produtos foi bem sucedida
    [Arguments]    ${response}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_200}
    Dictionary Should Contain Key    ${response.json()}    quantidade
    Dictionary Should Contain Key    ${response.json()}    produtos

Validar Busca Produto Por ID
    [Documentation]    Valida que o produto foi encontrado
    [Arguments]    ${response}
    
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_200}
    Dictionary Should Contain Key    ${response.json()}    nome
    Dictionary Should Contain Key    ${response.json()}    preco
    Dictionary Should Contain Key    ${response.json()}    descricao
    Dictionary Should Contain Key    ${response.json()}    quantidade
    Dictionary Should Contain Key    ${response.json()}    _id