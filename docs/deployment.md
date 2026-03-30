# Guía de Despliegue — Academia de Baile

## Entorno Local (Docker Compose)

### Prerrequisitos

- Docker >= 24.x
- Docker Compose >= 2.x

### Pasos

1. Clona el repositorio:
   ```bash
   git clone https://github.com/edisonalejandro/academyApp-infra.git
   cd academyApp-infra/infrastructure/docker
   ```

2. Crea el archivo de variables de entorno copiando el ejemplo:
   ```bash
   cp .env.example .env
   ```
   Edita `.env` con los valores apropiados para tu entorno local.

3. Levanta los servicios:
   ```bash
   docker compose up -d
   ```

4. Verifica que todos los servicios estén corriendo:
   ```bash
   docker compose ps
   ```

5. Accede a la aplicación en [http://localhost:8080](http://localhost:8080).

6. Para ver los logs de un servicio específico:
   ```bash
   docker compose logs -f api
   ```

### Detener el Entorno

```bash
docker compose down
```

Para eliminar también los volúmenes (base de datos):
```bash
docker compose down -v
```

---

## Despliegue en la Nube (Terraform + AWS)

> **Nota sobre el archivo `docker-compose.prod.yml`:** La sección `deploy` (replicas, resources) es procesada únicamente por **Docker Swarm** (`docker stack deploy`). Si usas `docker compose up` directamente, esa sección se ignora; escala los contenedores con `--scale api=2` en su lugar.

### Prerrequisitos

- Terraform >= 1.6
- AWS CLI configurada con credenciales válidas
- Acceso a la cuenta de AWS del proyecto

### Estructura de Terraform

```
infrastructure/terraform/
├── main.tf          # Recursos principales de AWS
├── variables.tf     # Variables configurables
└── outputs.tf       # Outputs de la infraestructura
```

### Pasos para Desplegar

1. Navega al directorio de Terraform:
   ```bash
   cd infrastructure/terraform
   ```

2. **Prerrequisito (una sola vez):** crea el bucket S3 para almacenar el estado de Terraform:
   ```bash
   aws s3api create-bucket --bucket academyapp-terraform-state --region us-east-1
   aws s3api put-bucket-versioning \
     --bucket academyapp-terraform-state \
     --versioning-configuration Status=Enabled
   ```

3. Inicializa el backend y descarga los proveedores:
   ```bash
   terraform init
   ```

4. Revisa el plan de cambios:
   ```bash
   terraform plan -var-file="staging.tfvars"
   ```

5. Aplica los cambios:
   ```bash
   terraform apply -var-file="staging.tfvars"
   ```

6. Para destruir la infraestructura:
   ```bash
   terraform destroy -var-file="staging.tfvars"
   ```

### Variables de Entorno para Producción

| Variable              | Descripción                                      |
|-----------------------|--------------------------------------------------|
| `AWS_REGION`          | Región de AWS (ej: `us-east-1`)                  |
| `DB_PASSWORD`         | Contraseña del usuario de base de datos          |
| `JWT_SECRET`          | Secreto para firmar tokens JWT                   |
| `REDIS_PASSWORD`      | Contraseña de Redis (en entornos no locales)     |

> **Nota:** Nunca almacenes secretos directamente en el código o en el repositorio. Usa AWS Secrets Manager o variables de entorno cifradas.

---

## Pipelines CI/CD

Los pipelines están configurados en `.github/workflows/ci.yml` y se ejecutan automáticamente al abrir un Pull Request o hacer push a `main`.

### Etapas del Pipeline

1. **Lint**: Verifica el estilo y formato del código.
2. **Test**: Ejecuta las pruebas unitarias e integración.
3. **Build**: Construye las imágenes Docker.
4. **Deploy** (solo en `main`): Despliega automáticamente al entorno de staging.

---

## Rollback

En caso de un despliegue fallido, puedes hacer rollback a la versión anterior con Terraform:

```bash
terraform apply -var-file="staging.tfvars" -target=<recurso_afectado>
```

O revertir al commit anterior y volver a ejecutar el pipeline de CI/CD.
