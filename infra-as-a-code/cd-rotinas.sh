#!/bin/bash
#importa as configurações de variaveis de ambiente
. ./infra-as-a-code/configurations-rotinas.sh

log() {
    
    patternLog="$(date +'%y-%m-%d-%H:%M:%S') script sh - $1"
    
    echo $patternLog
}

# 1. Autenticar na azure
echo 'Autenticando na azure'
az login --tenant $AZURE_CLOUD_AD_TENANT_DOMINIO_PRINCIPAL \
--service-principal --username $AZURE_CLOUD_REGISTRO_APLICATIVO_CLIENT_ID \
--password $AZURE_CLOUD_REGISTRO_APLICATIVO_TOKEN_CLIENT_ID

#2. https://docs.microsoft.com/pt-br/azure/app-service/quickstart-multi-container
echo "Criando o recurso: $RESOURCE_NAME"
az group create --subscription $AZURE_CLOUD_SUBSCRIPTIONS_ID --name $RESOURCE_NAME --location "South Central US"

#3. https://docs.microsoft.com/pt-br/azure/app-service/quickstart-multi-container
echo "Criando o plano: $PLAN_NAME"
az appservice plan create --subscription $AZURE_CLOUD_SUBSCRIPTIONS_ID --name $PLAN_NAME --resource-group $RESOURCE_NAME --sku F1 --is-linux

#4. https://docs.microsoft.com/pt-br/azure/app-service/quickstart-multi-container e https://docs.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest#az-webapp-create
echo "Criando aplicação : $APPLICATION_NAME"
az webapp create \
--subscription $AZURE_CLOUD_SUBSCRIPTIONS_ID \
--resource-group $RESOURCE_NAME \
--plan $PLAN_NAME \
--name $APPLICATION_NAME \
--multicontainer-config-type compose \
--multicontainer-config-file ./infra-as-a-code/docker/Docker-compose.yml

#5. https://docs.microsoft.com/pt-br/azure/app-service/tutorial-custom-container?pivots=container-linux
echo "Configurando docker hub para o container : $APPLICATION_NAME"
az webapp config container set \
--subscription $AZURE_CLOUD_SUBSCRIPTIONS_ID \
--resource-group $RESOURCE_NAME \
--name $APPLICATION_NAME \
--docker-registry-server-url "https://${DOCKER_REGISTRY_SERVER_URL}" \
--docker-registry-server-user "${DOCKER_REGISTRY_SERVER_USERNAME}" \
--docker-registry-server-password "${DOCKER_REGISTRY_SERVER_PASSWORD}"

#6. https://docs.microsoft.com/en-us/cli/azure/webapp/config/connection-string?view=azure-cli-latest#az-webapp-config-connection-string-set
echo "Definiando a connection string para o conteiner web : $APPLICATION_NAME"
az webapp config connection-string \
set \
--connection-string-type SQLServer \
--subscription $AZURE_CLOUD_SUBSCRIPTIONS_ID \
--resource-group $RESOURCE_NAME \
--name $APPLICATION_NAME  \
--settings \
ConnectionStrings__DefaultConnection="Server=sqlserver;Database=master;ConnectRetryCount=0;User=sa;Password=Admin@123;MultipleActiveResultSets=true"

#7. https://docs.microsoft.com/en-us/cli/azure/webapp/config/appsettings?view=azure-cli-latest
echo "Definindo os appsettings para o conteiner web : $APPLICATION_NAME"
az webapp config appsettings set \
--subscription $AZURE_CLOUD_SUBSCRIPTIONS_ID \
--resource-group $RESOURCE_NAME \
--name $APPLICATION_NAME  \
--settings \
 ASPNETCORE_URLS=https://+:80 \
 ASPNETCORE_ENVIRONMENT=Production \
 TZ=America/Fortaleza \
  WEBSITES_PORT=80 \
  HostNameHealthCheck=https://localhost:80


#Limpar a implantação

#echo "Excluindo o recurso: $RESOURCE_NAME"
#az group delete --subscription $AZURE_CLOUD_SUBSCRIPTIONS_ID --name $RESOURCE_NAME --yes

echo "Efetuando logoff azure"
az logout
