#!/bin/bash

echo "🚀 Creando estructura frontend..."

# Crear carpetas base
mkdir -p frontend/src

# Crear Dockerfile
cat <<EOL > frontend/Dockerfile
# Build stage
FROM node:20-alpine as build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build --prod

# Serve stage
FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOL

# Crear .dockerignore
cat <<EOL > frontend/.dockerignore
node_modules/
dist/
.git/
EOL

# Crear README
cat <<EOL > frontend/README.md
# Frontend - Angular

## Instalación local

npm install

## Desarrollo

ng serve

## Build producción

npm run build

## Ejecutar con Docker

Desde la carpeta infra:

docker-compose up --build

## Notas

- El build se genera dentro del contenedor
- Se sirve con Nginx en el puerto 80
EOL

echo "✅ Frontend base creado correctamente"
