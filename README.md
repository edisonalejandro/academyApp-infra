# academyApp-infra

Repositorio para mantener la documentación e infraestructura del proyecto **Academia de Baile**.

## Descripción

Este repositorio centraliza toda la configuración de infraestructura y documentación técnica de la aplicación Academia de Baile, una plataforma para gestionar clases, alumnos e instructores de danza.

## Estructura del Repositorio

```
academyApp-infra/
├── docs/                        # Documentación del proyecto
│   ├── architecture.md          # Arquitectura del sistema
│   ├── deployment.md            # Guía de despliegue
│   └── api.md                   # Documentación de la API
├── infrastructure/
│   ├── docker/                  # Configuración Docker
│   │   ├── docker-compose.yml   # Orquestación de servicios locales
│   │   └── docker-compose.prod.yml  # Orquestación para producción
│   └── terraform/               # Infraestructura como código (IaC)
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── .github/
│   └── workflows/               # Pipelines CI/CD
│       └── ci.yml
├── .gitignore
└── README.md
```

## Documentación

- [Arquitectura del Sistema](docs/architecture.md)
- [Guía de Despliegue](docs/deployment.md)
- [Documentación de la API](docs/api.md)

## Inicio Rápido

### Prerrequisitos

- Docker >= 24.x
- Docker Compose >= 2.x
- Terraform >= 1.6 (para despliegue en la nube)

### Levantar el entorno local

```bash
cd infrastructure/docker
docker compose up -d
```

Esto levantará todos los servicios necesarios (API backend, base de datos PostgreSQL, caché Redis y el servidor de archivos estáticos).

### Verificar el estado de los servicios

```bash
docker compose ps
```

### Detener el entorno

```bash
docker compose down
```

## Infraestructura

La infraestructura está gestionada con **Terraform** y puede desplegarse en AWS. Consulta [docs/deployment.md](docs/deployment.md) para instrucciones detalladas.

## Contribución

1. Crea una rama con el formato `feature/<descripción>` o `fix/<descripción>`.
2. Realiza tus cambios y asegúrate de que los pipelines de CI pasen.
3. Abre un Pull Request describiendo los cambios realizados.

## Contacto

Para dudas o sugerencias, abre un [issue](../../issues) en este repositorio.
