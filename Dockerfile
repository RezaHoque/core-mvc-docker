FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5000
EXPOSE 443
ENV ASPNETCORE_URLS=http://*:5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["core-mvc-docker.csproj", "./"]
RUN dotnet restore "./core-mvc-docker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "core-mvc-docker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "core-mvc-docker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "core-mvc-docker.dll"]
