# Usa la imagen oficial de .NET Core
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 8080

# Usa la imagen de .NET SDK para compilar
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copia el archivo de proyecto y restaura dependencias
COPY ["NetCoreApi/NetCoreApi.csproj", "NetCoreApi/"]
WORKDIR "/src/NetCoreApi"
RUN dotnet restore "NetCoreApi.csproj"

# Copia el resto del código fuente y compílalo
COPY . .
WORKDIR "/src/NetCoreApi"
RUN dotnet publish "NetCoreApi.csproj" -c Release -o /app/publish

# Usa la imagen base y copia los archivos compilados
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .

# Define el comando de inicio
CMD ["dotnet", "NetCoreApi.dll"]
