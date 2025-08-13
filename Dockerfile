# =========================
# Etap 1: Build Angular + .NET
# =========================

# 1. Budujemy Angulara
FROM node:20 AS nodebuild
WORKDIR /src/portfolio-client                 # tu jest Twój frontend
COPY portfolio-client/package*.json ./        # kopiuje package.json i package-lock.json
RUN npm install                               # instaluje paczki
COPY portfolio-client/. .                     # kopiuje resztę kodu frontendu
RUN npm run build -- --configuration production

# 2. Budujemy backend .NET
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS dotnetbuild
WORKDIR /src
COPY PortfolioApi/*.csproj ./PortfolioApi/    # kopiuje plik projektu backendu
RUN dotnet restore PortfolioApi/PortfolioApi.csproj
COPY PortfolioApi/. ./PortfolioApi/           # kopiuje cały backend
COPY --from=nodebuild /src/portfolio-client/dist ./PortfolioApi/wwwroot  # wrzuca Angulara do wwwroot
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
