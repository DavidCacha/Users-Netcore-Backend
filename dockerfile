FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar el archivo de proyecto y restaurar dependencias
COPY ["NetCoreApi/NetCoreApi.csproj", "NetCoreApi/"]
WORKDIR "/src/NetCoreApi"
RUN dotnet restore "NetCoreApi.csproj"

# Copiar y compilar el código fuente
COPY . .
RUN dotnet publish "NetCoreApi.csproj" -c Release -o /app/publish

# Crear la imagen final
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
CMD ["dotnet", "NetCoreApi.dll"]
