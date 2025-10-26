# ---------- Build stage ----------
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# copy the whole repo (you can optimize later)
COPY . .

# restore & publish only the AppHost project
RUN dotnet restore ASPIRE.AppHost/ASPIRE.AppHost.csproj
RUN dotnet publish ASPIRE.AppHost/ASPIRE.AppHost.csproj -c Release -o /app/publish


# ---------- Runtime stage ----------
FROM mcr.microsoft.com/dotnet/aspnet:10.0

# Install curl for Coolify's healthcheck
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=build /app/publish .

# App settings
ENV ASPNETCORE_ENVIRONMENT=Production \
    ASPNETCORE_URLS=http://0.0.0.0:8080

# Web UI + game port (adjust if needed)
EXPOSE 8080 8888

# Start the AppHost
ENTRYPOINT ["dotnet", "ASPIRE.AppHost.dll"]
