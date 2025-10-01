*** Settings ***
Documentation    Configurações de ambiente

*** Variables ***
${BASE_URL_ENVIRONMENT}     https://compassuol.serverest.dev

*** Keywords ***
Get Base URL
    [Documentation]    Retorna a URL base
    RETURN    ${BASE_URL}