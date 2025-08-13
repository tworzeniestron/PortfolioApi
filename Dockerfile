# =========================
# Etap 1: Build Angular + .NET
# =========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
FROM node:20 AS nodebuild

# Skopiuj Angulara
WORKDIR /src/portfolio-client
COPY portfolio-client/package*.json ./
RUN npm install
COPY portfolio-client/. .
RUN npm run build -- --configuration production

# Skopiuj backend i wklej Angulara do wwwroot
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS dotnetbuild
WORKDIR /src
COPY PortfolioApi/*.csproj ./PortfolioApi/
RUN dotnet restore PortfolioApi/PortfolioApi.csproj
COPY PortfolioApi/. ./PortfolioApi/
COPY --from=nodebuild /src/portfolio-client/dist ./PortfolioApi/wwwroot
WORKDIR /src/PortfolioApi
RUN dotnet publish -c Release -o /app/publish

# =========================
# Etap 2: Runtime
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=dotnetbuild /app/publish .
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "PortfolioApi.dll"]
