# ---------- Build Stage (.NET 10) ----------
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .

# Restore & publish the AppHost explicitly to a known directory
RUN dotnet restore "ASPIRE.AppHost/ASPIRE.AppHost.csproj"
RUN mkdir -p /publish \
 && dotnet publish "ASPIRE.AppHost/ASPIRE.AppHost.csproj" -c Release -o /publish

# ---------- Runtime Stage (.NET 10 ASP.NET) ----------
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app

# Copy the published files from the build stage
COPY --from=build /publish .

# ASP.NET hosting
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://0.0.0.0:8080

ENTRYPOINT ["dotnet","ASPIRE.AppHost.dll","--launch-profile","ASPIRE.AppHost Production"]
