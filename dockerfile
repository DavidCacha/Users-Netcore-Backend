# Usa la imagen oficial de .NET Core
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 8080

# Usa la imagen de .NET SDK para compilar
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copia el archivo de proyecto y restaura dependencias
COPY ["NetCoreApi.csproj", "./"]
RUN dotnet restore "./NetCoreApi/NetCoreApi.csproj"

# Copia el código fuente y compílalo
COPY . .
RUN dotnet publish "./NetCoreApi/NetCoreApi.csproj" -c Release -o /app/publish

# Usa la imagen base y copia los archivos compilados
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
CMD ["dotnet", "NetCoreApi.dll"]
