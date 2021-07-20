﻿FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["TwitchWatch/TwitchWatch.csproj", "TwitchWatch/"]
RUN dotnet restore "TwitchWatch/TwitchWatch.csproj"
COPY . .
WORKDIR "/src/TwitchWatch"
RUN dotnet build "TwitchWatch.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TwitchWatch.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TwitchWatch.dll"]
