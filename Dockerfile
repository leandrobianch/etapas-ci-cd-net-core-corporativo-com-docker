#Multi Stages
# Imagem que contém o SDK, necessário para compilar e gerar o publish da aplicação
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 as buildComPublish
COPY ./src ./aplicacao
WORKDIR /aplicacao
RUN dotnet publish -o ./artifacts --configuration Release

# Imagem que contém o  runtime, que é a versão 'mais enxuto', necessário apenas para executar o program, por exemplo a .dll do publish
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 as publish
WORKDIR /aplicacao
COPY --from=buildComPublish /aplicacao/artifacts ./

# opcional
EXPOSE 8082
ENV ASPNETCORE_URLS=http://+:8082 
ENV ASPNETCORE_ENVIRONMENT=Starging 

ENTRYPOINT ["dotnet", "docker-deploy-artifacts.dll"]
