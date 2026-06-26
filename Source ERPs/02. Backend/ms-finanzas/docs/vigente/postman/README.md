# Colección Postman - MS-FINANZAS

## Descripción

Esta colección de Postman contiene todos los endpoints implementados para el microservicio `ms-finanzas`, específicamente para los maestros disponibles:

- **Concepto Financiero** (`/api/finanzas/conceptos-financieros`)
- **Código Flujo Caja** (`/api/finanzas/codigos-flujo-caja`)
- **Cuenta Bancaria** (`/api/finanzas/cuentas-bancarias`)

## Estructura

### Variables de Entorno

La colección utiliza las siguientes variables:

- `baseUrl`: URL base del microservicio (default: `http://localhost:9005`)
- `token`: JWT token de autenticación (debe ser configurado manualmente)
- `id`: ID de ejemplo para pruebas (default: `1`)

### Endpoints de Autenticación

#### Login
- `POST` - Iniciar sesión para obtener token JWT temporal
- URL: `http://aea6a227ef85d4072b2c24693172d1dc-205144200.us-east-1.elb.amazonaws.com/api/auth/login`

#### Seleccionar Empresa
- `POST` - Seleccionar empresa y sucursal para obtener token definitivo
- URL: `http://aef5a596bf4324a0ca5b204c4e4a24d8-735945928.us-east-1.elb.amazonaws.com/api/auth/seleccionar-empresa`

### Endpoints por Maestro

#### Concepto Financiero
- `GET` - Listar conceptos financieros (paginado)
- `GET` - Obtener concepto financiero por ID
- `POST` - Crear concepto financiero
- `PUT` - Actualizar concepto financiero
- `DELETE` - Eliminar concepto financiero
- `PATCH` - Activar concepto financiero
- `PATCH` - Desactivar concepto financiero

#### Código Flujo Caja
- `GET` - Listar códigos de flujo de caja (paginado)
- `GET` - Obtener código de flujo de caja por ID
- `POST` - Crear código de flujo de caja
- `PUT` - Actualizar código de flujo de caja
- `DELETE` - Eliminar código de flujo de caja
- `PATCH` - Activar código de flujo de caja
- `PATCH` - Desactivar código de flujo de caja

#### Cuenta Bancaria
- `GET` - Listar cuentas bancarias (paginado)
- `GET` - Obtener cuenta bancaria por ID
- `POST` - Crear cuenta bancaria
- `PUT` - Actualizar cuenta bancaria
- `DELETE` - Eliminar cuenta bancaria
- `PATCH` - Activar cuenta bancaria
- `PATCH` - Desactivar cuenta bancaria
- `GET` - Consultar saldo actual

## Uso

### 1. Importar la Colección

1. Abre Postman
2. Haz clic en "Import"
3. Selecciona el archivo `ms-finanzas.postman_collection.json`
4. La colección se importará automáticamente

### 2. Configurar Variables

1. En la colección importada, edita las variables:
   - `baseUrl`: Ajusta a la URL donde corre tu microservicio
   - `token`: Ingresa tu JWT token de autenticación
   - `id`: Ajusta según los IDs que necesites probar

### 3. Ejecutar Pruebas

**Flujo Automático de Autenticación:**

1. **Login**: Ejecutar el endpoint "Login" - Guarda automáticamente el token temporal en `{{tempToken}}`
2. **Seleccionar Empresa**: Ejecutar el endpoint "Seleccionar Empresa" - Usa `{{tempToken}}` y guarda el token definitivo en `{{token}}`
3. **Endpoints de Finanzas**: Todos los demás endpoints usan automáticamente `{{token}}`

**Para probar los maestros:**
1. Ejecutar Login (se guarda tempToken)
2. Ejecutar Seleccionar Empresa (se guarda token definitivo)
3. Seleccionar cualquier endpoint de maestros y ejecutar

## Ejemplos de Uso

### Flujo de Autenticación

#### 1. Login (Obtener Token Temporal)

```json
POST http://aea6a227ef85d4072b2c24693172d1dc-205144200.us-east-1.elb.amazonaws.com/api/auth/login
Content-Type: application/json

{
  "email": "jramirez@npssac.com.pe",
  "password": "bxmuoLXS87hcR4IfUhEjS4Btmeo2SQ==",
  "passwordHash": "009389e3858fa09ccdabb98c29170408f65bbe7dc76268e7e4d37c79b97efafc",
  "ipAddress": "127.0.0.1",
  "ipPrivada": "192.168.1.10",
  "browser": "PostmanRuntime/7.44.0",
  "sistemaOperativo": "Windows 11"
}
```

#### 2. Seleccionar Empresa (Obtener Token Definitivo)

```json
POST http://aef5a596bf4324a0ca5b204c4e4a24d8-735945928.us-east-1.elb.amazonaws.com/api/auth/seleccionar-empresa
Content-Type: application/json
Authorization: Bearer {token_temporal_del_login}

{
  "empresaId": 2,
  "sucursalId": 3,
  "ipAddress": "127.0.0.1",
  "ipPrivada": "192.168.1.10",
  "browser": "PostmanRuntime/7.44.0",
  "sistemaOperativo": "Windows 11"
}
```

#### 3. Usar Token en Endpoints de Finanzas

Después de obtener el token definitivo del paso 2, configurar la variable `token` en Postman con ese valor.

### Crear Concepto Financiero

```json
POST {{baseUrl}}/api/finanzas/conceptos-financieros
Content-Type: application/json
Authorization: Bearer {{token}}

{
  "codigo": "ING-001",
  "nombre": "Ingreso por ventas",
  "tipo": "INGRESO"
}
```

### Crear Cuenta Bancaria

```json
POST {{baseUrl}}/api/finanzas/cuentas-bancarias
Content-Type: application/json
Authorization: Bearer {{token}}

{
  "codigo": "CTA-001",
  "cuentaContable": "104101",
  "bancoId": 1,
  "tipoCtaBco": "C",
  "descripcion": "Cuenta corriente BCP",
  "monedaId": 1,
  "saldoContable": 50000.0000,
  "nroCci": "00219100234567890012",
  "nroCuenta": "19100234567890"
}
```

## Respuestas Esperadas

Todos los endpoints siguen el formato `ApiResponse<T>`:

```json
{
  "success": true,
  "message": "Operación exitosa",
  "data": { ... },
  "timestamp": "17/04/2026 13:10:00"
}
```

## Errores Comunes

- **401 Unauthorized**: Token inválido o expirado
- **404 Not Found**: Recurso no encontrado
- **400 Bad Request**: Error de validación en los datos
- **409 Conflict**: Duplicidad de código único

## Notas

- Los IDs de ejemplo (`{{id}}`) deben ser reemplazados con IDs válidos
- Para operaciones de actualización, elimina el campo `id` del body
- Los campos `activo` en las respuestas se derivan de `flagEstado` ("1" = true, "0" = false)
