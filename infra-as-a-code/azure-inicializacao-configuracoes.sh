# se está no pipeline automatizado
if [[ "${TF_BUILD}" ]]
then 
    echo "Iniciando as configurações das rotinas de C.I e C.D No Azure DevOps Pipeline"
else

    echo "Iniciando as configurações das rotinas de C.I e C.D local"
   
    . ./infra-as-a-code/configurations-rotina.dev.secrets
fi

echo "Definir configurações do projeto"
az devops configure --defaults organization=$AZURE_DEVOPS_ORGANIZACAO project=$AZURE_DEVOPS_PROJETO


echo "Fazendo login"
echo $AZURE_DEVOPS_TOKEN | az devops login --organization $AZURE_DEVOPS_ORGANIZACAO


ARQUIVO_SECURITY="./infra-as-a-code/azure/service-connect.azure-secret.json"

if [ -z $ARQUIVO_SECURITY ] 
then
  echo "Removendo o arquivo security $ARQUIVO_SECURITY"
  rm $ARQUIVO_SECURITY
fi

echo "Realizando o replace token do service connect azure, gerando o arquivo  token do service connect azure $ARQUIVO_SECURITY"

cat ./infra-as-a-code/azure/service-connect.azure.json | \
sed 's/$USERNAME/'"${DOCKER_REGISTRY_SERVER_USERNAME}"'/' | \
sed 's/$PASSWORD/'"${DOCKER_REGISTRY_SERVER_PASSWORD}"'/' | \
sed 's/$REGISTRY_URL/'"${DOCKER_REGISTRY_SERVER_URL}"'/'  | \
sed 's/$NAME_SERVICE/'"${AZURE_DEVOPS_NAME_SERVICE_CONNECT}"'/' | \
sed 's/$DESCRIPTION/'"${AZURE_DEVOPS_DESCRIPTION_SERVICE_CONNECT}"'/' >> $ARQUIVO_SECURITY

echo "Criando service connect com docker hub"
az devops service-endpoint create --service-endpoint-configuration $ARQUIVO_SECURITY

echo "Removendo o arquivo security $ARQUIVO_SECURITY"
if [ -z $ARQUIVO_SECURITY ] 
then
  echo "Removendo o arquivo security $ARQUIVO_SECURITY"
  rm $ARQUIVO_SECURITY
fi

echo "Criando grupo de vari connect com docker hub"
az pipelines variable-group create \
--org $AZURE_DEVOPS_ORGANIZACAO \
--project $AZURE_DEVOPS_PROJETO \
--name ${APPLICATION_NAME} \
--variables cat ./infra-as-a-code/azure/variable-group.secrets \
--authorize true \
--description "Criação de variaveis para o projeto ${APPLICATION_NAME}" 
                                   
                                   
