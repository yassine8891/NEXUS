# ---------- Build Stage (.NET 10) ----------
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .

# Restore & publish the AppHost explicitly
RUN dotnet restore "ASPIRE.AppHost/ASPIRE.AppHost.csproj"
# Publish to a known folder under /app/publish
RUN dotnet publish "ASPIRE.AppHost/ASPIRE.AppHost.csproj" -c Release -o /app/publish

# ---------- Runtime Stage (.NET 10 ASP.NET) ----------
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app

# Copy published output from the build stage
COPY --from=build /app/publish .

# Environment configuration
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://0.0.0.0:8080

# Launch the AppHost server
ENTRYPOINT ["dotnet", "ASPIRE.AppHost.dll", "--launch-profile", "ASPIRE.AppHost Production"]
