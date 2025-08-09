# ================================
# 1. Budowanie Angulara (frontend)
# ================================
FROM node:20 AS build-frontend
WORKDIR /app
COPY ../portfolio-client ./
RUN npm install
RUN npm run build --prod

# ================================
# 2. Budowanie .NET API (backend)
# ================================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-backend
WORKDIR /src
COPY . ./
COPY --from=build-frontend /app/dist ./wwwroot
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish

# ================================
# 3. Finalny obraz (runtime)
# ================================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build-backend /app/publish .
EXPOSE 80
ENTRYPOINT ["dotnet", "PortfolioApi.dll"]
