# ================================
# 1. Build Angular frontend
# ================================
FROM node:20 AS build-frontend
WORKDIR /app
COPY portfolio-client/ ./
RUN npm install
RUN npm run build --prod

# ================================
# 2. Build .NET backend
# ================================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-backend
WORKDIR /src
COPY PortfolioApi/ ./
COPY --from=build-frontend /app/dist ./wwwroot
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish

# ================================
# 3. Runtime image
# ================================
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-backend /app/publish .
ENTRYPOINT ["dotnet", "PortfolioApi.dll"]
