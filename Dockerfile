# ================================
# 1. Build Angular frontend
# ================================
FROM node:20 AS build-frontend
# używamy Node do budowania Angulara

WORKDIR /app
# ustawiamy katalog roboczy

COPY portfolio-client/package*.json ./
# kopiujemy package.json i package-lock.json

RUN npm install
# instalujemy zależności

COPY portfolio-client/ ./
# kopiujemy cały kod Angulara

RUN npm run build --prod
# budujemy produkcyjną wersję Angulara


# ================================
# 2. Build .NET backend
# ================================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-backend
WORKDIR /src
# Kopiujemy plik projektu, żeby lepiej cache'ować restore
COPY ./PortfolioApi/*.csproj ./
RUN dotnet restore
# Kopiujemy cały kod backendu
COPY ./PortfolioApi/ ./
# Kopiujemy zbudowany frontend do wwwroot
COPY --from=build-frontend /app/dist ./wwwroot
# Publikujemy aplikację
RUN dotnet publish -c Release -o /app/publish

# ================================
# 3. Runtime image
# ================================
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-backend /app/publish .
ENTRYPOINT ["dotnet", "PortfolioApi.dll"]
