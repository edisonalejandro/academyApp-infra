# Infraestructura - Docker

## Levantar entorno completo

cd infra
docker-compose up --build

## Servicios

Frontend: http://localhost:${FRONTEND_PORT}
Backend: http://localhost:${BACKEND_PORT}
PostgreSQL: localhost:${POSTGRES_PORT}

## Variables

Se configuran en el archivo .env

## Notas importantes

- Backend se conecta a PostgreSQL usando hostname: postgres
- No usar localhost dentro de contenedores
