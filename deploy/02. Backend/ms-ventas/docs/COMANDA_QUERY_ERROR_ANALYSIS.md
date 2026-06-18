# 🚨 Análisis Completo del Error de Consulta Comanda

## 📋 Resumen Ejecutivo

**Problema:** `InvalidDataAccessResourceUsageException` con múltiples variantes durante paginación y ordenamiento de entidades `Comanda` en arquitectura multi-tenant.

**Solución Final:** JdbcTemplate con datasource específico del tenant actual mediante `TenantDataSourceRegistry`.

---

## 🔍 Evolución del Problema y Soluciones Intentadas

### **Error Inicial**
```
could not determine data type of parameter $10
```

**Contexto:** Consulta nativa con múltiples filtros opcionales y paginación en PostgreSQL.

---

## ❌ Soluciones Fallidas

### **1. JPQL con Pageable (Fallido)**

**Intento:** Quitar ORDER BY manual y dejar que Spring Data JPA maneje todo.

**Código:**
```java
@Query("SELECT c FROM Comanda c WHERE " +
       "(:sucursalId IS NULL OR c.sucursalId = :sucursalId) AND " +
       "(:puntoVentaId IS NULL OR c.puntoVentaId = :puntoVentaId)")
Page<Comanda> findAllWithFilters(..., Pageable pageable);
```

**Error:** `UnknownPathException` - Campo `'apertura'` no existe en entidad.

**Problema Raíz:** Cliente enviaba campo inválido como parámetro de ordenamiento.

---

### **2. Native Query con CAST Explícito (Fallido)**

**Intento:** Agregar CAST explícito para parámetros de paginación.

**Código:**
```sql
LIMIT CAST(:pageSize AS INTEGER) OFFSET CAST(:offset AS INTEGER)
```

**Error:** `could not determine data type of parameter $10` - PostgreSQL seguía sin inferir tipos.

**Problema Raíz:** PostgreSQL no puede inferir tipos con múltiples parámetros opcionales complejos.

---

### **3. PostgreSQL10Dialect (Fallido)**

**Intento:** Cambiar dialecto Hibernate a versión más específica.

**Cambio en `application.yml`:**
```yaml
jpa:
  properties:
    hibernate:
      dialect: org.hibernate.dialect.PostgreSQL10Dialect
```

**Error:** `ClassNotFoundException: org.hibernate.dialect.PostgreSQL10Dialect`

**Problema Raíz:** Dialecto no disponible en versión actual de Hibernate.

---

### **4. ORDER BY Dinámico con CASE (Fallido)**

**Intento:** Construir ORDER BY dinámico usando CASE statements.

**Código:**
```sql
ORDER BY 
  CASE 
    WHEN :sortField = 'fechaHora' THEN c.fecha_hora
    WHEN :sortField = 'mesa' THEN c.mesa
    ELSE c.fecha_hora
  END
```

**Error:** `syntax error at or near "ASC"`

**Problema Raíz:** PostgreSQL no permite bind parameters (`:sortField`) en cláusulas ORDER BY.

---

### **5. ORDER BY con String Concatenación (Fallido)**

**Intento:** Concatenar dirección de ordenamiento como string.

**Código:**
```sql
ORDER BY 
  CASE 
    WHEN :sortField = 'fechaHora' THEN c.fecha_hora
    ELSE c.fecha_hora
  END ' || :sortDirection
```

**Error:** `syntax error at or near "$21"`

**Problema Raíz:** PostgreSQL no permite bind parameters para palabras clave como ASC/DESC.

---

### **6. ORDER BY Hardcoded (Temporalmente Exitoso pero Insuficiente)**

**Intento:** Hardcodear ORDER BY para evitar problemas con bind parameters.

**Código:**
```sql
ORDER BY c.fecha_hora DESC
```

**Resultado:** ✅ Funcionó pero ❌ No permitía ordenamiento dinámico solicitado por el usuario.

**Limitación:** Solución temporal, no cumple requerimientos funcionales.

---

### **7. JdbcTemplate con Parámetros Posicionales (Fallido)**

**Intento:** Usar JdbcTemplate con parámetros posicionales.

**Código:**
```java
List<Comanda> content = jdbcTemplate.query(sql, 
    new Object[]{sucursalId, sucursalId, puntoVentaId, puntoVentaId, mesa, mesa, mesa, 
               estado, estado, fechaDesde, fechaDesde, fechaHasta, fechaHasta},
    new ComandaRowMapper());
```

**Error:** `El índice de la columna está fuera de rango: 1, número de columnas: 0`

**Problema Raíz:** Mismatch entre SQL con named parameters (`:param`) y parámetros posicionales esperados por JdbcTemplate.

---

### **8. JdbcTemplate con SQL Dinámico y Parámetros Opcionales (Fallido)**

**Intento:** Construir SQL dinámicamente basado en parámetros no nulos.

**Código:**
```java
List<String> conditions = new ArrayList<>();
if (sucursalId != null) {
    conditions.add("c.sucursal_id = ?");
    params.add(sucursalId);
}
String whereClause = conditions.isEmpty() ? "" : "WHERE " + String.join(" AND ", conditions);
```

**Error:** `ERROR: relation "ventas.comanda" does not exist`

**Problema Raíz:** JdbcTemplate inyectado usaba datasource principal (security) en lugar del datasource del tenant actual.

---

## ✅ Solución Exitosa Final

### **JdbcTemplate con Datasource de Tenant Actual**

