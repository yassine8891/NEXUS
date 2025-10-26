# ---------- Build (.NET 10) ----------
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .

# Restore & publish the AppHost explicitly
RUN dotnet restore "ASPIRE.AppHost/ASPIRE.AppHost.csproj"
# Let dotnet publish to its default path (bin/Release/<TFM>/publish)
RUN dotnet publish "ASPIRE.AppHost/ASPIRE.AppHost.csproj" -c Release

# ---------- Runtime (.NET 10 ASP.NET) ----------
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app

# Copy the publish output from the build stage's default folder
# The <TFM> folder (e.g., net10.0) is matched by the wildcard
COPY --from=build /src/ASPIRE.AppHost/bin/Release/*/publish/ .

ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
ENTRYPOINT ["dotnet","ASPIRE.AppHost.dll","--launch-profile","ASPIRE.AppHost Production"]
