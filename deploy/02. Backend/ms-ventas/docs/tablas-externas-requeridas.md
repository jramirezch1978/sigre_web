# Tablas Externas Requeridas para Pruebas de API - ms-ventas

> **Propósito:** Listado de tablas externas que deben contener datos para poder probar todos los endpoints del microservicio `ms-ventas`  
> **Fecha:** 04/05/2026  
> **Microservicio:** ms-ventas  
> **Esquemas involucrados:** auth, core, almacen, finanzas, contabilidad

---

## 📊 Resumen por Esquema

| Esquema | Tablas Requeridas | Prioridad | Mínimo Registros |
|---------|-------------------|-----------|------------------|
| **auth** | 3 tablas | **CRÍTICA** | 2-3 registros cada una |
| **core** | 6 tablas | **CRÍTICA** | 2-5 registros cada una |
| **almacen** | 1 tabla | **ALTA** | 2 registros |
| **finanzas** | 0 tablas | - | - |
| **contabilidad** | 0 tablas | - | - |

**Total:** **10 tablas externas** con datos mínimos requeridos

---

## 🔐 Esquema AUTH (Autenticación y Autorización)

### 1. auth.usuario
**Usada en:** Vendedor (validación FK)  
**Campos mínimos requeridos:**
```sql
INSERT INTO auth.usuario (id, nombre, email, flag_estado, created_by, fec_creacion) VALUES
(1, 'Usuario Admin', 'admin@restaurant.pe', '1', 1, NOW()),
(2, 'Vendedor Juan', 'juan@restaurant.pe', '1', 1, NOW()),
(3, 'Vendedor Maria', 'maria@restaurant.pe', '1', 1, NOW());
```

### 2. auth.sucursal
**Usada en:** PuntoVenta, Mesa, Comanda, PedidoMesa, FacturaSimplificada, CuentaCobrar  
**Campos mínimos requeridos:**
```sql
INSERT INTO auth.sucursal (id, codigo, nombre, direccion, ciudad, flag_estado, created_by, fec_creacion) VALUES
(1, 'SUC001', 'Sucursal Principal', 'Av. Principal 123', 'Lima', '1', 1, NOW()),
(2, 'SUC002', 'Sucursal Secundaria', 'Av. Secundaria 456', 'Lima', '1', 1, NOW());
```

### 3. auth.tokens_session
**Usada en:** TokensSessionVerifier (validación JWT)  
**Campos mínimos requeridos:**
```sql
INSERT INTO auth.tokens_session (id, usuario_id, token_hash, expira_en, flag_estado, created_by, fec_creacion) VALUES
(1, 1, 'hash_admin_token', NOW() + INTERVAL '8 hours', '1', 1, NOW()),
(2, 2, 'hash_vendedor_token', NOW() + INTERVAL '8 hours', '1', 1, NOW());
```

---

## 🏢 Esquema CORE (Datos Maestros del Sistema)

### 1. core.entidad_contribuyente
**Usada en:** Comanda, FacturaSimplificada, CuentaCobrar (clientes)  
**Campos mínimos requeridos:**
```sql
INSERT INTO core.entidad_contribuyente (id, tipo_persona, tipo_documento, nro_documento, razon_social, es_cliente, flag_estado, created_by, fec_creacion) VALUES
(1, 'NATURAL', 'DNI', '12345678', 'Cliente Demo 1', TRUE, '1', 1, NOW()),
(2, 'JURIDICA', 'RUC', '20123456789', 'Empresa Demo SAC', TRUE, '1', 1, NOW()),
(3, 'NATURAL', 'DNI', '87654321', 'Cliente Demo 2', TRUE, '1', 1, NOW());
```

### 2. core.doc_tipo
**Usada en:** FacturaSimplificada, CuentaCobrar (tipos de documento)  
**Campos mínimos requeridos:**
```sql
INSERT INTO core.doc_tipo (id, codigo, nombre, sunat_codigo, flag_estado, created_by, fec_creacion) VALUES
(1, '01', 'FACTURA', '01', '1', 1, NOW()),
(2, '03', 'BOLETA', '03', '1', 1, NOW()),
(3, '99', 'OTROS', '99', '1', 1, NOW());
```

### 3. core.moneda
**Usada en:** FacturaSimplificada, CuentaCobrar  
**Campos mínimos requeridos:**
```sql
INSERT INTO core.moneda (id, codigo, sigla_moneda, nombre, simbolo, decimales, flag_estado, created_by, fec_creacion) VALUES
(1, 'PEN', 'PEN', 'Soles', 'S/', 2, '1', 1, NOW()),
(2, 'USD', 'USD', 'Dólares', '$', 2, '1', 1, NOW());
```

