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
**4. 1 Commitando a imagem**
```ps
 docker commit `
 --message 'versao sem build' `
 docker-deploy-artifacts-na-mao  `
 leandrobianch/docker-deploy-artifacts-na-mao:1.0.0 
 ```

**5. Build da imagem**
```ps
docker build . --file Dockerfile `
--tag leandrobianch/docker-deploy-artifacts-na-mao:2.0.0
```
**5.1 docker pull da imagem**
```ps
docker pull leandrobianch/docker-deploy-artifacts-na-mao:2.0.0
```

**6. Build da imagem**
```ps
docker run `
-p 8081:8081 `
--env ASPNETCORE_URLS=http://+:8081 `
--env ASPNETCORE_ENVIRONMENT=Starging `
--name docker-deploy-artifacts-na-mao `
leandrobianch/docker-deploy-artifacts-na-mao:3.0.0
```

**7. push da imagem**
```ps
docker push leandrobianch/docker-deploy-artifacts-na-mao:2.0.0
```


docker run `
-p 8082:8082 `
--env ASPNETCORE_URLS=http://+:8082 `
--env ASPNETCORE_ENVIRONMENT=Starging `
--name docker-deploy-artifacts-na-mao `
leandrobianch/docker-deploy-artifacts-na-mao:1.0.0
