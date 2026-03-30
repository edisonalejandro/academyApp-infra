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
