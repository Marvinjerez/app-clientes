# 📱 App de Gestión de Clientes

Aplicación móvil desarrollada en Flutter que consume una API REST construida en Golang para la gestión de clientes.
Incluye autenticación mediante JWT y operaciones CRUD completas.

---

## 🧠 Descripción

Este sistema implementa una arquitectura cliente-servidor donde una aplicación móvil se comunica con un backend mediante HTTP.

Permite:

* Autenticación de usuarios
* Gestión completa de clientes (CRUD)
* Consumo de API REST
* Manejo de sesiones mediante JWT

---

## 🏗️ Arquitectura del sistema

```
Flutter (Frontend)
        ↓
API REST (Golang - Gin)
        ↓
Base de Datos (MySQL)
```

---

## 🚀 Tecnologías

### Backend

* Go
* Gin
* GORM
* JWT Auth
* MySQL

### Frontend

* Flutter
* Dart
* HTTP package
* Material Design 3

---

## 📂 Estructura del proyecto

### Backend

```
backend/
├── config
├── controllers
├── migrate
├── models
├── routes
└── main.go
```

### Frontend

```
frontend/
├── pages
├── services
├── models
└── main.dart
```

---

## 🔐 Autenticación (JWT)

El sistema utiliza tokens JWT para proteger los endpoints.

Flujo:

1. Usuario inicia sesión en `/login`
2. El servidor genera un token
3. El cliente envía el token en cada petición:

```
Authorization: Bearer <token>
```

4. Middleware valida el token en cada request

---

## ⚙️ Instalación

### 1. Clonar repositorio

```bash
git clone https://github.com/Marvinjerez/app-clientes.git
cd app-clientes
```

---

### 2. Backend

```bash
cd backend
go mod tidy
go run main.go
```

Servidor:

```
http://localhost:8080
```

---

### 3. Frontend

```bash
cd frontend
flutter pub get
flutter run
```

---

## 🔌 API Endpoints

### Base URL

```
http://localhost:8080/api/v1
```

---

## 👤 Autenticación

| Método | Endpoint | Descripción    |
| ------ | -------- | -------------- |
| POST   | /login   | Iniciar sesión |

---

## 👥 Clientes

| Método | Endpoint       | Descripción    |
| ------ | -------------- | -------------- |
| GET    | /clientes      | Obtener todos  |
| GET    | /clientes/{id} | Obtener por ID |
| POST   | /clientes      | Crear          |
| PUT    | /clientes/{id} | Actualizar     |
| DELETE | /clientes/{id} | Eliminar       |

---

## 👤 Usuarios

| Método | Endpoint  | Descripción     |
| ------ | --------- | --------------- |
| GET    | /usuarios | Listar usuarios |
| POST   | /usuarios | Crear usuario   |

⚠️ Se recomienda crear usuarios desde herramientas como Postman.

---

## 📥 Ejemplo de request

```json
{
  "Dpi": "4580751200369",
  "Nombre": "Marvin Jenaro",
  "Email": "correo@email.com",
  "Telefono": "58784512"
}
```

---

## 📤 Respuesta ejemplo

```json
{
  "ID": 1,
  "Nombre": "Marvin Jenaro",
  "Email": "correo@email.com",
  "Telefono": "58784512"
}
```

---

## 📱 Funcionalidades

✔ Login de usuarios
✔ CRUD de clientes
✔ Consumo de API REST
✔ Manejo de sesión con JWT
✔ Validación de formularios
✔ Manejo de errores

---

## ⚠️ Consideraciones

* Las contraseñas son procesadas con hash en el backend
* Se recomienda proteger todos los endpoints en producción
* Configurar variables de entorno para credenciales

---

## 🔮 Mejoras futuras

* Paginación de clientes
* Filtros de búsqueda
* Refresh tokens
* Logs y monitoreo
* Dockerización

---

## 👨‍💻 Autor

Marvin Jerez
Ingeniero en Sistemas
