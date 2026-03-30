# Plan de Trabajo — Academia de Baile

## Fase 1 — Seguridad y Estabilidad (Crítico)

- [x] **F1.1 — Flyway + Migraciones**
  - Agregar dependencia `flyway-core` al `pom.xml`
  - Crear scripts V1–V7 con orden correcto de dependencias (roles→users→pricing_rules→courses→payments→students→enrollments→class_sessions)
  - Eliminar scripts V6–V12 anteriores (reemplazados por nueva estructura)
  - Cambiar `ddl-auto=update` → `validate`
  - Agregar config Flyway a `application.properties`
  - Deshabilitar Flyway en `application-test.properties`

- [x] **F1.2 — Logging seguro (perfilado)**
  - Logging SQL/Hibernate bajado a `WARN` en `application.properties` base
  - Comentario documenta cómo activarlo en `application-local.properties` para dev

- [x] **F1.3 — H2 Console solo en tests**
  - Removido `/h2-console/**` de `SecurityConfig` (ya no accesible en producción)
  - H2 console deshabilitado en `application-test.properties`
  - Restaurado `X-Frame-Options` a `SAMEORIGIN` (valor por defecto de Spring Security)

- [x] **F1.4 — Credenciales hardcodeadas**
  - `DataInitializer` lee `ADMIN_EMAIL` y `ADMIN_PASSWORD` desde variables de entorno
  - Fail-fast si perfil es `prod` y las variables no están configuradas
  - Eliminado el print de contraseña en texto plano del log

- [x] **F1.5 — JWT Secret fail-fast**
  - `JwtUtils` con `@PostConstruct` que valida: si perfil `prod` y secret contiene `changeme` → `IllegalStateException`

- [x] **F1.6 — CORS unificado**
  - Eliminado `@CrossOrigin(origins = "*")` de `AuthController`, `PaymentController` y `PricingController`
  - CORS centralizado solo en `SecurityConfig`

---

## Fase 2 — Hardening de Infraestructura

- [x] **F2.1 — Docker health checks**
  - `healthcheck` agregado al servicio `postgres` (`pg_isready`)
  - `healthcheck` agregado al servicio `backend` (`/actuator/health`)
  - `depends_on` del backend cambiado a `condition: service_healthy`
  - `depends_on` del frontend cambiado a `condition: service_healthy` (espera al backend)

- [x] **F2.2 — Variables de entorno del backend en Compose**
  - `SPRING_PROFILES_ACTIVE: prod`, `JWT_SECRET`, `ADMIN_EMAIL`, `ADMIN_PASSWORD` agregados al servicio `backend`
  - `.env` actualizado con las nuevas variables
  - `.env.example` creado con documentación de todas las variables requeridas y cómo generarlas

- [x] **F2.3 — Frontend Dockerfile: path Angular SSR**
  - `backend/Dockerfile` creado (build multi-stage: Maven → eclipse-temurin JRE, usuario non-root)
  - `frontend/Dockerfile` creado (build multi-stage: Node → Nginx, copia desde `dist/academy-app-frontend/browser/`)
  - `frontend/nginx/default.conf` creado (SPA routing, security headers, gzip, cache headers)
  - `infra/nginx/default.conf` creado como referencia de documentación

- [x] **F2.4 — Rate limiting en auth**
  - `bucket4j-core 8.14.0` agregado al `pom.xml`
  - `RateLimitingFilter` creado: 10 req/min en `/api/auth/login`, 5 req/min en `/api/auth/register`
  - Rate limiting por IP con soporte X-Forwarded-For para proxies
  - Filtro registrado en `SecurityConfig` antes del `JwtAuthenticationFilter`

---

## Fase 3 — Completar Funcionalidad

- [x] **F3.1 — environment.prod.ts en Angular**
  - Crear `frontend/src/environments/environment.prod.ts` con URL real de producción
  - Verificar que `angular.json` usa `fileReplacements` para el build de prod

- [x] **F3.2 — Dashboard con datos reales**
  - Conectar `loadAdminStats()` en `DashboardComponent` al endpoint `/api/admin/dashboard`
  - Eliminar los valores hardcodeados

- [x] **F3.3 — Activar rutas frontend**
  - Crear vistas básicas para: `payments`, `pricing`, `classes`
  - Descomentar y conectar las rutas en `app.routes.ts`

- [x] **F3.4 — Paginación en endpoints de lista**
  - Agregar `Pageable` en `CourseService`, `StudentService`, `UserService`
  - Retornar `Page<T>` en lugar de `List<T>`; actualizado frontend con `PageResponse<T>`

- [x] **F3.5 — StudentUserDetailsService**
  - Eliminado el archivo vacío `StudentUserDetailsService.java`

---

## Fase 4 — Calidad de Código y Tests

- [x] **F4.1 — `@Transactional` en AuthService.register()**
  - Envolver creación de usuario + asignación de roles en una transacción

- [x] **F4.2 — Unificar estilo DI**
  - Reemplazado `@Autowired` por constructor injection (`@RequiredArgsConstructor`) en `SecurityConfig`, `AuthController`, `AuthService`, `UserService`

- [x] **F4.3 — Tests de seguridad**
  - Creado `AuthControllerTest` con `@WebMvcTest`: tests de login/register con respuestas correctas y validación de campos
  - Creado `UserControllerSecurityTest` con `@WithMockUser`: verifica 401 sin auth, 403 con rol STUDENT, 200 con roles ADMIN/TEACHER

- [x] **F4.4 — application-local.properties.example**
  - Creado `backend/src/main/resources/application-local.properties.example` con plantilla documentada para onboarding
