Pré requisitos
1. dotnet publish .\src\docker-deploy-artifacts.csproj -o .\artifacts\web

2. dotnet .\artifacts\web\docker-deploy-artifacts.dll

3. rodar um container 
 docker run `
--workdir "/aplicacao" `
--entrypoint "bash" `
-p 8081:8081 `
--env ASPNETCORE_URLS=http://+:8081 `
--env ASPNETCORE_ENVIRONMENT=Starging `
--volume $pwd/artifacts/web/:/aplicacao `
--name docker-deploy-artifacts-na-mao `
mcr.microsoft.com/dotnet/core/aspnet:3.1 `
-c "dotnet docker-deploy-artifacts.dll" `

4. docker ps (exibe todos os container rodando)

