#!/bin/bash

echo "🚀 Creando estructura backend..."

# Crear carpetas base
mkdir -p backend/src
mkdir -p backend/target

# Crear Dockerfile
cat <<EOL > backend/Dockerfile
FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app

COPY target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
EOL

# Crear .dockerignore
cat <<EOL > backend/.dockerignore
target/
node_modules/
.git/
EOL

# Crear README
cat <<EOL > backend/README.md
# Backend - Spring Boot

## Build del proyecto

mvn clean package

## Ejecutar con Docker

Desde la carpeta infra:

docker-compose up --build

## Notas

- El .jar debe existir en /target antes de construir la imagen
EOL

echo "✅ Backend base creado correctamente"
