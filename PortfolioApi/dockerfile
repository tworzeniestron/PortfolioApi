# ========================
# 1?? Build Angular
# ========================
FROM node:18 AS build-angular
WORKDIR /app
COPY ../portfolio-client ./portfolio-client                       # kopiujemy Angulara
WORKDIR /app/portfolio-client
RUN npm install                                     # instalujemy paczki
RUN npm run build -- --configuration production     # build Angulara w trybie prod

# ========================
# 2?? Build .NET i kopiowanie Angulara do wwwroot
# ========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-dotnet
WORKDIR /src
COPY . .                                            # kopiujemy backend
COPY --from=build-angular /app/portfolio-client/dist ./wwwroot  # przenosimy build Angulara
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish       # publikacja backendu

# ========================
# 3?? Finalny obraz – ASP.NET Core runtime
# ========================
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-dotnet /app/publish .
# automatyczne uruchomienie pierwszego znalezionego pliku .dll
CMD ["sh", "-c", "dotnet $(ls *.dll | head -n 1)"]
