#importa as configurações de variaveis de ambiente
. ./infra-as-a-code/configurations-rotinas.sh

log() {
    
    patternLog="$(date +'%y-%m-%d-%H:%M:%S')  $1"
    
    echo $patternLog
}

#docker-compose -f ./infra-as-a-code/docker/Docker-compose.yml up -d
 
# Tarefas que são executadas no docker file (restore, build, testes e sonar)
log "Iniciando o teste"
docker build . --file ./infra-as-a-code/docker/Dockerfile.web --no-cache  \
--build-arg VERSION_NUMBER="${VERSION_NUMBER}" \
--build-arg SONAR_PROJECT_KEY="$SONAR_PROJECT_KEY" \
--build-arg SONAR_ORGANIZATION_KEY="$SONAR_ORGANIZATION_KEY" \
--build-arg SONAR_HOST_URL="$SONAR_HOST_URL" \
--build-arg SONAR_TOKEN="$SONAR_TOKEN" \
--tag "$IMAGE_NAME:${VERSION_NUMBER}" \
--tag "$IMAGE_NAME"

echo "$IMAGE_NAME"

docker images

# autentincar no docker hub
# echo "$DOCKER_REGISTRY_SERVER_PASSWORD" | \
# docker login "$DOCKER_REGISTRY_SERVER_URL" \
# --username "$DOCKER_REGISTRY_SERVER_USERNAME" \
# --password-stdin \
# && docker push "$DOCKER_REGISTRY_SERVER_URL/$IMAGE_NAME"

# realiza o push da imagem
#docker push "$DOCKER_REGISTRY_SERVER_URL/$IMAGE_NAME"

# remover container que não estão em uso.
docker container prune --force
docker image prune --force