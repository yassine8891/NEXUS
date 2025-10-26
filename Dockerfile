# ---------- Build (NET 10) ----------
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .

# Restore & publish the AppHost explicitly
RUN dotnet restore "ASPIRE.AppHost/ASPIRE.AppHost.csproj"
# publish to a stable, known directory
RUN dotnet publish "ASPIRE.AppHost/ASPIRE.AppHost.csproj" -c Release -o /out

# ---------- Runtime (NET 10 ASP.NET) ----------
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
# copy from the /out folder we created in the build stage
COPY --from=build /out .

ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
ENTRYPOINT ["dotnet","ASPIRE.AppHost.dll","--launch-profile","ASPIRE.AppHost Production"]
