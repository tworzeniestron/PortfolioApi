# =========================
# Etap 1: Build backend .NET
# =========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# kopiujemy pliki csproj
COPY ./PortfolioApi/*.csproj ./PortfolioApi/
RUN dotnet restore ./PortfolioApi/PortfolioApi.csproj --disable-parallel

# kopiujemy cały backend (w tym wwwroot ze zbudowanym frontendem)
COPY ./PortfolioApi/. ./PortfolioApi/

WORKDIR /src/PortfolioApi
RUN dotnet publish -c Release -o /app/publish

# =========================
# Etap 2: Runtime
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "PortfolioApi.dll"]
