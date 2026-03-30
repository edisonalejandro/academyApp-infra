# Arquitectura del Sistema — Academia de Baile

## Visión General

La aplicación Academia de Baile sigue una arquitectura de **microservicios** compuesta por:

- **Frontend**: Aplicación web (SPA) que permite a los alumnos e instructores interactuar con la plataforma.
- **Backend API**: API REST que expone los recursos del negocio (alumnos, clases, pagos, instructores).
- **Base de Datos**: PostgreSQL como motor de base de datos relacional principal.
- **Caché**: Redis para almacenamiento en caché de sesiones y datos de alta frecuencia de lectura.
- **Almacenamiento de objetos**: Para imágenes de perfil y material multimedia de las clases.

## Diagrama de Componentes

```
┌─────────────────────────────────────────────────────────────────┐
│                          Internet / CDN                         │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                    ┌───────────▼───────────┐
                    │     Load Balancer /    │
                    │      API Gateway       │
                    └────┬──────────────┬───┘
                         │              │
             ┌───────────▼──┐     ┌─────▼──────────┐
             │   Frontend   │     │   Backend API   │
             │  (SPA React) │     │  (Node.js /     │
             └──────────────┘     │   Express)      │
                                  └──┬──────────┬───┘
                                     │          │
                         ┌───────────▼──┐   ┌───▼──────┐
                         │  PostgreSQL  │   │  Redis   │
                         │  (Base de    │   │  (Caché) │
                         │   datos)     │   └──────────┘
                         └──────────────┘
```

## Servicios

| Servicio      | Tecnología        | Puerto local | Descripción                              |
|---------------|-------------------|--------------|------------------------------------------|
| `api`         | Node.js / Express | 3000         | API REST del backend                     |
| `frontend`    | React / Nginx     | 8080         | Interfaz web de usuario                  |
| `db`          | PostgreSQL 15     | 5432         | Base de datos principal                  |
| `cache`       | Redis 7           | 6379         | Caché de sesiones y datos frecuentes     |

## Módulos de Negocio

### Gestión de Alumnos
- Registro e inicio de sesión de alumnos.
- Perfil y historial de clases.
- Seguimiento de progreso.

### Gestión de Clases
- Catálogo de estilos de baile (salsa, tango, bachata, etc.).
- Horarios y disponibilidad.
- Inscripción a clases.

### Gestión de Instructores
- Perfiles de instructores y especialidades.
- Asignación de clases.

### Pagos y Membresías
- Planes de membresía (mensual, trimestral, anual).
- Historial de pagos.
- Integración con pasarelas de pago.

## Entornos

| Entorno     | Descripción                                      |
|-------------|--------------------------------------------------|
| `local`     | Desarrollo local con Docker Compose              |
| `staging`   | Pre-producción en la nube para pruebas           |
| `production`| Entorno productivo con alta disponibilidad       |

## Seguridad

- Autenticación basada en **JWT** (JSON Web Tokens).
- Comunicación cifrada mediante **HTTPS/TLS**.
- Secretos y credenciales gestionados mediante variables de entorno y un gestor de secretos (AWS Secrets Manager o Vault).
- Principio de mínimo privilegio en roles de base de datos e IAM.

## Escalabilidad

- Los servicios de la API son stateless y pueden escalarse horizontalmente.
- PostgreSQL puede configurarse con réplicas de lectura para mayor rendimiento.
- Redis puede configurarse en modo cluster para alta disponibilidad.
