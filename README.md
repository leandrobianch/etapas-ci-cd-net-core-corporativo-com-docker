# etapas-ci-cd-net-core-corporativo-com-docker
Projeto que irá conter todas as etapas de esteiras das etapas corporativas de (build, testes e deploy)

Pré-requesito:

DOT.NET SDK 3.1: https://dotnet.microsoft.com/download/dotnet-core/3.1
Docker: https://www.docker

1. dotnet publish .\src\docker-deploy-artifacts.csproj -o .\artifacts\web

2. dotnet .\artifacts\web\docker-deploy-artifacts.dll

3. (Rodar no power shell) rodar um container 
    .\criar-container.ps1

4 docker ps (exibe todos os container rodando)
