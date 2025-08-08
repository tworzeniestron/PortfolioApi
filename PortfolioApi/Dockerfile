# ===== Etap 1: Build Angular =====
FROM node:20 AS build-angular
WORKDIR /app
COPY portfolio-client ./portfolio-client                # kopiujemy Angulara
WORKDIR /app/portfolio-client
RUN npm install
RUN npm run build --prod

# ===== Etap 2: Build .NET Backend =====
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-dotnet
WORKDIR /src
COPY PortfolioApi/ ./PortfolioApi/                      # kopiujemy backend
COPY --from=build-angular /app/portfolio-client/dist/portfolio-client ./PortfolioApi/wwwroot
WORKDIR /src/PortfolioApi
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish

# ===== Etap 3: Runtime =====
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build-dotnet /app/publish .
ENTRYPOINT ["dotnet", "PortfolioApi.dll"]
