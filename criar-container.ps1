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