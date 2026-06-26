# Diagnóstico — Tests fallando en ms-rrhh

> **267 tests ejecutados, 18 failures, 0 errors.**
> Fecha: 2026-05-28
> Referencia: `TEST_STANDARDS.md` — modelo A/B/C + 4 pilares ms-finanzas.

---

## Resumen

| Grupo | Archivo | Tests fallando | Tipo | Severidad |
|-------|---------|----------------|------|-----------|
| **1** | `TurnoServiceTest` | 4 | Unit | 🔴 Alta |
| **2** | `TurnoControllerIntegrationTest` | 11 | Integration | 🔴 Alta |
| **3** | `AdminAfpControllerIntegrationTest` | 3 | Integration | 🟡 Media |

---

## Grupo 1 — TurnoServiceTest (4 unit tests)

**Archivo:** `src/test/java/pe/restaurant/rrhh/service/TurnoServiceTest.java`

### Problemas detectados

| # | Test | Error | Causa raíz |
|---|------|-------|------------|
| 1 | `crearTurno_nombreDuplicado_lanzaExcepcion` | `expected: <true> but was: <false>` | Usa JUnit `assertTrue` en vez de AssertJ. El `getMessage()` no contiene el código esperado. |
| 2 | `crearTurno_nombreObligatorio_lanzaExcepcion` | `expected: <true> but was: <false>` | Idem. |
| 3 | `eliminarTurno_conAsignados_lanzaExcepcion` | `expected: <true> but was: <false>` | Idem. |
| 4 | `eliminarTurno_sinAsignados_ok` | `TurnoNotFoundException: Turno no encontrado. ID: 1` | No mockea `turnoRepository.findById()`. El service llama `existsById(1)` y devuelve `false`. |

### Checklist de violaciones al estándar

| Regla | Esperado | Actual |
|-------|----------|--------|
| §4.1-1: `@ExtendWith(MockitoExtension.class)` | ✅ | ❌ Usa `MockitoAnnotations.openMocks(this)` |
| §4.1-4: AssertJ | ✅ | ❌ Usa JUnit `assertTrue/assertThrows/assertDoesNotThrow` |
| §4.1-6: naming `metodo_escenario_resultadoEsperado` | ✅ | ❌ Nombres sin `_` |
| §4.1-7: `@DisplayName` descriptivo | ✅ | ❌ Ausente |
| §4.1-9: `verify()` al final | ✅ | ❌ Ausente |

### Solución

Reescribir el archivo completo siguiendo la plantilla §2.2 del estándar:

```java
@ExtendWith(MockitoExtension.class)
@DisplayName("TurnoServiceImpl — Pruebas Unitarias")
class TurnoServiceImplTest {

    @Mock private TurnoRepository turnoRepository;
    @Mock private TurnoMapper turnoMapper;
    @Mock private HorarioTrabajadorRepository horarioTrabajadorRepository;
    @InjectMocks private TurnoServiceImpl turnoService;

    @Test
    @DisplayName("crear() con nombre duplicado -> lanza BusinessException")
    void crear_cuandoNombreDuplicado_lanzaBusinessException() {
        TurnoRequest req = TurnoRequest.builder().nombre("Turno Mañana").aplicaLunes(true).build();
        when(turnoRepository.existsByNombreIgnoreCase("Turno Mañana")).thenReturn(true);

        assertThatThrownBy(() -> turnoService.crearTurno(req, 1L))
                .isInstanceOf(TurnoBusinessException.class)
                .hasMessageContaining("Ya existe un turno con ese nombre");
        verify(turnoRepository).existsByNombreIgnoreCase(any());
    }

    @Test
    @DisplayName("eliminar() con ID existente sin asignados -> elimina")
    void eliminar_cuandoExisteIdYSinAsignados_elimina() {
        when(turnoRepository.existsById(1L)).thenReturn(true);
        when(horarioTrabajadorRepository.existsByTurnoIdAndFlagEstado(1L, "1")).thenReturn(false);

        turnoService.eliminarTurno(1L);

        verify(turnoRepository).deleteById(1L);
    }
}
```

---

## Grupo 2 — TurnoControllerIntegrationTest (11 integration tests)

**Archivo:** `src/test/java/pe/restaurant/rrhh/controller/TurnoControllerIntegrationTest.java`

### Problemas detectados

| Síntoma | Causa | Todos los requests devuelven **400** con `EMPRESA_REQUERIDA` porque **no envían `Authorization` header**. El `TenantContextWebFilter` de `common` exige JWT, `X-Empresa-Id` o path con empresa. | |
|---------|-------|--|--|

### Checklist de violaciones al estándar

| Regla | Esperado | Actual |
|-------|----------|--------|
| §4.2-8: Auth token hardcodeado `"Bearer mock-token"` | ✅ | ❌ No envía ningún header |
| §4.2-9: CRUD mínimo por controller | ✅ | ❌ Tests existentes pero no llegan al controller |
| §2.6: `@AfterEach DELETE` prohibido | ❌ No usa DELETE en AfterEach | ⚠️ Usa `deleteAll()` en `@BeforeEach`, igual de prohibido |
| §4.2-4: `TenantContextTestExecutionListener` | ✅ | ✅ Presente |
| §4.2-5: A + B para datos | ✅ | ❌ No usa `RrhhTestDataExecutionListener` ni `RrhhTestDataFactory` |

### Solución

Agregar `Authorization` header y `X-Empresa-Id` a todos los requests, y eliminar `deleteAll()` manual:

