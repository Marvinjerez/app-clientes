# app-clientes
Aplicación para gestionar clientes.

 ## Descripción

 Aplicación móvil desarrollado mediante Flutter que consume un API REST desarrollado en Go para gestionar clientes.

 El sistema permite realizar operaciones CRUD:

 - Login  
 - Crear clientes
 - Listar clientes
 - Buscar clientes por ID
 - Actualizar clientes
 - Eliminar clientes

## Tecnologías

Backend
- Go
- Gin
- GORM
- JWT Auth
- MySQL

Frontend
- Flutter
- Dart
- HTTP package
- Material Design 3

## Estructura del proyecto

backend/
│
├── config
├── controllers
├── migrate
├── models
├── routes
└── main.go

frontend/
│
├── pages
├── services
├── models
└── main.dart

## Instalación

1. Clonar el repositorio

git clone [https:](https://github.com/Marvinjerez/app-clientes.git)

2. Entrar al backend

cd backend

3. Instalar dependencias

go mod tidy

4. Ejecutar servidor

go run maing.go

## Ejecutar aplicación de Flutter

1. Entrar al proyecto

cd frontend

2. Instalar dependencias

flutter pug get

3. Ejecutar aplicación

flutter run

## API Endpoints

## API Clientes

Base URL

http://localhost:8080/api/v1/clientes

### Obtener todos los clientes

GET /api/v1/clientes

Respuesta

[
 {
  "ID":1,
  "Nombre":"Marvin Jenaro",
  "Email":"correo@email.com",
  "Telefono":"58784512"
 }
]

### Obtener cliente por ID

GET /api/v1/clientes/{id}

### Crear cliente

POST /api/v1/clientes

Body JSON

{
 "Dpi":"4580751200369",
 "Nombre":"Marvin Jenaro",
 "Email":"correo@email.com",
 "Telefono":"58784512"
}

### Actualizar cliente

PUT /api/v1/clientes/{id}

### Eliminar cliente

DELETE /api/v1/clientes/{id}

## API Usuarios

### Obtener todos los usuarios

 GET /api/v1/usuarios

Respuesta

[
  {
    "ID": 1,
    "CreatedAt": "0001-01-01T00:00:00Z",
    "UpdatedAt": "0001-01-01T00:00:00Z",
    "DeletedAt": null,
    "Usuario": "mjenaro",
    "Password": ""
  }
]

### Obtener cliente por ID

GET /api/v1/usuarios/{id}

### Crear cliente

POST /api/v1/usuarios

Body JSON

{
    "Usuario": "admin",
    "Password": "12345678"
}

**Para crear un usuario los mejor hacerlo mediante postman directo al API ya que el mismo hace hash a la contraseña**

### Actualizar cliente

PUT /api/v1/usuarios/{id}

### Eliminar usuario

DELETE /api/v1/usuarios/{id}

## Códigos de respuesta HTTP

200 OK  
Operación exitosa.

201 Created  
Recurso creado correctamente.

400 Bad Request  
Datos enviados incorrectos.

404 Not Found  
El recurso no existe.

500 Internal Server Error  
Error interno del servidor.

## Funcionalidades

✔ Login de usuarios
✔ Crear clientes  
✔ Listar clientes  
✔ Buscar cliente por ID  
✔ Editar cliente  
✔ Eliminar cliente  
✔ Manejo de errores  
✔ Recarga automática

## Manejo de errores

La aplicación maneja errores de:

- Conexión con la API
- Timeout del servidor
- Cliente no encontrado
- Validación de formularios

## Autor

Marvin Jerez
Ingeniero en Sistemas