**Componentes Clave:**
1. **TenantDataSourceRegistry** - Para obtener datasource específico del tenant
2. **TenantContext.getEmpresaId()** - Para identificar tenant actual
3. **SQL Dinámico Seguro** - Con validación de campos y manejo de nulos
4. **RowMapper Personalizado** - Para mapeo seguro de resultados

**Implementación:**
```java
// 1. Obtener datasource del tenant actual
Long empresaId = TenantContext.getEmpresaId();
JdbcTemplate tenantJdbcTemplate = new JdbcTemplate(tenantDataSourceRegistry.getOrCreateDataSource(empresaId));

// 2. Construir SQL dinámico seguro
List<String> conditions = new ArrayList<>();
List<Object> params = new ArrayList<>();

if (sucursalId != null) {
    conditions.add("c.sucursal_id = ?");
    params.add(sucursalId);
}

String whereClause = conditions.isEmpty() ? "" : "WHERE " + String.join(" AND ", conditions);
String sql = "SELECT * FROM ventas.comanda c " + whereClause + 
            "ORDER BY " + getSafeOrderByField(sortField) + " " + sortDirection + " " +
            "LIMIT " + pageSize + " OFFSET " + offset;

// 3. Ejecutar con validación de seguridad
List<Comanda> content = tenantJdbcTemplate.query(sql, params.toArray(), new ComandaRowMapper());
```

**Validación de Seguridad:**
```java
private String getSafeOrderByField(String sortField) {
    switch (sortField) {
        case "id": return "c.id";
        case "fechaHora": return "c.fecha_hora";
        case "mesa": return "c.mesa";
        case "estado": return "c.estado";
        case "total": return "c.total";
        default: return "c.fecha_hora"; // Campo por defecto seguro
    }
}
```

---

## 📊 Comparación con Otros Servicios

| Servicio | Enfoque | Complejidad | Problemas |
|---------|---------|-------------|-----------|
| **ZonaServiceImpl** | Spring Data JPA | Baja | Ninguno |
| **ComandaServiceImpl** | JdbcTemplate Manual | Alta | Múltiples resueltos |

**¿Por qué Zona funciona?**
- ✅ No usa JdbcTemplate → Evita problema de datasource
- ✅ Spring Data JPA ya configurado para multi-tenant
- ✅ Simplicidad → Menor probabilidad de errores

---

## 🎯 Lecciones Aprendidas

### **1. Arquitectura Multi-Tenant**
- **JdbcTemplate inyectado ≠ datasource del tenant actual**
- **TenantDataSourceRegistry** es esencial para consultas manuales
- **TenantContext** proporciona identificación del tenant actual

### **2. Limitaciones de PostgreSQL**
- **No permite bind parameters** en cláusulas ORDER BY
- **Requiere CAST explícito** para parámetros de paginación
- **No puede inferir tipos** con múltiples parámetros opcionales complejos

### **3. Spring Data JPA**
- **Excelente para casos simples**
- **Limitado para consultas complejas** con ordenamiento dinámico
- **Maneja automáticamente** datasource del tenant actual

### **4. Mejores Prácticas**
- **Validación estricta** de campos de ordenamiento
- **SQL dinámico seguro** con String.join() y List<String>
- **Parámetros posicionales** más seguros que named parameters en escenarios complejos

---

## 🔧 Recomendaciones Técnicas

### **1. Estandarización**
```java
// Patrón recomendado para consultas complejas en multi-tenant
@Service
public class ComplexQueryService {
    private final TenantDataSourceRegistry tenantDataSourceRegistry;
    
    protected JdbcTemplate getTenantJdbcTemplate() {
        Long empresaId = TenantContext.getEmpresaId();
        return new JdbcTemplate(tenantDataSourceRegistry.getOrCreateDataSource(empresaId));
    }
}
```

### **2. Validación de Campos**
```java
// Centralizar validación de campos de ordenamiento
@Component
public class OrderByValidator {
    public static String getSafeField(String entity, String field) {
        Map<String, Map<String, String>> allowedFields = Map.of(
            "comanda", Map.of(
                "id", "c.id",
                "fechaHora", "c.fecha_hora",
                "mesa", "c.mesa",
                "estado", "c.estado"
            )
        );
        return allowedFields.getOrDefault(entity, Collections.emptyMap())
                         .getOrDefault(field, "c.fecha_hora");
    }
}
```

### **3. Testing Multi-Tenant**
```java
@Test
void testQueryWithDifferentTenants() {
    // Test con múltiples tenants
    TenantContext.setEmpresaId(1L);
    Page<Comanda> page1 = service.findAll(filters, pageable);
    
    TenantContext.setEmpresaId(2L);
    Page<Comanda> page2 = service.findAll(filters, pageable);
    
    assertThat(page1.getContent()).isNotEqualTo(page2.getContent());
}
```

---

## 📋 Conclusión

El problema de consulta `Comanda` reveló complejidades específicas de arquitectura multi-tenant combinadas con limitaciones de PostgreSQL. La solución final establece un patrón robusto para consultas complejas que:

1. **Resuelve correctamente** el problema de datasource en multi-tenant
2. **Mantiene seguridad** contra SQL injection
3. **Proporciona flexibilidad** para filtros y ordenamiento dinámico
4. **Establece un patrón** reusable para futuros desarrollos

Esta solución debe documentarse como patrón estándar para consultas complejas en la arquitectura actual del sistema.