### 4. core.articulo
**Usada en:** Comanda, ComandaDet, PedidoMesaDet, FacturaSimplificadaDet  
**Campos mínimos requeridos:**
```sql
INSERT INTO core.articulo (id, codigo, nombre, descripcion, flag_estado, created_by, fec_creacion) VALUES
(1, 'ART001', 'Arroz con Pollo', 'Plato tradicional', '1', 1, NOW()),
(2, 'ART002', 'Lomo Saltado', 'Plato de carne', '1', 1, NOW()),
(3, 'ART003', 'Inca Kola 500ml', 'Bebida gaseosa', '1', 1, NOW()),
(4, 'ART004', 'Agua 500ml', 'Agua purificada', '1', 1, NOW()),
(5, 'ART005', 'Pollo Broaster', 'Pollo frito', '1', 1, NOW());
```

### 5. core.unidad_medida
**Usada en:** FacturaSimplificadaDet  
**Campos mínimos requeridos:**
```sql
INSERT INTO core.unidad_medida (id, codigo, nombre, flag_estado, created_by, fec_creacion) VALUES
(1, 'UN', 'Unidad', '1', 1, NOW()),
(2, 'KG', 'Kilogramo', '1', 1, NOW()),
(3, 'LT', 'Litro', '1', 1, NOW());
```

### 6. core.forma_pago
**Usada en:** FacturaSimplificadaPagos  
**Campos mínimos requeridos:**
```sql
INSERT INTO core.forma_pago (id, codigo, nombre, tipo, flag_estado, created_by, fec_creacion) VALUES
(1, 'EF', 'Efectivo', 'EFECTIVO', '1', 1, NOW()),
(2, 'TC', 'Tarjeta Crédito', 'TARJETA', '1', 1, NOW()),
(3, 'TD', 'Tarjeta Débito', 'TARJETA', '1', 1, NOW());
```

---

## 📦 Esquema ALMACEN (Gestión de Inventario)

### 1. almacen.almacen
**Usada en:** PuntoVenta (validación FK y relación sucursal)  
**Campos mínimos requeridos:**
```sql
INSERT INTO almacen.almacen (id, nombre, sucursal_id, direccion, flag_estado, created_by, fec_creacion) VALUES
(1, 'Almacén Principal', 1, 'Interno de sucursal', '1', 1, NOW()),
(2, 'Almacén Secundario', 2, 'Interno de sucursal 2', '1', 1, NOW());
```

---

## 🎯 Script Completo de Datos Mínimos

```sql
-- ============================================
-- DATOS MÍNIMOS PARA PRUEBAS DE ms-ventas
-- ============================================

-- 1. ESQUEMA AUTH
INSERT INTO auth.usuario (id, nombre, email, flag_estado, created_by, fec_creacion) VALUES
(1, 'Usuario Admin', 'admin@restaurant.pe', '1', 1, NOW()),
(2, 'Vendedor Juan', 'juan@restaurant.pe', '1', 1, NOW()),
(3, 'Vendedor Maria', 'maria@restaurant.pe', '1', 1, NOW());

INSERT INTO auth.sucursal (id, codigo, nombre, direccion, ciudad, flag_estado, created_by, fec_creacion) VALUES
(1, 'SUC001', 'Sucursal Principal', 'Av. Principal 123', 'Lima', '1', 1, NOW()),
(2, 'SUC002', 'Sucursal Secundaria', 'Av. Secundaria 456', 'Lima', '1', 1, NOW());

-- 2. ESQUEMA CORE
INSERT INTO core.entidad_contribuyente (id, tipo_persona, tipo_documento, nro_documento, razon_social, es_cliente, flag_estado, created_by, fec_creacion) VALUES
(1, 'NATURAL', 'DNI', '12345678', 'Cliente Demo 1', TRUE, '1', 1, NOW()),
(2, 'JURIDICA', 'RUC', '20123456789', 'Empresa Demo SAC', TRUE, '1', 1, NOW()),
(3, 'NATURAL', 'DNI', '87654321', 'Cliente Demo 2', TRUE, '1', 1, NOW());

INSERT INTO core.doc_tipo (id, codigo, nombre, sunat_codigo, flag_estado, created_by, fec_creacion) VALUES
(1, '01', 'FACTURA', '01', '1', 1, NOW()),
(2, '03', 'BOLETA', '03', '1', 1, NOW()),
(3, '99', 'OTROS', '99', '1', 1, NOW());

INSERT INTO core.moneda (id, codigo, sigla_moneda, nombre, simbolo, decimales, flag_estado, created_by, fec_creacion) VALUES
(1, 'PEN', 'PEN', 'Soles', 'S/', 2, '1', 1, NOW()),
(2, 'USD', 'USD', 'Dólares', '$', 2, '1', 1, NOW());

INSERT INTO core.articulo (id, codigo, nombre, descripcion, flag_estado, created_by, fec_creacion) VALUES
(1, 'ART001', 'Arroz con Pollo', 'Plato tradicional', '1', 1, NOW()),
(2, 'ART002', 'Lomo Saltado', 'Plato de carne', '1', 1, NOW()),
(3, 'ART003', 'Inca Kola 500ml', 'Bebida gaseosa', '1', 1, NOW()),
(4, 'ART004', 'Agua 500ml', 'Agua purificada', '1', 1, NOW()),
(5, 'ART005', 'Pollo Broaster', 'Pollo frito', '1', 1, NOW());

INSERT INTO core.unidad_medida (id, codigo, nombre, flag_estado, created_by, fec_creacion) VALUES
(1, 'UN', 'Unidad', '1', 1, NOW()),
(2, 'KG', 'Kilogramo', '1', 1, NOW()),
(3, 'LT', 'Litro', '1', 1, NOW());

INSERT INTO core.forma_pago (id, codigo, nombre, tipo, flag_estado, created_by, fec_creacion) VALUES
(1, 'EF', 'Efectivo', 'EFECTIVO', '1', 1, NOW()),
(2, 'TC', 'Tarjeta Crédito', 'TARJETA', '1', 1, NOW()),
(3, 'TD', 'Tarjeta Débito', 'TARJETA', '1', 1, NOW());

-- 3. ESQUEMA ALMACEN
INSERT INTO almacen.almacen (id, nombre, sucursal_id, direccion, flag_estado, created_by, fec_creacion) VALUES
(1, 'Almacén Principal', 1, 'Interno de sucursal', '1', 1, NOW()),
(2, 'Almacén Secundario', 2, 'Interno de sucursal 2', '1', 1, NOW());
```

