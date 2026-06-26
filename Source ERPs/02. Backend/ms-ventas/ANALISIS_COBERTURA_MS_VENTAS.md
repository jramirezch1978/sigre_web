# Análisis de cobertura — `ms-ventas`

> **Objetivo:** Diagnosticar el estado actual de cobertura de tests (`~65%`) contra el estándar definido en `TEST_STANDARDS.md` (aplicado en ms-finanzas) y proponer acciones concretas para alcanzar **≥80%** en instrucciones y branches.
>
> **Referencias:**
> - [`05. Documentacion/markdown/Pruebas/TEST_STANDARDS.md`](../../05.%20Documentacion/markdown/Pruebas/TEST_STANDARDS.md) — estándar canónico
> - `02. Backend/ms-finanzas/` — primer MS en adoptar el estándar, resultado >80%
> - `02. Backend/ms-ventas/docs/test-data-y-pruebas.md` — documentación A/B/C existente

---

## 1. Radiografía actual

### Cobertura por capa (instrucciones)

| Componente | Cobertura | Diagnóstico |
|---|---|---|
| `controller/` (24) | Mixta 0–100% | 11 controllers >95%, 13 controllers ≤42% (0% el peor) |
| `service.impl/` (22) | **Crítico** | 11 servicios >50%, **11 servicios ≤5%** |
| `service/` (CuentaCobrar) | 46% | Service monolítico, muchas ramas sin cubrir |
| `mapper/` | 0–58% | MapStruct generated al 0%; manuales incompletos |
| `specification/` | 0–29% | Tests que solo verifican `isNotNull()` |
| `VentasFkValidator` | 29% | Validaciones parciales |
| `config/` | 6–100% | FeignConfig 6%, Security 100% |

### Servicios con urgencia crítica (≤5%)

| Servicio | Cobertura | Estado actual |
|---|---|---|
| `EntidadCreditosCxcServiceImpl` | **0%** | Test file existe pero no cubre branches |
| `CanalDistribucionServiceImpl` | **1%** | 153 líneas de test, solo flujo feliz |
| `ComandaServiceImpl` | **4%** | Test incompleto |
| `MesaServiceImpl` | **1%** | Idem |
| `PedidoMesaServiceImpl` | **3%** | Idem |
| `ServiciosCxCServiceImpl` | **1%** | Idem |
| `VendedorServiceImpl` | **1%** | Idem |
| `ZonaServiceImpl` | **1%** | Idem |
| `ZonaDespachoServiceImpl` | **1%** | Idem |
| `ZonaRepartoServiceImpl` | **1%** | Idem |
| `ZonaVentaServiceImpl` | **1%** | Idem |
| `PuntoVentaServiceImpl` | **31%** | Incompleto |

---

## 2. Infracciones al estándar TEST_STANDARDS.md

### 2.1 Controller tests como unitarios (Mockito) en vez de integración

El estándar §1.1 es claro: **Controller → ❌ unitario, ✅ integración**. Hoy hay **23 controller tests** con `@ExtendWith(MockitoExtension.class)` que:

```java
// ❌ Patrón actual — no verifica HTTP status, serialización, ni errores reales
@ExtendWith(MockitoExtension.class)
class ZonaControllerTest {
    @Test
    void findAll() {
        when(service.findAllWithFilters(...)).thenReturn(...);
        assertThat(controller.findAll(...).isSuccess()).isTrue(); // ❌
    }
}
```

vs lo que pide el estándar:

```java
// ✅ Integration test con MockMvc
@Tag("integration")
@SpringBootTest
@AutoConfigureMockMvc
class ZonaControllerIntegrationTest {
    @Test
    void findAll_sinFiltros_retornaLista() throws Exception {
        mockMvc.perform(get("/api/ventas/zonas")
                .header("Authorization", "Bearer mock-token"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }
}
```

### 2.2 JUnit `assertThrows` en vez de AssertJ `assertThatThrownBy`

Regla §4.1-#4: AssertJ exclusivamente.

```java
// ❌ Prohibido
assertThrows(ResourceNotFoundException.class, () -> service.findById(99L));

// ✅ Correcto
assertThatThrownBy(() -> service.findById(99L))
    .isInstanceOf(ResourceNotFoundException.class)
    .hasMessageContaining("99");
```

Archivos afectados: `CanalDistribucionServiceImplTest`, `ComandaServiceImplTest`, `MesaServiceImplTest`, `PedidoMesaServiceImplTest`, `PuntoVentaServiceImplTest`, `ServiciosCxCServiceImplTest`, `VendedorServiceImplTest`, `Zona*ServiceImplTest`, y otros.

