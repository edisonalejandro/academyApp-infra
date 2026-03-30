#!/bin/bash

echo "🚀 Creando documentación..."

mkdir -p docs

# =========================
# arquitectura.md
# =========================
cat <<EOL > docs/arquitectura.md
# Arquitectura del Sistema

## Stack tecnológico

- Backend: Spring Boot
- Frontend: Angular
- Base de datos: PostgreSQL
- Infraestructura: Docker Compose

## Diagrama lógico

[ Usuario ]
     |
     v
[ Frontend (Angular) ]
     |
     v
[ Backend (Spring Boot) ]
     |
     v
[ PostgreSQL ]

## Comunicación

- Frontend → Backend: HTTP (REST API)
- Backend → DB: JDBC

## Notas

- Todos los servicios corren en contenedores Docker
- Comunicación interna mediante red Docker
EOL

# =========================
# setup.md
# =========================
cat <<EOL > docs/setup.md
# Setup del Proyecto

## Requisitos

- Docker
- Docker Compose

## Levantar entorno

cd infra
docker-compose up --build

## Accesos

- Frontend: http://localhost:4200
- Backend: http://localhost:8080
- PostgreSQL: localhost:5432

## Variables de entorno

Configurar en infra/.env
EOL

# =========================
# decisiones-tecnicas.md
# =========================
cat <<EOL > docs/decisiones-tecnicas.md
# Decisiones Técnicas

## Uso de Docker

Se utiliza Docker para:
- Asegurar consistencia entre entornos
- Facilitar despliegues
- Aislar servicios

## PostgreSQL

Se selecciona PostgreSQL por:
- Robustez
- Soporte transaccional
- Estándar en backend empresarial

## Arquitectura

Se adopta arquitectura desacoplada:
- Frontend independiente
- Backend API REST
- DB desacoplada

## Escalabilidad

- Preparado para microservicios
- Compatible con Kubernetes
EOL

echo "✅ Documentación creada correctamente"
