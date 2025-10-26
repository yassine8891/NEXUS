# ---------- Build (use .NET 10 SDK) ----------
# If the stable 10.0 images exist for you, use these:
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
# If that tag does not exist in your registry, use the nightly channel instead:
# FROM mcr.microsoft.com/dotnet/nightly/sdk:10.0 AS build

WORKDIR /src
COPY . .

# Restore & publish the AppHost explicitly
RUN dotnet restore "ASPIRE.AppHost/ASPIRE.AppHost.csproj"
RUN dotnet publish "ASPIRE.AppHost/ASPIRE.AppHost.csproj" -c Release -o /app/publish

# ---------- Runtime (use .NET 10 ASP.NET runtime) ----------
FROM mcr.microsoft.com/dotnet/aspnet:10.0
# Or nightly if needed:
# FROM mcr.microsoft.com/dotnet/nightly/aspnet:10.0

WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
ENTRYPOINT ["dotnet","ASPIRE.AppHost.dll","--launch-profile","ASPIRE.AppHost Production"]
