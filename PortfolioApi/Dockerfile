# ================================
# 1. Budowanie Angulara (frontend)
# ================================
FROM node:20 AS build-frontend                   # Etap builda Angulara
WORKDIR /app                                      # Katalog roboczy
COPY ../portfolio-client ./                       # Kopiujemy Angulara z folderu obok
RUN npm install                                   # Instalujemy paczki
RUN npm run build --prod                          # Budujemy frontend (produkcyjnie)

# ================================
# 2. Budowanie .NET API (backend)
# ================================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-backend  # Etap builda .NET
WORKDIR /src                                            # Katalog roboczy
COPY . ./                                                # Kopiujemy backend
COPY --from=build-frontend /app/dist ./wwwroot          # Doklejamy build Angulara
RUN dotnet restore                                       # Przywracamy NuGet
RUN dotnet publish -c Release -o /app/publish            # Publikujemy aplikacjê

# ================================
# 3. Finalny obraz (runtime)
# ================================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final        # Runtime
WORKDIR /app
COPY --from=build-backend /app/publish .                 # Kopiujemy opublikowane pliki
EXPOSE 80                                                # Wystawiamy port
ENTRYPOINT ["dotnet", "PortfolioApi.dll"]                # Start aplikacji
