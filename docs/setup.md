# Setup del Proyecto

## Requisitos

- Docker y Docker Compose (para producción / stack completo)
- Java 21 + Maven (para desarrollo local del backend)
- Node.js 20+ (para desarrollo local del frontend)
- PostgreSQL 15 corriendo localmente (solo si desarrollas el backend sin Docker)

---

## 🔵 Producción — Stack completo con Docker

```bash
# 1. Configurar variables de entorno
cd infra
cp .env.example .env
# Editar .env con los valores reales

# 2. Levantar todos los servicios
docker-compose up --build
```

**Accesos:**
- Frontend: http://localhost:4200
- Backend API: http://localhost:8080/api
- Swagger UI: http://localhost:8080/swagger-ui.html
- Base de datos: localhost:5432

---

## 🟢 Desarrollo local — Backend sin Docker

El perfil `dev` activa `application-dev.properties`:
- Conecta a PostgreSQL local en `localhost:5432`
- Muestra SQL en consola (`show-sql=true`)
- Logging en nivel DEBUG

**Opción A — Solo la base de datos en Docker, backend local:**
```bash
# Levantar solo PostgreSQL
cd infra
docker-compose up -d postgres

# Iniciar backend en modo dev
cd ../backend
./run-dev.sh
```

**Opción B — PostgreSQL instalado localmente:**
```bash
cd backend
./run-dev.sh
```

> Asegúrate de tener la base de datos `academia_baile` creada y los valores correctos en `application-dev.properties`.

---

## 🟢 Desarrollo local — Frontend

```bash
cd frontend
npm install
npm start
# Accede en http://localhost:4200
# Las llamadas API van a http://localhost:8080/api (environment.ts)
```

---

## Variables de entorno

| Archivo | Propósito |
|---|---|
| `infra/.env` | Valores reales de producción — **NUNCA commitear** |
| `infra/.env.example` | Plantilla con nombres de variables — sí se commitea |
| `backend/src/main/resources/application-dev.properties` | Config de desarrollo local — **NUNCA commitear** |
| `backend/src/main/resources/application-prod.properties` | Config de producción (lee vars de entorno) — sí se commitea |
