# Documentación de la API — Academia de Baile

## Base URL

- **Local**: `http://localhost:3000/api/v1`
- **Staging**: `https://api.staging.academyapp.example.com/api/v1`
- **Producción**: `https://api.academyapp.example.com/api/v1`

## Autenticación

La API utiliza **JWT (JSON Web Tokens)**. Para endpoints protegidos, incluye el token en el header:

```
Authorization: Bearer <token>
```

---

## Endpoints

### Autenticación

#### `POST /auth/register`
Registra un nuevo usuario (alumno).

**Body:**
```json
{
  "name": "María García",
  "email": "maria@example.com",
  "password": "contraseña_segura"
}
```

**Respuesta exitosa (201):**
```json
{
  "id": "uuid",
  "name": "María García",
  "email": "maria@example.com",
  "token": "<jwt_token>"
}
```

---

#### `POST /auth/login`
Inicia sesión y obtiene un token JWT.

**Body:**
```json
{
  "email": "maria@example.com",
  "password": "contraseña_segura"
}
```

**Respuesta exitosa (200):**
```json
{
  "token": "<jwt_token>",
  "expiresIn": 3600
}
```

---

### Clases

#### `GET /classes`
Obtiene la lista de clases disponibles.

**Query Params (opcionales):**
- `style`: Estilo de baile (`salsa`, `tango`, `bachata`, etc.)
- `instructor`: ID del instructor
- `available`: `true` para mostrar solo clases con lugares disponibles

**Respuesta exitosa (200):**
```json
[
  {
    "id": "uuid",
    "title": "Salsa Nivel Básico",
    "style": "salsa",
    "instructor": {
      "id": "uuid",
      "name": "Carlos López"
    },
    "schedule": "Lunes y Miércoles 18:00",
    "capacity": 15,
    "enrolled": 10
  }
]
```

---

#### `POST /classes/:id/enroll`
Inscribe al usuario autenticado en una clase. **Requiere autenticación.**

**Respuesta exitosa (200):**
```json
{
  "message": "Inscripción exitosa",
  "classId": "uuid",
  "userId": "uuid"
}
```

---

### Alumnos

#### `GET /students/me`
Obtiene el perfil del alumno autenticado. **Requiere autenticación.**

**Respuesta exitosa (200):**
```json
{
  "id": "uuid",
  "name": "María García",
  "email": "maria@example.com",
  "enrolledClasses": [],
  "membership": {
    "type": "monthly",
    "validUntil": "2026-04-30"
  }
}
```

---

### Instructores

#### `GET /instructors`
Lista todos los instructores activos.

**Respuesta exitosa (200):**
```json
[
  {
    "id": "uuid",
    "name": "Carlos López",
    "specialties": ["salsa", "merengue"],
    "bio": "Instructor con 10 años de experiencia..."
  }
]
```

---

## Códigos de Error

| Código | Descripción                                      |
|--------|--------------------------------------------------|
| 400    | Bad Request — datos de entrada inválidos         |
| 401    | Unauthorized — token ausente o inválido          |
| 403    | Forbidden — sin permisos para el recurso         |
| 404    | Not Found — recurso no encontrado                |
| 409    | Conflict — el recurso ya existe                  |
| 500    | Internal Server Error — error del servidor       |

**Formato de error:**
```json
{
  "error": "Descripción del error",
  "code": "ERROR_CODE"
}
```
