# =========================
# Etap 1: Build Angular
# =========================
FROM node:20 AS nodebuild
WORKDIR /src/portfolio-client
COPY ./portfolio-client/package*.json ./
RUN npm ci --omit=dev
COPY ./portfolio-client/. .
RUN npm run build -- --configuration production

# =========================
# Etap 2: Build .NET backend
# =========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS dotnetbuild
WORKDIR /src
COPY ./PortfolioApi/*.csproj ./PortfolioApi/
RUN dotnet restore ./PortfolioApi/PortfolioApi.csproj --disable-parallel
COPY ./PortfolioApi/. ./PortfolioApi/
# kopiujemy już zbudowany Angular -> wwwroot
COPY --from=nodebuild /src/portfolio-client/dist ./PortfolioApi/wwwroot
WORKDIR /src/PortfolioApi
RUN dotnet publish -c Release -o /app/publish

# =========================
# Etap 3: Runtime
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=dotnetbuild /app/publish .
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "PortfolioApi.dll"]