```java
@BeforeEach
void setUp() {
    horarioTrabajadorRepository.deleteAll();
    turnoRepository.deleteAll();  // ❌ ELIMINAR — @Transactional ya revierte
}
```

Cambiar cada request de:

```java
mockMvc.perform(get("/api/rrhh/turnos")
        .param("page", "0")
        .param("size", "10"))
```

a:

```java
mockMvc.perform(get("/api/rrhh/turnos")
        .header("Authorization", "Bearer mock-token")
        .header("X-Empresa-Id", "2")
        .param("page", "0")
        .param("size", "10"))
```

Además, no hacer `objectMapper = new ObjectMapper()` en `setUp()` — usar el bean inyectado de Spring o mantenerlo pero no pisar la inyección.

---

## Grupo 3 — AdminAfpControllerIntegrationTest (3 integration tests)

**Archivo:** `src/test/java/pe/restaurant/rrhh/controller/integration/AdminAfpControllerIntegrationTest.java`

### Problemas detectados

| Test | Esperado | Actual | Causa |
|------|----------|--------|-------|
| `crear_AfpNombreVacio_DebeRetornar400` | `errorCode` = `RH-AF-001` | `VALIDATION_ERROR` | Spring `@Valid` + `@NotBlank` en el DTO rechaza antes de llegar al service. El `@ExceptionHandler` de `MethodArgumentNotValidException` devuelve `VALIDATION_ERROR`. |
| `crear_AfpPorcentajeNegativo_DebeRetornar400` | `errorCode` = `RH-AF-003` | `VALIDATION_ERROR` | Idem, `@DecimalMin` en el DTO. |
| `listar_AfpsConFiltro_DebeRetornarFiltradas` | `nombre` = `"AFP Integra"` | `"INTEGRA"` | `TestDataSeederRrhh.ensureAdminAfp()` ejecuta `DELETE WHERE UPPER(nombre) = 'AFP INTEGRA'` que no matchea `'AFP Integra'` (case-sensitive). El registro `'AFP Integra'` se persiste pero otro registro previo `'INTEGRA'` sobrevive. |

### Checklist de violaciones al estándar

| Regla | Esperado | Actual |
|-------|----------|--------|
| §4.2-8: Auth token hardcodeado | ✅ | ✅ `"Bearer mock-token"` |
| §4.2-9: CRUD mínimo | ✅ | ✅ CREATE, READ, UPDATE, DELETE |
| §4.2-3: `@Transactional` | ✅ | ✅ |
| §4.2-5: A + B | ✅ | ✅ `RrhhTestDataExecutionListener` |
| — Assertions realistas sobre validation errors | ✅ | ❌ Asumen que el errorCode del service llega al response, pero Spring Validation intercepta antes |

### Solución

**Para validación Spring vs Service:** El response de `@Valid` con error de validación tiene estructura diferente. Actualizar assertions:

```java
// Antes (falla):
.andExpect(jsonPath("$.errorCode").value("RH-AF-001"));

// Después:
.andExpect(jsonPath("$.success").value(false));
.andExpect(jsonPath("$.message").exists());
// O, si se quiere validar el error code de Spring:
.andExpect(jsonPath("$.errorCode").value("VALIDATION_ERROR"));
```

**Para el bug del seeder** (`TestDataSeederRrhh.java` línea 61):

```java
// Antes (no matchea por case):
jdbc.update("DELETE FROM rrhh.admin_afp WHERE UPPER(nombre) = 'AFP INTEGRA'");

// Después:
jdbc.update("DELETE FROM rrhh.admin_afp WHERE UPPER(nombre) = UPPER('AFP Integra')");
```

---

## Problemas estructurales adicionales en ms-rrhh

| Ítem | Severidad |
|------|-----------|
| ❌ **No existe** Smoke test de idempotencia para `RrhhTestDataFactory` (requerido §2.5) | 🟡 Media |
| ✅ `docs/test-data-y-pruebas.md` creado (requerido por TEST_STANDARDS §8) | ✅ |
| ❌ `RrhhTestDataFactory` no expone `ensureRrhhTransactionalData()` unificado ni `resolve*Id()` | 🟡 Media |
| ❌ `RrhhTestDataExecutionListener` usa `new TestDataSeeder(dataSource).seedAll()` — prohibido §2.6 sin justificación | 🟡 Media |
| ⚠️ `RrhhTestDataFactory` tiene métodos `clean*TestData()` que hacen DELETE manual fuera de `@Transactional` | 🟢 Baja |
| ⚠️ `TurnoServiceTest` es el único unit test que no sigue el estándar; todos los demás (Area, Cargo, AdminAfp, TurnoServiceImpl) están correctos | 🟢 Baja |

---

## Prioridad de corrección

1. **TurnoControllerIntegrationTest** (11 tests) — Bloqueante. Sin auth header, NINGÚN endpoint funciona.
2. **TurnoServiceTest** (4 tests) — Bajo riesgo, plantilla conocida.
3. **AdminAfpControllerIntegrationTest** (3 tests) — Assertions incorrectas + bug de seeder.
4. **Deuda técnica** — Smoke test de B, docs, `resolve*Id()`, `seedAll()`.

---

## Comandos de verificación

```bash
# Unit tests (sin BD)
mvn test -pl "02. Backend/ms-rrhh" -Dsurefire.excludedGroups=integration

# Integration tests (con BD)
mvn test -pl "02. Backend/ms-rrhh" -Dgroups=integration

# Todos
mvn test -pl "02. Backend/ms-rrhh"
```
