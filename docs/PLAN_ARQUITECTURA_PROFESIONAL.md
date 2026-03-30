# Plan de Arquitectura Profesional: Docker + Perfiles + Variables

Basado en: `docs/guia_completa_docker_perfiles_variables.md`

---

## Resumen del objetivo

Separar claramente: **código / infraestructura / configuración / entornos (dev + prod)**

---

## ✅ Fase 1 — Perfiles Spring Boot *(completada)*

**Objetivo:** Separar la configuración de desarrollo y producción en archivos dedicados.

- [x] Crear `application-dev.properties` — DB local, `show-sql=true`, logging DEBUG
- [x] Crear `application-prod.properties` — Lee todo desde `${SPRING_DATASOURCE_*}`, `show-sql=false`, logging INFO
- [x] Limpiar `application.properties` — Base neutral sin valores hardcodeados de DB ni logging
- [x] Cambiar perfil por defecto de `local` → `dev` en `application.properties`
- [x] Deprecar `application-local.properties.example` (reemplazado por `application-dev.properties`)

---

## ✅ Fase 2 — Variables de entorno *(completada)*

**Objetivo:** Completar el `.env` y agregar `.env.example` al repositorio.

- [x] Agregar `SPRING_DATASOURCE_URL` al `infra/.env` para coherencia con `docker-compose` *(ya estaba en `docker-compose.yml` directamente — no requiere cambio)*
- [x] Crear `infra/.env.example` con los nombres de variables pero sin valores reales *(ya existía, actualizado puerto frontend)*
- [x] Crear `infra/.gitignore` para excluir `.env` del versionado
- [x] Corregir `.gitignore` del backend: `application-prod.properties` NO debe ignorarse (no tiene secretos); `application-dev.properties` SÍ debe ignorarse

---

## ✅ Fase 3 — Frontend (entornos Angular) *(completada)*

**Objetivo:** Confirmar que los entornos de Angular estén correctamente configurados.

- [x] Verificar `environment.ts` apunta a `http://localhost:8080/api` (dev) — correcto ✅
- [x] Verificar `environment.prod.ts` apunta a `/api` relativo (Nginx proxy en prod) — correcto ✅
- [x] Verificar `angular.json` tiene `fileReplacements` configurado — correcto ✅

---

## ✅ Fase 4 — Flujo de trabajo local (developer experience) *(completada)*

**Objetivo:** Tener comandos claros y documentados para desarrollar sin Docker.

- [x] Crear script `backend/run-dev.sh` — ejecuta `./mvnw spring-boot:run -Dspring-boot.run.profiles=dev`
- [x] Actualizar `docs/setup.md` — instrucciones completas para dev y prod

---

## Historial de cambios

| Fecha | Fase | Cambio |
|---|---|---|
| 29/03/2026 | Fase 1 | Creados `application-dev.properties` y `application-prod.properties`. `application.properties` limpiado como base neutral. Perfil por defecto cambiado de `local` → `dev`. |
| 29/03/2026 | Fase 2 | Creado `infra/.gitignore` (excluye `.env`). Corregido `.gitignore` del backend (prod no tiene secretos, dev sí). Actualizado `infra/.env.example`. |
| 29/03/2026 | Fase 3 | Angular environments verificados — sin cambios necesarios. `environment.ts` → localhost, `environment.prod.ts` → `/api` relativo. |
| 29/03/2026 | Fase 4 | Creado `backend/run-dev.sh`. Reescrito `docs/setup.md` con guía completa dev + prod. |