### 2.3 Nombres de tests no siguen convención

Regla §4.1-#6: `metodo_escenario_resultadoEsperado`.

```java
void findById_ok()                  // ❌
void findAll()                      // ❌
void create_update_delete()         // ❌ (peor: prueba múltiples acciones)
```

Debe ser:

```java
void findById_cuandoExiste_retornaDto()
void findById_cuandoNoExiste_lanzaResourceNotFoundException()
void findAll_sinFiltros_retornaPagina()
void create_conDatosValidos_retornaCreado()
void create_cuandoCodigoDuplicado_lanzaBusinessException()
```

### 2.4 Tests que mezclan múltiples operaciones

`ZonaControllerTest.create_update_delete_activate_deactivate()` prueba **5 endpoints en 1 método**. Si falla, no se sabe cuál es la causa.

**Debe ser 5 tests separados** (uno por operación).

### 2.5 Falta `@DisplayName` descriptivo

Regla §4.1-#7. Solo los integration tests existentes tienen `@DisplayName`. Los unitarios no.

### 2.6 Specification tests superficiales

Los 6 `*SpecificationsBranchTest` existentes solo hacen:

```java
assertThat(spec).isNotNull(); // ❌ no verifica el predicate real
```

Deben probar que el predicate filtra correctamente invocando `toPredicate()` con Root/CriteriaQuery/CriteriaBuilder.

### 2.7 Integration tests incompletos

Solo **8 de 24 controllers** tienen integration tests. Faltan:

- CanalDistribucion
- Comanda
- CuentaCobrar
- DescuentoPromocion
- EntidadCreditosCxc
- FacturaSimplificada
- Mesa
- PedidoMesa
- Proforma
- Reservacion
- ServiciosCxC
- Vendedor
- Zona
- ZonaDespacho
- ZonaReparto
- ZonaVenta

---

## 3. Lo que ms-ventas YA tiene bien (no tocar)

| Infraestructura | Estado |
|---|---|
| `VentasTestFixtures` (C) | ✅ Creada, bien estructurada, documentada |
| `VentasTestDataFactory` (B) en `src/main/.../testdata/` | ✅ Ubicación correcta |
| `VentasTestDataExecutionListener` | ✅ Singleton thread-safe |
| `VentasTestSecurityConfig` | ✅ Perfil `test` |
| `application-test.yml` | ✅ Con URLs directas Feign |
| `VentasTestDataFactorySmokeIT` | ✅ Smoke test de idempotencia B |
| `@Tag("integration")` en ITs | ✅ Presente |
| `docs/test-data-y-pruebas.md` | ✅ Documentado A/B/C |

---

## 4. Plan de acción priorizado

| Prioridad | Acción | Esfuerzo estimado | Impacto en cobertura |
|-----------|--------|-------------------|---------------------|
| **P1** | Tests exhaustivos para **11 services con ≤5%**: cubrir CRUD, validaciones, branches y excepciones siguiendo la plantilla del estándar §2.2 | 2–3 días | **~40 pts** |
| **P2** | Specification tests reales — ejercitar predicates JPA Criteria | 0.5 día | **~5 pts** |
| **P3** | ITs faltantes: **16 controllers sin integración** → MockMvc + A + B + `@MockBean` Feign | 2–3 días | **~10 pts** |
| **P4** | Migrar 23 controller unitarios → ITs (o eliminar si el IT los reemplaza) | 1 día | **~5 pts** |
| **P5** | Mapper tests: cubrir MapStruct generated (hoy al 0%) y mappers manuales incompletos | 0.5 día | **~5 pts** |
| **P6** | Refactor naming: `assertThrows` → `assertThatThrownBy`, nombres a `metodo_escenario_resultadoEsperado`, agregar `@DisplayName` | 0.5 día | No sube cobertura |

### Prioridad 1 en detalle — servicios a cubrir

Cada servicio necesita tests para:

| Escenario | Ejemplo |
|-----------|---------|
| ✅ Listar con/sin filtros | `findAll_conFiltros_retornaPagina` |
| ✅ Obtener por ID existente | `findById_cuandoExiste_retornaDto` |
| ❌ Obtener por ID inexistente | `findById_cuandoNoExiste_lanzaNotFoundException` |
| ✅ Crear con datos válidos | `create_conDatosValidos_retornaCreado` |
| ❌ Crear con código duplicado | `create_cuandoDuplicado_lanzaBusinessException` |
| ✅ Actualizar existente | `update_cuandoExiste_retornaActualizado` |
| ❌ Actualizar inexistente | `update_cuandoNoExiste_lanzaNotFoundException` |
| ✅ Activar / Desactivar | `activate_cuandoExiste_cambiaFlagEstado` |
| ❌ Activar / Desactivar inexistente | `deactivate_cuandoNoExiste_lanzaNotFoundException` |
| ✅ Eliminar existente | `delete_cuandoExiste_ejecutaDelete` |
| ❌ Eliminar inexistente | `delete_cuandoNoExiste_lanzaNotFoundException` |