---

## 📋 Endpoints que Requieren Datos Externos

### Fase 1 - Maestros (Pueden crearse independientemente)
- ✅ **Zonas** (Venta, Despacho, Reparto): No requieren datos externos
- ✅ **Canales Distribución**: No requieren datos externos
- ✅ **Servicios CxC**: No requieren datos externos

### Fase 2 - Operaciones (Requieren datos externos)
- 🔧 **PuntoVenta**: Requiere `auth.sucursal` + `almacen.almacen`
- 🔧 **Mesa**: Requiere `auth.sucursal` (pero puede crearse sin datos previos)
- 🔧 **Vendedor**: Requiere `auth.usuario`
- 🔧 **Carta/Menú**: Requiere `core.articulo` (pero puede crearse sin items)
- 🔧 **Comanda**: Requiere `auth.sucursal` + `core.entidad_contribuyente` + `core.articulo`
- 🔧 **PedidoMesa**: Requiere `auth.sucursal` + `core.articulo`
- 🔧 **FacturaSimplificada**: Requiere `auth.sucursal` + `core.entidad_contribuyente` + `core.doc_tipo` + `core.moneda` + `core.articulo` + `core.unidad_medida` + `core.forma_pago`

### Fase 3 - Finanzas (Requieren datos externos)
- 🔧 **Cuentas por Cobrar**: Requiere `auth.sucursal` + `core.entidad_contribuyente` + `core.doc_tipo` + `core.moneda`

---

## 🚀 Orden Recomendado de Pruebas

### Paso 1: Datos Externos (Ejecutar primero)
```sql
-- Ejecutar script completo de datos mínimos
-- Esto crea todas las tablas externas necesarias
```

### Paso 2: Maestros (Independientes)
```http
POST /api/ventas/zonas-venta
POST /api/ventas/canales-distribucion  
POST /api/ventas/servicios-cxc
```

### Paso 3: Entidades con FKs Simples
```http
POST /api/ventas/puntos-venta      -- Requiere sucursal + almacén
POST /api/ventas/vendedores         -- Requiere usuario
POST /api/ventas/mesas             -- Requiere sucursal
```

### Paso 4: Operaciones Complejas
```http
POST /api/ventas/cartas            -- Requiere artículos
POST /api/ventas/comandas          -- Requiere sucursal + cliente + artículos
POST /api/ventas/pedidos-mesa      -- Requiere sucursal + artículos
POST /api/ventas/facturas-simplificadas -- Requiere múltiples FKs
```

### Paso 5: Finanzas
```http
POST /api/ventas/cuentas-cobrar    -- Requiere sucursal + cliente + documento
```

---

## ⚠️ Notas Importantes

1. **Secuencia Crítica**: Los datos externos deben existir ANTES de probar los endpoints
2. **IDs Consistentes**: Usar los mismos IDs en todas las tablas para mantener relaciones
3. **Flag Estado**: Todos los registros deben tener `flag_estado = '1'` para ser considerados activos
4. **Auditoría**: Incluir `created_by` y `fec_creacion` en todos los registros
5. **Tokens Session**: Requeridos para autenticación en todos los endpoints protegidos

---

## 🔍 Validación de Datos

Antes de ejecutar pruebas, verificar:
```sql
-- Verificar datos críticos
SELECT COUNT(*) as usuarios FROM auth.usuario WHERE flag_estado = '1';
SELECT COUNT(*) as sucursales FROM auth.sucursal WHERE flag_estado = '1';
SELECT COUNT(*) as articulos FROM core.articulo WHERE flag_estado = '1';
SELECT COUNT(*) as clientes FROM core.entidad_contribuyente WHERE flag_estado = '1';

-- Verificar relaciones
SELECT s.id, s.nombre, a.id as almacen_id FROM auth.sucursal s 
LEFT JOIN almacen.almacen a ON a.sucursal_id = s.id 
WHERE s.flag_estado = '1';
```

Con estos datos mínimos, todos los endpoints del microservicio `ms-ventas` podrán ser probados exitosamente.
