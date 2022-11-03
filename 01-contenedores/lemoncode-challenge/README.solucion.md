# Mi solución al reto de Lemoncode


## Pasos a seguir

## Crear la red


```sh
# Creamos la red para la aplicación
docker network create lemoncode-challenge
```

## Crear volumen y base de datos

```sh
# Creamos el volumen para la base de datos
docker volume create --name=some-mongo-volume

# Creamos el contenedor de la base de datos (mongoDB)
docker run -d --name some-mongo \
    -p 27017:27017 \
    --network lemoncode-challenge \
    -v some-mongo-volume:/data/db \
    mongo

# En producción se recomienda usar un usuario con password, pero no lo añado porque requiere más cambios en el servidor dotnet
#    -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
#    -e MONGO_INITDB_ROOT_PASSWORD=secret \

# He usado Mongodb Compass con usuario mongoadmin y contraseña secret 
# Creado la base de datos con Database Name "TopicstoreDb" y la Collection Name "Topics"
# Y añadido desde la herramienta algunos ejemplos de datos. 
# Adjunto capturas de pantalla de los pasos.
```

Registros agregados en el fichero Topics.csv:

```csv
Name,_id
Contenedores,5fa2ca6abe7a379ec4234883
Orquestación,6gb3db7bcf8b413ae2345622
Fundamentos Linux,1ab3dc6ggc4a234bm522423
Cloud,2bd3dc6ggc4a234bm123456
```

## Crear servidor backend. Opción dotnet

Crear un contenedor dotnet con el código de `dotnet-stack/backend` y el nuevo fichero `01-contenedores/lemoncode-challenge/dotnet-stack/backend/Dockerfile`:

```dockerfile
FROM amd64/buildpack-deps:bullseye-scm

ENV \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetCoreSDK-Debian-11

# Install .NET CLI dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu67 \
        libssl1.1 \
        libstdc++6 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK
RUN sdk_version=3.1.424 \
    && curl -fSL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$sdk_version/dotnet-sdk-$sdk_version-linux-x64.tar.gz \
    && dotnet_sha512='5f9fc353eb826c99952582a27b31c495a9cffae544fbb9b52752d2ff9ca0563876bbeab6dc8fe04366c23c783a82d080914ebc1f0c8d6d20c4f48983c303bf18' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -oxzf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    # Trigger first run experience by running arbitrary cmd
    && dotnet help

WORKDIR /App
COPY . ./
EXPOSE 5000

CMD dotnet run
```

Y el fichero .dockerignore para no incluir código no necesario:

```
bin/
obj/
```

Y construir la imagen con el siguiente comando:

```sh
# Y construirlo con el nombre topics-api:
cd dotnet-stack/backend/ ; docker build -t topics-api .
```

Y arrancar un contenedor con dicha imagen:

```sh
# Y arrancarlo:
docker run -d --name topics-api \
    -p 5000:5000 \
    --network lemoncode-challenge \
    topics-api
```

### Crear servidor frontend



Creamos el `dotnet-stack/frontend/Dockerfile`:

```dockerfile
FROM node:14-alpine

ENV NODE_ENV=production

WORKDIR /usr/src/app

COPY ["package.json", "package-lock.json*", "server.js", "views", "./"]

# RUN npm install --production --silent && mv node_modules ../
RUN npm install --production --silent

COPY . .

EXPOSE 3000

RUN chown -R node /usr/src/app

USER node

CMD ["npm", "start"]
```

Y generamos la imagen:

```sh
# Generar la imagen:
cd dotnet-stack/frontend/ ; docker build -t lemoncode-challenge-frontend .
```

Crear un container con la imagen.

```sh
# La ejecutamos en la red lemoncode-challenge
docker run -d --name lemoncode-challenge-frontend --network lemoncode-challenge -e API_URI=http://topics-api:5000/api/topics -p 8080:3000 lemoncode-challenge-frontend
```

Visitar http://localhost:8080/

## Limpieza

Limpieza de los datos para poder volver a aplicar los pasos de mi solución en limpio.
La utilizo para asegurarme de que son necesarios exactamente los pasos que he definido y de que no me olvido ninguno.

```sh
# Borrado de la red creada para la aplicación
docker network rm lemoncode-challenge
# Parar y borrar el contenedor de mongo
docker stop some-mongo
docker rm some-mongo
# Borrado del volumne para la base de datos
docker volume rm some-mongo-volume
# Borrado del contenedor topics-api (dotnet)
docker stop topics-api
docker rm topics-api
# Borrado de la imagen topics-api (dotnet)
docker image rm topics-api:latest
# Borrado del contenedor lemoncode-challenge-frontend
docker stop lemoncode-challenge-frontend
docker rm lemoncode-challenge-frontend
# Borrado de la imagen lemoncode-challenge-frontend
docker image rm lemoncode-challenge-frontend
# Fin de los pasos
```
