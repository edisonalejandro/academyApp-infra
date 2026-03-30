#!/bin/bash

echo "🚀 Creando infraestructura..."

mkdir -p infra/scripts

# =========================
# .env (CONFIG CENTRALIZADA)
# =========================
cat <<EOL > infra/.env
# ========================
# DATABASE
# ========================
POSTGRES_DB=app_db
POSTGRES_USER=admin
POSTGRES_PASSWORD=admin123
POSTGRES_PORT=5432

# ========================
# BACKEND
# ========================
BACKEND_PORT=8080

# ========================
# FRONTEND
# ========================
FRONTEND_PORT=4200
EOL

# =========================
# docker-compose.yml
# =========================
cat <<EOL > infra/docker-compose.yml
version: '3.8'

services:

  postgres:
    image: postgres:15
    container_name: postgres_db
    restart: always
    env_file:
      - .env
    ports:
      - "\${POSTGRES_PORT}:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  backend:
    build: ../backend
    container_name: backend_app
    restart: always
    depends_on:
      - postgres
    ports:
      - "\${BACKEND_PORT}:8080"
    env_file:
      - .env
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/\${POSTGRES_DB}
      SPRING_DATASOURCE_USERNAME: \${POSTGRES_USER}
      SPRING_DATASOURCE_PASSWORD: \${POSTGRES_PASSWORD}

  frontend:
    build: ../frontend
    container_name: frontend_app
    restart: always
    depends_on:
      - backend
    ports:
      - "\${FRONTEND_PORT}:80"

volumes:
  postgres_data:
EOL

# =========================
# README infra
# =========================
cat <<EOL > infra/README.md
# Infraestructura - Docker

## Levantar entorno completo

cd infra
docker-compose up --build

## Servicios

Frontend: http://localhost:\${FRONTEND_PORT}
Backend: http://localhost:\${BACKEND_PORT}
PostgreSQL: localhost:\${POSTGRES_PORT}

## Variables

Se configuran en el archivo .env

## Notas importantes

- Backend se conecta a PostgreSQL usando hostname: postgres
- No usar localhost dentro de contenedores
EOL

echo "✅ Infraestructura creada correctamente"
