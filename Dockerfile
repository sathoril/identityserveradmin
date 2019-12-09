FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
COPY ["./IdentityServerAdmin.csproj", "IdentityServerAdmin/"]

WORKDIR IdentityServerAdmin

RUN dotnet restore "IdentityServerAdmin.csproj"
COPY . .

RUN dotnet build "IdentityServerAdmin.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "IdentityServerAdmin.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENV ASPNETCORE_URLS=http://+:80
ENV ASPNETCORE_FORWARDEDHEADERS_ENABLED=true
ENV ASPNETCORE_ENVIRONMENT=Development
#ENV ASPNETCORE_APPL_PATH='/identityserver'

ENTRYPOINT ["dotnet", "IdentityServerAdmin.dll"]