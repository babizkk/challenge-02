*** Settings ***
Resource         ../config/environments.resource
Library          ../libraries/FakerHelper.py

*** Variables ***
${BASE_URL}            ${BASE_URL_ENVIRONMENT}

${CONTENT_TYPE}         application/json

${STATUS_200}           200
${STATUS_201}           201
${STATUS_204}           204
${STATUS_400}           400
${STATUS_401}           401
${STATUS_404}           404

${ENDPOINT_USUARIOS}    /usuarios
${ENDPOINT_LOGIN}       /login
${ENDPOINT_PRODUTOS}    /produtos
${ENDPOINT_CARRINHOS}   /carrinhos