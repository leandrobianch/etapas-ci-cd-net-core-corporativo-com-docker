# etapas-ci-cd-net-core-corporativo-com-docker
Projeto irá conter todas as etapas de esteiras das etapas corporativas de (build, testes e deploy)

# Pré-requisitos:

Instalar DOT.NET SDK 3.1: https://dotnet.microsoft.com/download/dotnet-core/3.1
Docker: https://www.docker

**1. Gerar os artefatos de deploy**
```ps
dotnet publish .\src\docker-deploy-artifacts.csproj -o .\artifacts\web
```

**2. Executar a aplicação web fora do container**
```ps
dotnet .\artifacts\web\docker-deploy-artifacts.dll
```

**3. Executar um container**
```ps
docker run `
--workdir "/aplicacao" `
--entrypoint "bash" `
-p 8081:8081 `
--env ASPNETCORE_URLS=http://+:8081 `
--env ASPNETCORE_ENVIRONMENT=Starging `
--volume $pwd/artifacts/web/:/aplicacao `
--name docker-deploy-artifacts-na-mao `
mcr.microsoft.com/dotnet/core/aspnet:3.1 `
-c "dotnet docker-deploy-artifacts.dll"
```

**4. Exibe todos os container em execução**
```ps
docker ps 
```
