# se está no pipeline automatizado
if [[ "${TF_BUILD}" ]]
then 
    echo "Iniciando as configurações das rotinas de C.I e C.D No Azure DevOps Pipeline"
else

    echo "Iniciando as configurações das rotinas de C.I e C.D local"
   
    . ./infra-as-a-code/configurations-rotina.dev.secrets
fi

echo "Definindo as configurações do projeto"
az devops configure --defaults organization=$AZURE_DEVOPS_ORGANIZACAO project=$AZURE_DEVOPS_PROJETO


echo "Fazendo login"
echo $AZURE_DEVOPS_TOKEN | az devops login --organization $AZURE_DEVOPS_ORGANIZACAO

echo "Criando um projeto"
az devops project create --name $AZURE_DEVOPS_PROJETO \
                         --description "Teste azure devops CLI" \
                         --detect false \
                         --org $AZURE_DEVOPS_ORGANIZACAO \
                         --source-control git \
                         --visibility private

#az devops service-endpoint list --project $AZURE_DEVOPS_PROJETO
echo "Criando um Service Connection com github"
export GIT_HUB_SERVICE_CONNECT="GitHub-LeandroBianch"
SERVICE_CONNECTION_GITHUB_JSON=$(az devops service-endpoint github create --github-url "${GIT_HUB_URL}/etapas-ci-cd-net-core-corporativo-com-docker" \
                                         --name ${GIT_HUB_SERVICE_CONNECT} \
                                         --detect false \
                                         --org $AZURE_DEVOPS_ORGANIZACAO \
                                         --project $AZURE_DEVOPS_PROJETO)

SERVICE_CONNECTION_GITHUB_ID=$(echo $SERVICE_CONNECTION_GITHUB_JSON | ./tools/jq.exe '. | {id : .id, name: .name }' | grep -Po '(?<="id": ").*(?=",)')

#echo $(cat ./tools/teste.json) | ./tools/jq.exe '. | {id : .id}'
echo "Criando Pipeline Azure Build - CI/CD"
az pipelines create --name build-ci-cd \
                    --branch master \
                    --description "Pipeline criado via cli" \
                    --detect false \
                    --org $AZURE_DEVOPS_ORGANIZACAO \
                    --project $AZURE_DEVOPS_PROJETO \
                    --repository "${GIT_HUB_URL}/etapas-ci-cd-net-core-corporativo-com-docker" \
                    --repository-type github \
                    --service-connection $SERVICE_CONNECTION_GITHUB_ID \
                    --skip-first-run true \
                    --yaml-path ./infra-as-a-code/azure/azure-pipelines.yml


ARQUIVO_SECURITY="./infra-as-a-code/azure/service-connect.azure-secret.json"

removerArquivoSecrets () {
  echo "Tentando excluir"
  if [ -f $ARQUIVO_SECURITY ] 
  then
    echo "Removendo o arquivo security $ARQUIVO_SECURITY"
    rm $ARQUIVO_SECURITY
  fi
}

removerArquivoSecrets

echo "Realizando o replace token do service connect azure, gerando o arquivo  token do service connect azure $ARQUIVO_SECURITY"

cat ./infra-as-a-code/azure/service-connect-dockerhub.azure.json | \
sed 's/$USERNAME/'"${DOCKER_REGISTRY_SERVER_USERNAME}"'/' | \
sed 's/$PASSWORD/'"${DOCKER_REGISTRY_SERVER_PASSWORD}"'/' | \
sed 's/$REGISTRY_URL/'"${DOCKER_REGISTRY_SERVER_URL}"'/'  | \
sed 's/$NAME_SERVICE/'"${AZURE_DEVOPS_NAME_SERVICE_CONNECT}"'/' | \
sed 's/$DESCRIPTION/'"${AZURE_DEVOPS_DESCRIPTION_SERVICE_CONNECT}"'/' >> $ARQUIVO_SECURITY

echo "Criando service connect com docker hub"
SERVICE_CONNECTION_DOCKERHUB_JSON=$(az devops service-endpoint create --service-endpoint-configuration $ARQUIVO_SECURITY)

SERVICE_CONNECTION_DOCKER_HUB_ID=$(echo $SERVICE_CONNECTION_DOCKERHUB_JSON | ./tools/jq.exe '. | {id : .id, name: .name }' | grep -Po '(?<="id": ").*(?=",)')

echo "Atribuindo permissão do Docker Hub para todos os pipelines"
az devops service-endpoint update --id $SERVICE_CONNECTION_DOCKER_HUB_ID \
                                  --org $AZURE_DEVOPS_ORGANIZACAO \
                                  --project $AZURE_DEVOPS_PROJETO \
                                  --detect false \
                                  --enable-for-all true 


removerArquivoSecrets

echo "Criando grupo de variaveis connect com docker hub"
az pipelines variable-group create \
--org $AZURE_DEVOPS_ORGANIZACAO \
--project $AZURE_DEVOPS_PROJETO \
--name ${AZURE_DEVOPS_VARIABLE_GROUP} \
--variables $(cat ./infra-as-a-code/azure/variable-group.secrets) \
--authorize true \
--description "Criação de variaveis para o projeto ${AZURE_DEVOPS_VARIABLE_GROUP}"
                                   
 