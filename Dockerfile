#Multi Stages
# Imagem que contém o SDK, necessário para compilar e gerar o publish da aplicação
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 as buildComPublish
COPY ./ ./build
WORKDIR /build
RUN dotnet build 
RUN dotnet test ./tests/docker-deploy-artifacts-tests.csproj --logger "trx;LogFileName=docker-deploy-artifacts-tests.trx"
RUN dotnet publish ./src/docker-deploy-artifacts.csproj --output ./artifacts --configuration Release

# Imagem que contém o  runtime, que é a versão 'mais enxuto', necessário apenas para executar o program, por exemplo a .dll do publish
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 as publish
WORKDIR /aplicacao
COPY --from=buildComPublish /build/artifacts ./

# opcional
EXPOSE 8082
ENV ASPNETCORE_URLS=http://+:8082 
ENV ASPNETCORE_ENVIRONMENT=Starging 

ENTRYPOINT ["dotnet", "docker-deploy-artifacts.dll"]
