# 1. Build Angular frontend
FROM node:20 AS build-frontend           # używamy Node do budowania Angulara
WORKDIR /app                             # ustawiamy katalog roboczy
COPY portfolio-client/package*.json ./   # kopiujemy package.json i package-lock.json
RUN npm install                          # instalujemy paczki
COPY portfolio-client/ ./                # kopiujemy resztę plików Angulara
RUN npm run build --prod                  # budujemy Angulara

# 2. Build .NET backend
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-backend
WORKDIR /src
COPY PortfolioApi/*.csproj ./             # kopiujemy csproj
RUN dotnet restore                        # przywracamy paczki NuGet
COPY PortfolioApi/ ./                     # kopiujemy resztę backendu
COPY --from=build-frontend /app/dist /src/wwwroot  # kopiujemy zbudowany frontend
RUN dotnet publish -c Release -o /app/publish

# 3. Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-backend /app/publish ./
ENTRYPOINT ["dotnet", "PortfolioApi.dll"]
