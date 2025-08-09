FROM node:20 AS build-frontend
WORKDIR /app
COPY /portfolio-client/package*.json ./
RUN npm install
COPY /portfolio-client/ ./
RUN npm run build --prod


FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-backend
WORKDIR /src
COPY PortfolioApi/*.csproj ./
RUN dotnet restore
COPY PortfolioApi/ ./
COPY --from=build-frontend /app/dist ./wwwroot
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-backend /app/publish .
ENTRYPOINT ["dotnet", "PortfolioApi.dll"]
