Pré requisitos
1. dotnet publish .\src\docker-deploy-artefacts.csproj -o .\artefacts\web

1. rodar um container 
 docker run `
--workdir "/aplicacao" `
--entrypoint "bash" `
-p 8081:8081 `
--env ASPNETCORE_URLS=http://+:8081 `
--env ASPNETCORE_ENVIRONMENT=Starging `
--volume $pwd/artefacts/web/:/aplicacao `
--name docker-deploy-artefacts-na-mao `
mcr.microsoft.com/dotnet/core/aspnet:3.1 `
-c "dotnet docker-deploy-artefacts.dll" `

2. docker ps (exibe todos os container rodando)

3. docker commit docker-deploy-artefacts-na-mao leandrobianch/deploy-web:1.0.0 (mandar para nuvem no nosso caso para o docker hub ou algum 'registry images')
2. tag
docker tag docker-deploy-artefacts-na-mao leandrobianch/deploy-web:1.0.0