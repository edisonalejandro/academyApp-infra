# 🚀 Guía Fullstack Profesional: Docker + Perfiles + Variables

---

## 🧠 1. Concepto general

Esta arquitectura separa claramente:

- Código (backend/frontend)
- Infraestructura (Docker)
- Configuración (variables)
- Entornos (dev / prod)

---

# 🧱 2. Estructura del proyecto

```
academia-baile/
│
├── backend/
├── frontend/
├── infra/
│   ├── docker-compose.yml
│   └── .env
└── docs/
```

---

# ⚙️ 3. Perfiles en Spring Boot

## 📁 Archivos

```
src/main/resources/
│
├── application.properties
├── application-dev.properties
└── application-prod.properties
```

---

## 🟢 application-dev.properties

```
spring.datasource.url=jdbc:postgresql://localhost:5432/app_db
spring.datasource.username=admin
spring.datasource.password=admin123

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

logging.level.org.springframework=DEBUG
```

---

## 🔵 application-prod.properties

```
spring.datasource.url=${SPRING_DATASOURCE_URL}
spring.datasource.username=${SPRING_DATASOURCE_USERNAME}
spring.datasource.password=${SPRING_DATASOURCE_PASSWORD}

spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=false

logging.level.org.springframework=INFO
```

---

# 🚀 4. Activación de perfiles

## Desarrollo

```
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

## Docker (producción)

En docker-compose:

```
SPRING_PROFILES_ACTIVE=prod
```

---

# 🐳 5. docker-compose (producción)

```
services:

  postgres:
    image: postgres:15
    env_file:
      - .env
    ports:
      - "${POSTGRES_PORT}:5432"

  backend:
    build: ../backend
    depends_on:
      - postgres
    ports:
      - "${BACKEND_PORT}:8080"
    env_file:
      - .env
    environment:
      SPRING_PROFILES_ACTIVE: prod
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/${POSTGRES_DB}
      SPRING_DATASOURCE_USERNAME: ${POSTGRES_USER}
      SPRING_DATASOURCE_PASSWORD: ${POSTGRES_PASSWORD}

  frontend:
    build: ../frontend
    depends_on:
      - backend
    ports:
      - "${FRONTEND_PORT}:80"
```

---

# 🔐 6. Variables (.env)

Archivo: `infra/.env`

```
# DATABASE
POSTGRES_DB=app_db
POSTGRES_USER=admin
POSTGRES_PASSWORD=admin123
POSTGRES_PORT=5432

# BACKEND
BACKEND_PORT=8080

# FRONTEND
FRONTEND_PORT=4200
```

---

# 🧠 7. Reglas clave (nivel profesional)

## ❌ Nunca hacer

- Hardcodear credenciales
- Usar localhost en Docker
- Mezclar config entre entornos

---

## ✅ Siempre hacer

- Usar variables (${...})
- Separar dev y prod
- Usar .env

---

# 🔄 8. Flujo de trabajo

## 🟢 Desarrollo

```
docker-compose up -d
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
npm start
```

---

## 🔵 Producción

```
docker-compose up --build
```

---

# ⚡ 9. Beneficios

- Configuración desacoplada
- Escalable
- Portable
- Lista para cloud

---

# 🚀 10. Nivel alcanzado

Con esta configuración ya tienes:

- Arquitectura profesional
- Separación de entornos
- Docker completo
- Base para CI/CD

---

# 🔥 Próximos pasos recomendados

- Secrets (credenciales seguras)
- CI/CD
- Deploy en nube

---

💡 Este template ya es base real para proyectos comerciales.

