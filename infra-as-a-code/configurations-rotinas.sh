# ci - configurações
export VERSION_NUMBER=$(date +"%d.%m.%Y.%H.%M.%S")
export SONAR_HOST_URL="https://sonarcloud.io" 
export SONAR_PROJECT_KEY="leandrobianch_etapas-ci-cd-net-core-corporativo-com-docker" 
export SONAR_ORGANIZATION_KEY="" 
export SONAR_TOKEN="" 

# cd - configurações
export TENANT=usuario.onmicrosoft.com
export CLIENT_ID=
export TOKEN_CLIENT_ID=
export SUBSCRIPTIONS_ID=''
export RESOURCE_NAME='resource-name-etapas-ci-cd-net-core-corporativo-com-docker'
export PLAN_NAME='plan-name-etapas-ci-cd-net-core-corporativo-com-docker'
export CONFIGURATION_APPLICATION_NAME='configuration-name-etapas-ci-cd-net-core-corporativo-com-docker'
export APPLICATION_NAME='app-name-etapas-ci-cd-net-core-corporativo-com-docker'

# configuraões gerais.
export DOCKER_REGISTRY_SERVER_URL=index.docker.io
export DOCKER_REGISTRY_SERVER_USERNAME=
export DOCKER_REGISTRY_SERVER_PASSWORD= 
export IMAGE_NAME=$DOCKER_REGISTRY_SERVER_USERNAME/etapas-ci-cd-net-core-corporativo-com-docker