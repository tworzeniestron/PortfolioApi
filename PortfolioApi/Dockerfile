# ===== Etap 1: Build Angular =====
FROM node:20 AS build-angular
WORKDIR /app
COPY portfolio-client ./portfolio-client
WORKDIR /app/portfolio-client
RUN npm install
RUN npm run build --prod

# ===== Etap 2: Build .NET Backend =====
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-dotnet
WORKDIR /src
COPY . .
COPY --from=build-angular /app/portfolio-client/dist/portfolio-client ./wwwroot
RUN dotnet restore PortfolioApi.csproj
RUN dotnet publish PortfolioApi.csproj -c Release -o /app/publish

# ===== Etap 3: Runtime =====
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build-dotnet /app/publish .
ENTRYPOINT ["dotnet", "PortfolioApi.dll"]
