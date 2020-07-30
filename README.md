# etapas-ci-cd-net-core-corporativo-com-docker
Projeto que irá conter todas as etapas de esteiras das etapas corporativas de (build, testes e deploy)
1. dotnet publish .\src\docker-deploy-artifacts.csproj -o .\artifacts\web

2. dotnet .\artifacts\web\docker-deploy-artifacts.dll

3. (Rodar no power shell) rodar um container docker run --workdir "/aplicacao" --entrypoint "bash" -p 8081:8081 --env ASPNETCORE_URLS=http://+:8081 --env ASPNETCORE_ENVIRONMENT=Starging --volume $pwd/artifacts/web/:/aplicacao --name docker-deploy-artifacts-na-mao mcr.microsoft.com/dotnet/core/aspnet:3.1 -c "dotnet docker-deploy-artifacts.dll"

4 docker ps (exibe todos os container rodando)