### Prioridad 1 — lista completa de servicios

| # | Servicio | Test file existe? | Archivo actual (si existe) |
|---|----------|-------------------|---------------------------|
| 1 | `EntidadCreditosCxcServiceImpl` | Sí | `service/impl/EntidadCreditosCxcServiceImplTest.java` |
| 2 | `CanalDistribucionServiceImpl` | Sí | `service/impl/CanalDistribucionServiceImplTest.java` |
| 3 | `ComandaServiceImpl` | Sí | `service/impl/ComandaServiceImplTest.java` |
| 4 | `MesaServiceImpl` | Sí | `service/impl/MesaServiceImplTest.java` |
| 5 | `PedidoMesaServiceImpl` | Sí | `service/impl/PedidoMesaServiceImplTest.java` |
| 6 | `ServiciosCxCServiceImpl` | Sí | `service/impl/ServiciosCxCServiceImplTest.java` |
| 7 | `VendedorServiceImpl` | Sí | `service/impl/VendedorServiceImplTest.java` |
| 8 | `ZonaServiceImpl` | Sí | `service/impl/ZonaServiceImplTest.java` |
| 9 | `ZonaDespachoServiceImpl` | Sí | `service/impl/ZonaDespachoServiceImplTest.java` |
| 10 | `ZonaRepartoServiceImpl` | Sí | `service/impl/ZonaRepartoServiceImplTest.java` |
| 11 | `ZonaVentaServiceImpl` | Sí | `service/impl/ZonaVentaServiceImplTest.java` |
| 12 | `PuntoVentaServiceImpl` | Sí | `service/impl/PuntoVentaServiceImplTest.java` |

Todos los archivos existen pero son **insuficientes** para alcanzar cobertura ≥80% en cada service.

---

## 5. Plantilla a seguir (extraída de TEST_STANDARDS.md §2.2)

```java
@ExtendWith(MockitoExtension.class)
@DisplayName("XxxServiceImpl — Pruebas Unitarias")
class XxxServiceImplTest {

    @Mock private XxxRepository repository;
    @InjectMocks private XxxServiceImpl service;

    // ==== obtener ====
    @Test
    @DisplayName("obtener() con ID existente -> retorna DTO")
    void obtener_cuandoExisteId_retornaDto() {
        when(repository.findById(1L))
                .thenReturn(Optional.of(VentasTestFixtures.xxxEntity(1L)));
        assertThat(service.obtener(1L)).isNotNull();
        assertThat(service.obtener(1L).getId()).isEqualTo(1L);
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("obtener() con ID inexistente -> lanza ResourceNotFoundException")
    void obtener_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.obtener(999L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("999");
    }

    // ==== crear ====
    @Test
    @DisplayName("crear() con datos válidos -> persiste y retorna")
    void crear_conDatosValidos_retornaCreado() {
        // usar VentasTestFixtures para construir datos (C)
        // mockear repository.save()
        // assertThat(result.getFlagEstado()).isEqualTo("1");
        // verify(repository).save(any());
    }

    @Test
    @DisplayName("crear() con código duplicado -> lanza BusinessException")
    void crear_cuandoCodigoDuplicado_lanzaBusinessException() {
        // mockear repository.existsByCodigoAndFlagEstado(...) -> true
        // assertThatThrownBy(() -> service.create(...))
        //         .isInstanceOf(BusinessException.class);
    }
}
```

---

## 6. Comandos de verificación

```bash
# Unit tests actuales (sin integración)
cd "02. Backend" && mvn test -pl ms-ventas

# Solo integration tests
cd "02. Backend" && mvn test -pl ms-ventas -Dgroups=integration

# Todo con cobertura
cd "02. Backend" && mvn clean verify -pl ms-ventas

# Reporte HTML
open ms-ventas/target/site/jacoco/index.html
```

---

*Documento generado a partir del análisis contra `TEST_STANDARDS.md` (v2.0) y el reporte JaCoCo disponible en `ms-ventas/target/site/jacoco/`. La referencia de ms-finanzas está disponible como ejemplo de migración exitosa al estándar.*
