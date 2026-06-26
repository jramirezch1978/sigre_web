# Test Data y Pruebas — ms-finanzas

> Documentación del modelo A/B/C de datos de prueba, cobertura de tests unitarios
> y de integración para el microservicio de finanzas.
> Mantenela actualizada cada vez que cambien seeds, factories, fixtures o se agreguen tests.
> Versión: 2.2 — ~986 tests, 81.0% branch coverage, 91.9% instruction coverage. QA: ✅ GO.

---

## Tabla de Contenidos

1. [Modelo A / B / C](#modelo-a--b--c)
 2. [Cobertura de Tests](#cobertura-de-tests)
   - [Métricas Actuales](#métricas-actuales)
   - [Composición de los 943 tests](#composición-de-los-943-tests)
   - [Cálculo de cobertura JaCoCo](#cálculo-de-cobertura-jacoco)
   - [Unit Tests — Mappers](#unit-tests--mappers)
   - [Unit Tests — Services](#unit-tests--services)
   - [Integration Tests — Controllers](#integration-tests--controllers)
3. [Unit Tests en Detalle](#unit-tests-en-detalle)
   - [Mappers (MapStruct y manuales)](#mappers-mapstruct-y-manuales)
   - [Services](#services)
   - [Convenciones](#convenciones)
   - [Anti-patrones](#anti-patrones)
4. [B — Datos transaccionales del módulo](#b--datos-transaccionales-del-módulo)
5. [Estructura de Directorios](#estructura-de-directorios)
6. [Comandos Maven](#comandos-maven)
 7. [Tests Faltantes / Pendientes](#tests-faltantes--pendientes)
 8. [Evaluación QA](#evaluación-qa)

---

## Modelo A / B / C

| Rol | Clase | Ubicación | Métodos clave |
|-----|-------|-----------|---------------|
| **A** | `TestDataFactory` / `TestDataSeeder` | `common` test-jar | `seedMoneda()`, `seedSucursal()`, `seedEntidadContribuyente()`, `seedConceptoFinanciero()`, `seedPlanContable()`, `seedDocTipo()`, `seedDocTipoNumSerie()`, `seedTiposDocumento()`, `seedCentrosCosto()`, `seedActualizarFlagsProveedorCliente()` |
| **B** | `FinanzasTestDataFactory` | `src/main/.../testdata/` | `ensureFinanzasTransactionalData()`, `resolveCntasPagarId()`, `resolveCntasPagarId2()`, `resolveBancoId()`, `resolveBancoId2()`, `resolveConceptoFinancieroId()`, `resolveCajaBancosId()`, `resolveProgramacionPagoId()` |
| **C** | `FinanzasTestFixtures` | `src/test/.../` | Ver [Unit Tests en Detalle](#unit-tests-en-detalle) |

### Reglas de uso

- **Unit tests**: solo **C** (fixtures en RAM). Prohibido A o B.
- **Integration tests**: **A** (mínimo compartido) + **B** (dominio del MS). **C** solo para bodies JSON de entrada.
- **Nunca** usar `seedAll()` sin justificación documentada.
- **Nunca** mockear repos propios en `@SpringBootTest`.
- **Nunca** asumir que una fixture C persiste en BD.

---

## Cobertura de Tests

### Métricas Actuales

| Métrica | Valor |
|---------|-------|
| Tests totales | **~986** |
| Branch coverage | **81.0%** (846/1045) |
| Instruction coverage | **91.9%** (16440/17887) |
| Branch coverage (service.impl) | **87.6%** |
| Meta | **80% branches** ✅ Superado |

#### Composición de los ~986 tests

Surefire suma todos los `Tests run:` de los reports individuales en `target/surefire-reports/`.

| Categoría | Tests (aprox.) | Archivos |
|-----------|----------------|----------|
| Unit tests | **~784** (79.5%) | ~61 archivos |
| Integration tests | **~202** (20.5%) | 20 archivos |
| **Total** | **~986** | ~81 |

Los *skipped* corresponden a tests condicionales o desactivados temporalmente — no afectan la métrica de cobertura.

#### Cálculo de cobertura JaCoCo

Se genera con `mvn clean test jacoco:report -pl ms-finanzas`. Lee el archivo de ejecución `jacoco.exec` (generado durante `test`) y lo cruza con el bytecode compilado. Las métricas son:

- **Instruction coverage**: proporción de bytecodes ejecutados (91.6%)
- **Branch coverage**: proporción de ramas condicionales cubiertas (81.2%) — **nuestra métrica objetivo**
- JaCoCo analiza **84 clases** del bundle `ms-finanzas`

### Distribución por paquete

| Paquete | Instructions | Branch | Estado |
|---------|-------------|--------|--------|
| `domain` | 100% | 93.3% | ✅ |
| `enums` | 100% | 100% | ✅ |
| `specification` | 97.2% | 100% | ✅ |
| `mapper` | 94.6% | 82% | ✅ |
| `service.impl` | **95.0%** | **87.6%** | ✅ **Mejorado** |
| `service` (validators) | 92.6% | 82.4% | ✅ |
| `validation` | 90% | 83.3% | ✅ |
| `controller` | 70.5% | — | ⚠️ Artefacto — delegación |
| `config` | 73% | 35.7% | ⚠️ Beans Spring |
| `entity` | 69% | 50% | ⚠️ Lombok bytecode |
| `constants` | 0% | n/a | ⚠️ Artefacto — constantes estáticas |

### Unit Tests — Mappers

| Mapper | Branch cov. | Tests existentes |
|--------|-------------|------------------|
| NotaMapper | 93.8% | `NotaMapperTest` |
| DocumentoDirectoMapper | 91.7% | `DocumentoDirectoMapperTest` |
| ConciliacionBancariaMapperImpl | ~87% | `ConciliacionBancariaMapperTest` |
| DetraccionMapperImpl | 75%+ | `DetraccionMapperTest` |
| RetencionMapperImpl | 75%+ | `RetencionMapperTest` |
| LiquidacionMapper | 75%+ | `LiquidacionMapperTest` |
| ConceptoFinancieroMapperImpl | 100% | `ConceptoFinancieroMapperTest` |
| BancoMapperImpl | 100% | `BancoMapperTest` |
| CuentaBancariaMapperImpl | 100% | `CuentaBancariaMapperTest` |
| CntasPagarMapperImpl | ~83% | `CntasPagarMapperTest` |
| CntasPagarDetMapperImpl | ~70% | `CntasPagarDetMapperTest` |
| NotaDetalleMapper | ~80% | `NotaDetalleMapperTest` |
| DocumentoDirectoDetalleMapper | ~80% | `DocumentoDirectoDetalleMapperTest` |
| ConciliacionDetMapperImpl | Nuevo | `ConciliacionDetMapperTest` |
| LetraCanjeMapper | 62.5% | `LetraCanjeMapperTest` |
| GrupoCodigoFlujoCajaMapperImpl | 60% | `GrupoCodigoFlujoCajaMapperTest` |
| AutorizadorGiroMapperImpl | 71.4% | `AutorizadorGiroMapperTest` |
| **Sin test**: ConciliacionBancariaMapperImpl, LiquidacionMapper, DetraccionMapperImpl, RetencionMapperImpl | — | Creados recientemente |

### Unit Tests — Services

| Service | Instructions | Branch | Tests | Cambio |
|---------|-------------|--------|-------|--------|
| ConceptoFinancieroServiceImpl | **100%** | **100%** | `ConceptoFinancieroServiceTest` | — |
| NotaServiceImpl | **100%** | **100%** | `NotaServiceImplTest` | — |
| CodigoFlujoCajaServiceImpl | **100%** | **100%** | `CodigoFlujoCajaServiceTest` | — |
| ProgramacionPagoService | **100%** | **100%** | `ProgramacionPagoServiceTest` | — |
| DocumentoDirectoServiceImpl | 99.7% | 90% | `DocumentoDirectoServiceImplTest` | — |
| CuentaBancariaServiceImpl | **100%** | **91.7%** | `CuentaBancariaServiceImplTest` | 🟢 **71.7→100% / 66.7→91.7%** |
| AutorizadorGiroServiceImpl | **96.2%** | **100%** | `AutorizadorGiroServiceImplTest` | 🟢 **71.5→96.2% / 43.8→100%** |
| DetraccionServiceImpl | **95.9%** | **80.0%** | `DetraccionServiceImplTest` | 🟢 **83.7→95.9% / 60→80%** |
| LetraCanjeServiceImpl | 97.4% | 87.2% | `LetraCanjeServiceTest` | — |
| SolicitudGiroServiceImpl | 97.5% | 92% | `SolicitudGiroServiceImplTest` | — |
| BancoServiceImpl | 94.7% | 75% | `BancoServiceTest` | — |
| CajaBancosService | 92.2% | 81.9% | `CajaBancosServiceTest` | — |
| ConciliacionBancariaServiceImpl | 91.4% | 88.2% | `ConciliacionBancariaServiceImplTest` | — |
| RetencionServiceImpl | 90.1% | 81.2% | `RetencionServiceImplTest` | — |
| CntasPagarServiceImpl | 89.8% | 88% | `CntasPagarServiceImplTest` | — |
| GrupoCodigoFlujoCajaServiceImpl | 86% | 50% | `GrupoCodigoFlujoCajaServiceImplTest` | — |
| LiquidacionService | 92.1% | 73.8% | `LiquidacionServiceTest` | — |

### Integration Tests — Controllers

Todos los controllers tienen su correspondiente IT con `@Tag("integration")`:

- AutorizadorGiroController, BancoController, CajaBancosController,
  CntasPagarController, CodigoFlujoCajaController, ConceptoFinancieroController,
  ConciliacionBancariaController, CuentaBancariaController, CuentasPagarController,
  DetraccionController, DocumentoDirectoController, GrupoCodigoFlujoCajaController,
  LetraCanjeController, LiquidacionController, NotaController,
  ProgramacionPagoController, RetencionController, SolicitudGiroController

Los ITs corren con PostgreSQL real via `@SpringBootTest`, seeds A+B, y `@MockBean` para Feign clients externos.

---

## Unit Tests en Detalle

### Mappers (MapStruct y manuales)

#### Patrón general

Los mappers MapStruct generan código con null-checks implícitos. Cada método público genera 2 ramas (null / not-null). Los tests cubren AMBAS ramas explícitamente.

**Estructura de test para mapper MapStruct:**

```java
class XxxMapperTest {
    private XxxMapper mapper;

    @BeforeEach
    void setUp() {
        mapper = Mappers.getMapper(XxxMapper.class);
        // Si el mapper usa @Autowired, instanciar con ReflectionTestUtils:
        // XxxMapperImpl impl = new XxxMapperImpl();
        // ReflectionTestUtils.setField(impl, "dependency", dep);
        // mapper = impl;
    }

    @Test void toEntity_conRequestValido_retornaEntity() { ... }
    @Test void toEntity_conRequestNull_retornaNull()     { assertThat(mapper.toEntity(null)).isNull(); }
    @Test void toResponse_conEntityValida_retornaResponse() { ... }
    @Test void toResponse_conEntityNull_retornaNull()    { assertThat(mapper.toResponse(null)).isNull(); }
    @Test void toResponseList_conListaValida_retornaLista() { ... }
    @Test void toResponseList_conListaVacia_retornaListaVacia() { ... }
}
```

**Mappers con `uses` (dependencias):**

Cuando un mapper usa `@Mapper(uses = {OtroMapper.class})`, la impl generada usa `@Autowired` field injection. En tests sin Spring, se usa `ReflectionTestUtils.setField()`:

```java
ConciliacionDetMapper detMapper = Mappers.getMapper(ConciliacionDetMapper.class);
ConciliacionBancariaMapperImpl impl = new ConciliacionBancariaMapperImpl();
ReflectionTestUtils.setField(impl, "conciliacionDetMapper", detMapper);
mapper = impl;
```

**Mappers manuales (@Component):**

Se instancian directamente con `new`:

```java
mapper = new LiquidacionMapper(new LiquidacionDetMapper());
```

#### Cobertura de casos

Cada mapper test cubre:

| Caso | Método de prueba |
|------|------------------|
| Conversión request → entity (todos los campos) | `toEntity_conRequestValido_retornaEntity` |
| Request null → retorna null | `toEntity_conRequestNull_retornaNull` |
| Entity → response (todos los campos) | `toResponse_conEntityValida_retornaResponse` |
| Entity null → retorna null | `toResponse_conEntityNull_retornaNull` |
| Lista de entities → lista de responses | `toResponseList_conListaValida_retornaLista` |
| Lista vacía → lista vacía | `toResponseList_conListaVacia_retornaListaVacia` |
| Request con valores nulos (parcial) | `toEntity_conValoresNulos_manejaCorrectamente` |

### Services

#### Patrón general

Todos los service tests usan `@ExtendWith(MockitoExtension.class)`, `@Mock` para dependencias, `@InjectMocks` para el SUT.

```java
@ExtendWith(MockitoExtension.class)
class MiServiceImplTest {
    @Mock private MiRepository repository;
    @Mock private CoreMaestrosClient coreMaestrosClient;
    @InjectMocks private MiServiceImpl service;

    @BeforeEach
    void setUp() {
        lenient().when(coreMaestrosClient.obtenerEntidadPorId(anyLong()))
                .thenReturn(FinanzasTestFixtures.mockEntidadResponse());
    }
}
```

#### Categorías de tests en services

| Categoría | Ejemplos |
|-----------|----------|
| **Validaciones** (crear) | moneda nula, moneda no existe, proveedor no existe, doc tipo no existe, fecha vencimiento anterior, total cero/negativo, detalles nulos/vacíos, artículo no existe, duplicado |
| **FeignException catch blocks** | 422 (UnprocessableEntity), 404 (NotFound), 400 (BadRequest), 503 (generic), Conflict |
| **DataIntegrityViolationException** (compensación) | FK doc_tipo, FK moneda, FK artículo, FK genérico, unique constraint, error interno |
| **Listar filtros** | proveedorId, docTipoId, solo fechaDesde, solo fechaHasta, ambas fechas, estado reconocido/no reconocido/blanco |
| **Anular** | normal, con saldo != total, sin asiento contable, FeignException |
| **Edge cases** | flag estado no activo, entity no encontrada, request con campos mínimos |

#### Manejo de FeignException

FeignException tiene métodos `final` (`contentUTF8()`), por lo que NO se puede mockear. En su lugar, se crean instancias reales con `Request`:

```java
private static FeignException crearFeignException(int status, String body) {
    byte[] bodyBytes = body != null ? body.getBytes(StandardCharsets.UTF_8) : new byte[0];
    Request request = Request.create(
            Request.HttpMethod.POST, "http://localhost/api/...",
            Collections.emptyMap(), bodyBytes, StandardCharsets.UTF_8, null);
    return switch (status) {
        case 422 -> new FeignException.UnprocessableEntity("...", request, bodyBytes, Collections.emptyMap());
        case 404 -> new FeignException.NotFound("...", request, bodyBytes, Collections.emptyMap());
        case 400 -> new FeignException.BadRequest("...", request, bodyBytes, Collections.emptyMap());
        default  -> new FeignException.InternalServerError("...", request, bodyBytes, Collections.emptyMap());
    };
}
```

#### Manejo de BusinessException

`BusinessException` extiende `RuntimeException` con Lombok `@Getter`. Tiene campos separados:
- `getErrorCode()` — código de error interno (ej. `FIN-107`)
- `getMessage()` — mensaje legible
- `getStatus()` — `HttpStatus`

Las aserciones deben verificar el mensaje, no el errorCode, a menos que se necesite validar el código exacto:

```java
assertThatThrownBy(() -> service.crear(request))
    .isInstanceOf(BusinessException.class)
    .hasMessageContaining("La moneda es obligatoria");
```

#### Manejo de UnnecessaryStubbingException

Stubs compartidos entre tests se declaran con `lenient()` en `@BeforeEach`. Stubs específicos de un test se declaran en el mismo test. Si un stub nunca se usa, Mockito lanza `UnnecessaryStubbingException`.

### Convenciones

- **Naming**: `metodo_escenario_resultadoEsperado` (ej. `crear_cuandoMonedaNula_lanzaBusinessException`)
- **@DisplayName**: descriptivo en español con `() ->` (ej. `"crear() con moneda nula -> lanza BusinessException (FIN-005)"`)
- **AAA**: Arrange → Act → Assert separados visualmente
- **AssertJ exclusivamente**: `assertThat`, `assertThatThrownBy`. Nunca JUnit assertions.
- **`verify()`** al final para validar interacciones con mocks
- **Secciones**: `// ==== sección ====` para agrupar tests relacionados
- **Datos**: solo C (fixtures RAM) o inline. Nunca A ni B en unit tests.

### Anti-patrones

```java
// PROHIBIDO: @SpringBootTest en unit test
@SpringBootTest
class MiTest { ... }

// PROHIBIDO: DataSource o A/B en unit test
@Autowired private DataSource ds;
new TestDataSeeder(ds).seedAll();

// PROHIBIDO: Mockito.mock() en vez de @Mock
CntasPagarRepository repo = Mockito.mock(CntasPagarRepository.class);

// PROHIBIDO: @MockBean en unit tests (es de Spring Boot)
@MockBean private CntasPagarRepository repository;

// PROHIBIDO: Mockear FeignException (tiene métodos final)
when(feign.contentUTF8()).thenReturn("..."); // No compila o runtime error
```

---

## B — Datos transaccionales del módulo

La factory B (`FinanzasTestDataFactory`) es un `@Component` en `src/main` que Spring inyecta en los tests de integración.

### Tablas que inserta `ensureFinanzasTransactionalData()`

| Tabla | IDs | Datos clave |
|-------|-----|-------------|
| `finanzas.banco` | 1, 2 | BANCO DE LA NACION (001), BANCO CREDITO (002) |
| `finanzas.banco_cnta` | 1, 2 | CUENTA BANCARIA 1 (001-123456), CUENTA BANCARIA 2 (002-789012) |
| `finanzas.concepto_financiero` | 1..4 | CF001 Cobro, CF002 Pago, CF003 Transferencia, CF004 Aplicacion |
| `finanzas.cntas_pagar` | 1001, 1002 | F001-00000001 (1180.00), F001-00000002 (2360.00) |
| `finanzas.cntas_pagar_det` | 5001..5004 | Detalles de las cuentas por pagar |
| `finanzas.caja_bancos` | 2001, 2002 | CB-00002001 (cobro), CB-00002002 (pago) |
| `finanzas.programacion_pago` | 8001 | Programacion de pago |

### ID de empresa y sucursal

- `empresa_id = 2`
- `sucursal_id = 1`
- `usuario_id = 1`

Establecidos por `TenantContextTestExecutionListener`.

### Smoke test de idempotencia

`FinanzasTestDataFactorySmokeIT` verifica que `ensureFinanzasTransactionalData()` sea idempotente (segunda ejecución produce los mismos resultados).

---

## Estructura de Directorios

```
ms-finanzas/src/
├── main/java/pe/restaurant/finanzas/
│   └── testdata/
│       └── FinanzasTestDataFactory.java                  ← B: @Component en main
│
└── test/
    ├── java/pe/restaurant/finanzas/
    │   ├── FinanzasTestFixtures.java                     ← C: fixtures RAM
    │   ├── mapper/                                       ← Unit tests de mappers
    │   │   ├── AutorizadorGiroMapperTest.java
    │   │   ├── BancoMapperTest.java
    │   │   ├── CntasPagarDetMapperTest.java
    │   │   ├── CntasPagarMapperTest.java
    │   │   ├── ConciliacionBancariaMapperTest.java       ← NUEVO
    │   │   ├── ConciliacionDetMapperTest.java            ← NUEVO
    │   │   ├── ConceptoFinancieroMapperTest.java
    │   │   ├── CuentaBancariaMapperTest.java
    │   │   ├── DetraccionMapperTest.java                 ← NUEVO
    │   │   ├── DocumentoDirectoDetalleMapperTest.java
    │   │   ├── DocumentoDirectoMapperTest.java           ← NUEVO
    │   │   ├── LiquidacionMapperTest.java                ← NUEVO
    │   │   ├── NotaDetalleMapperTest.java
    │   │   ├── NotaMapperTest.java                       ← NUEVO
    │   │   └── RetencionMapperTest.java                  ← NUEVO
    │   ├── service/                                      ← Unit tests de services
    │   │   ├── CajaBancosServiceTest.java
    │   │   ├── LetraCanjeServiceTest.java
    │   │   ├── ProgramacionPagoServiceTest.java
    │   │   └── impl/
    │   │       ├── AutorizadorGiroServiceImplTest.java    ← 20 tests (100% branch)
    │   │       ├── CntasPagarServiceImplTest.java
    │   │       ├── ConciliacionBancariaServiceImplTest.java
    │   │       ├── CuentaBancariaServiceImplTest.java      ← 22 tests (91.7% branch)
    │   │       ├── DetraccionServiceImplTest.java          ← 17 tests (80% branch)
    │   │       ├── DocumentoDirectoServiceImplTest.java
    │   │       ├── GrupoCodigoFlujoCajaServiceImplTest.java
    │   │       ├── NotaServiceImplTest.java
    │   │       ├── RetencionServiceImplTest.java
    │   │       └── SolicitudGiroServiceImplTest.java
    │   └── controller/
    │       ├── integration/                              ← ITs (@Tag("integration"))
    │       │   ├── AutorizadorGiroControllerIntegrationTest.java
    │       │   ├── ... (todos los controllers)
    │       │   └── FinanzasTestDataFactorySmokeIT.java
    │       └── CajaBancosControllerIntegrationTest.java
    └── resources/
        └── application-test.yml
```

---

## Comandos Maven

```bash
# Unit tests (rápidos, sin BD)
mvn test -pl ms-finanzas

# Solo integration tests
mvn test -pl ms-finanzas -Dgroups=integration

# Unit + Integration
mvn test -pl ms-finanzas -Dsurefire.excludedGroups=

# Con cobertura
mvn clean test jacoco:report -pl ms-finanzas

# Ver cobertura (HTML)
open ms-finanzas/target/site/jacoco/index.html
```

### Configuración Surefire

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <configuration>
        <excludedGroups>integration</excludedGroups>
    </configuration>
</plugin>
```

- Por defecto: solo unit tests (excluye `@Tag("integration")`).
- Para incluir ITs: sobrescribir con `-Dsurefire.excludedGroups=`.

---

## Tests Faltantes / Pendientes

Branch coverage en **81.0%** (superado umbral 80%). Las 3 prioridades medias del reporte QA previo fueron resueltas:

| Clase | Branch cov. (antes) | Branch cov. (ahora) | Acción |
|-------|--------------------|--------------------|--------|
| ~~AutorizadorGiroServiceImpl~~ | ~~43.8%~~ 🟡 | **100%** ✅ | 🟢 Código muerto eliminado + tests de ramas `\|\|` añadidos |
| ~~CuentaBancariaServiceImpl~~ | ~~66.7%~~ 🟡 | **91.7%** ✅ | 🟢 7 nuevos tests cubriendo todos los paths Feign |
| ~~DetraccionServiceImpl~~ | ~~60%~~ 🟡 | **80.0%** ✅ | 🟢 12 nuevos tests, ahora en umbral |
| GrupoCodigoFlujoCajaServiceImpl | 50% | 🟢 Baja | Cobertura parcial aceptable |
| LiquidacionService | 73.8% | 🟢 Baja | Cobertura parcial aceptable |
| BancoServiceImpl | 75% | 🟢 Baja | Cobertura parcial aceptable |
| AutorizadorGiroMapperImpl | 71.4% | 🟢 Baja | Mapper — cobertura parcial aceptable |

**Controllers**: branch no instrumentable — **artefacto**. Los controllers delegan lógica a servicios (87.6% branch). No requiere acción.

**FI333 (Devoluciones Liquidación)**: ⚠️ Sin IT dedicado. Crear `DevolucionControllerIntegrationTest`.

---

## Inventario Completo de Tests

### Unit Tests — Mappers (20 archivos)

| Archivo | Mapper probado |
|---------|----------------|
| `mapper/AutorizadorGiroMapperTest.java` | `AutorizadorGiroMapper` |
| `mapper/BancoMapperTest.java` | `BancoMapper` |
| `mapper/CntasPagarDetMapperTest.java` | `CntasPagarDetMapper` |
| `mapper/CntasPagarMapperTest.java` | `CntasPagarMapper` |
| `mapper/CodigoFlujoCajaMapperTest.java` | `CodigoFlujoCajaMapper` |
| `mapper/ConceptoFinancieroMapperTest.java` | `ConceptoFinancieroMapper` |
| `mapper/ConciliacionBancariaMapperTest.java` | `ConciliacionBancariaMapper` |
| `mapper/ConciliacionDetMapperTest.java` | `ConciliacionDetMapper` |
| `mapper/CuentaBancariaMapperTest.java` | `CuentaBancariaMapper` |
| `mapper/DetraccionMapperTest.java` | `DetraccionMapper` |
| `mapper/DocumentoDirectoDetalleMapperTest.java` | `DocumentoDirectoDetalleMapper` |
| `mapper/DocumentoDirectoMapperTest.java` | `DocumentoDirectoMapper` |
| `mapper/GrupoCodigoFlujoCajaMapperTest.java` | `GrupoCodigoFlujoCajaMapper` |
| `mapper/LetraCanjeMapperTest.java` | `LetraCanjeMapper` |
| `mapper/LiquidacionDetMapperTest.java` | `LiquidacionDetMapper` |
| `mapper/LiquidacionMapperTest.java` | `LiquidacionMapper` |
| `mapper/NotaDetalleMapperTest.java` | `NotaDetalleMapper` |
| `mapper/NotaMapperTest.java` | `NotaMapper` |
| `mapper/RetencionMapperTest.java` | `RetencionMapper` |
| `mapper/SolicitudGiroMapperTest.java` | ❌ **no existe** |

### Unit Tests — Services (22 archivos)

| Archivo | Service probado | Tests @Test | Branch cov. |
|---------|-----------------|-------------|-------------|
| `service/CajaBancosServiceTest.java` | `CajaBancosService` | 48 | 81.9% |
| `service/LetraCanjeServiceTest.java` | `LetraCanjeService` | 23 | 87.2% |
| `service/ProgramacionPagoServiceTest.java` | `ProgramacionPagoService` | 35 | 100% |
| `service/CntasPagarServiceTest.java` | `CntasPagarService` (legacy) | 12 | — |
| `service/CuentaBancariaServiceTest.java` | `CuentaBancariaService` (legacy) | 13 | — |
| `service/LiquidacionServiceTest.java` | `LiquidacionService` | 19 | 73.8% |
| `service/CodigoFlujoCajaServiceTest.java` | `CodigoFlujoCajaService` | 11 | 100% |
| `service/ConceptoFinancieroServiceTest.java` | `ConceptoFinancieroService` | 11 | 100% |
| `service/BancoServiceTest.java` | `BancoService` | — | 75% |
| `service/AutorizadorGiroServiceSimpleTest.java` | `AutorizadorGiroService` (legacy) | 10 | — |
| `service/BancoServiceSimpleTest.java` | `BancoService` (legacy) | — | — |
| `service/impl/AutorizadorGiroServiceImplTest.java` | `AutorizadorGiroServiceImpl` | **20** | **100%** 🟢 |
| `service/impl/CntasPagarServiceImplTest.java` | `CntasPagarServiceImpl` | 38 | 88% |
| `service/impl/ConciliacionBancariaServiceImplTest.java` | `ConciliacionBancariaServiceImpl` | 22 | 88.2% |
| `service/impl/CuentaBancariaServiceImplTest.java` | `CuentaBancariaServiceImpl` | **22** | **91.7%** 🟢 |
| `service/impl/DetraccionServiceImplTest.java` | `DetraccionServiceImpl` | **17** | **80.0%** 🟢 |
| `service/impl/DocumentoDirectoServiceImplTest.java` | `DocumentoDirectoServiceImpl` | 16 | 90% |
| `service/impl/GrupoCodigoFlujoCajaServiceImplTest.java` | `GrupoCodigoFlujoCajaServiceImpl` | — | 50% |
| `service/impl/NotaServiceImplTest.java` | `NotaServiceImpl` | 20 | 100% |
| `service/impl/RetencionServiceImplTest.java` | `RetencionServiceImpl` | 24 | 81.2% |
| `service/impl/SolicitudGiroServiceImplTest.java` | `SolicitudGiroServiceImpl` | 40 | 92% |
| `service/impl/LiquidacionServiceImplTest.java` | ❌ **no existe** | — | — |
| `service/impl/ConceptoFinancieroServiceImplTest.java` | ❌ **no existe** | — | — |
| `service/impl/BancoServiceImplTest.java` | ❌ **no existe** | — | — |

### Controller Tests (MockMvc standalone, 15 archivos)

| Archivo |
|---------|
| `controller/AutorizadorGiroControllerTest.java` |
| `controller/BancoControllerTest.java` |
| `controller/CajaBancosControllerTest.java` |
| `controller/CajaBancosControllerStandaloneTest.java` |
| `controller/CajaBancosControllerSimpleTest.java` |
| `controller/CntasPagarControllerTest.java` |
| `controller/CodigoFlujoCajaControllerTest.java` |
| `controller/ConceptoFinancieroControllerTest.java` |
| `controller/ConceptoFinancieroControllerTestDebug.java` |
| `controller/ConceptoFinancieroControllerTestSimple.java` |
| `controller/ConceptoFinancieroControllerTestUpdateDebug.java` |
| `controller/CuentaBancariaControllerTest.java` |
| `controller/GrupoCodigoFlujoCajaControllerTest.java` |
| `controller/LetraCanjeControllerTest.java` |
| `controller/LiquidacionControllerTest.java` |
| `controller/ProgramacionPagoControllerTest.java` |
| `controller/ProgramacionPagoControllerStandaloneTest.java` |
| `controller/SolicitudGiroControllerTest.java` |

### Integration Tests (@Tag("integration"), 19 archivos)

| Archivo |
|---------|
| `controller/integration/AutorizadorGiroControllerIntegrationTest.java` |
| `controller/integration/BancoControllerIntegrationTest.java` |
| `controller/integration/CajaBancosControllerIntegrationTest.java` |
| `controller/integration/CntasPagarControllerIntegrationTest.java` |
| `controller/integration/CodigoFlujoCajaControllerIntegrationTest.java` |
| `controller/integration/ConceptoFinancieroControllerIntegrationTest.java` |
| `controller/integration/ConciliacionBancariaControllerIntegrationTest.java` |
| `controller/integration/CuentaBancariaControllerIntegrationTest.java` |
| `controller/integration/CuentasPagarControllerIntegrationTest.java` |
| `controller/integration/DetraccionControllerIntegrationTest.java` |
| `controller/integration/DocumentoDirectoControllerIntegrationTest.java` |
| `controller/integration/GrupoCodigoFlujoCajaControllerIntegrationTest.java` |
| `controller/integration/LetraCanjeControllerIntegrationTest.java` |
| `controller/integration/LiquidacionControllerIntegrationTest.java` |
| `controller/integration/NotaControllerIntegrationTest.java` |
| `controller/integration/ProgramacionPagoControllerIntegrationTest.java` |
| `controller/integration/RetencionControllerIntegrationTest.java` |
| `controller/integration/SolicitudGiroControllerIntegrationTest.java` |
| `testdata/TestDataSeederFinanzasSmokeIT.java` |

### Otros Tests (6 archivos)

| Archivo | Propósito |
|---------|-----------|
| `domain/CntasPagarFlagEstadoTest.java` | Enum de flags de estado |
| `enums/TipoAsientoTest.java` | Enum de tipos de asiento |
| `enums/TipoMovimientoCxPTest.java` | Enum de movimientos CxP |
| `specification/CajaBancosSpecificationTest.java` | Specifications de búsqueda |
| `constants/SolicitudGiroConstantsTest.java` | Constantes del módulo |
| `FinanzasTestFixtures.java` | Fixtures C en RAM |

> **Total: ~82 archivos de test** (incluye duplicados legacy como `CajaBancosControllerTest` + `Simple` + `Standalone` + `Integration`).

---

## Evaluación QA

Veredicto QA (2026-05-23): **✅ GO** — ms-finanzas listo para integración frontend. **3/3 servicios críticos corregidos.**

### Resumen de métricas QA

| Métrica | Valor Anterior | Valor Actual | Umbral | Estado |
|---------|---------------|-------------|--------|--------|
| Instructions Coverage | 91.6% | **91.9%** | ≥ 80% | ✅ |
| Branch Coverage | 81.2% | **81.0%** | ≥ 80% | ✅ |
| Methods Coverage | 87.9% | ~79% | — | ✅ |
| Classes Coverage | 98.8% | **98.8%** | — | ✅ |
| Lines Coverage | 93.2% | **93.6%** | — | ✅ |

### Cobertura por paquete (QA)

| Paquete | Branch Anterior | Branch Actual | Estado |
|---------|----------------|---------------|--------|
| `domain` | 93.3% | 93.3% | ✅ |
| `enums` | 100% | 100% | ✅ |
| `specification` | 100% | 100% | ✅ |
| `mapper` | 84% | 82% | ✅ |
| `service.impl` | **83.5%** | **87.6%** | ✅ **Mejorado** |
| `service` (validators) | 83.2% | 82.4% | ✅ |
| `validation` | 83.3% | 83.3% | ✅ |
| `controller` | 34.2% | — | ⚠️ Artefacto — delegación a servicios |
| `config` | 35.7% | 35.7% | ⚠️ Beans Spring |
| `entity` | 50% | 50% | ⚠️ Lombok bytecode |

### Mapeo funcional QA

| Flujo | ITs Preparados | Unit Tests | Branch (service.impl) | Cambio | Estado |
|-------|---------------|------------|----------------------|--------|--------|
| **FI304** — CxP | 15 tests | 38 | 88% | — | ✅ |
| **FI307/FI308** — Giros | 27 tests | 50 | 92% | — | ✅ |
| **FI309/FI310** — Caja/Bancos | 18 tests | 48 | ~83% | — | ✅ |
| **FI320** — Notas | 10 tests | 20 | 100% | — | ✅ |
| **FI323/FI324** — Liquidación | 6 tests | 19 | ~83% | — | ✅ |
| **FI331** — Retenciones | 12 tests | 24 | 81.2% | — | ✅ |
| **FI334** — Detracciones | 12 tests | **17** | **80.0%** | 🟢 **60→80%** | ✅ |
| **FI347** — Conciliación | 8 tests | 22 | 88.2% | — | ✅ |
| **FI356** — Prog. Pagos | 14 tests | 35 | 100% | — | ✅ |
| **Letras/Canje** | 12 tests | 23 | 88.4% | — | ✅ |
| **CXP-DIRECTO** | 6 tests | 16 | 90% | — | ✅ |
| **Autorizador Giro** | 15 tests | **20** | **100%** | 🟢 **43.8→100%** | ✅ |
| **Cuenta Bancaria** | 13 tests | **22** | **91.7%** | 🟢 **66.7→91.7%** | ✅ |

### Riesgos QA identificados

| Riesgo | Severidad | Estado |
|--------|-----------|--------|
| ~~`AutorizadorGiroServiceImpl` 43.8% branch~~ | ~~🟡 Medio~~ | 🟢 **RESUELTO — 100% branch** |
| ~~`CuentaBancariaServiceImpl` 66.7% branch~~ | ~~🟡 Medio~~ | 🟢 **RESUELTO — 91.7% branch** |
| ~~`DetraccionServiceImpl` 60% branch~~ | ~~🟡 Medio~~ | 🟢 **RESUELTO — 80% branch** |
| ITs `@Tag("integration")` no activos en CI | 🟡 Medio | Pendiente |
| FI333 sin IT dedicado | 🟡 Medio | Pendiente |
| Controller branch | 🟢 Bajo | Artefacto — no requiere acción |
| Constants 0% | 🟢 Bajo | Artefacto — no requiere acción |

### Recomendaciones post-GO (actualizadas)

1. ✅ ~~Elevar `AutorizadorGiroServiceImpl` de 43.8% → ≥70% branch~~ **COMPLETADO (100%)**
2. ✅ ~~Ampliar `CuentaBancariaServiceImplTest` de 6 → ≥15 tests~~ **COMPLETADO (22 tests, 91.7%)**
3. ✅ ~~Ampliar `DetraccionServiceImplTest` de 5 → ≥12 tests~~ **COMPLETADO (17 tests, 80%)**
4. 🔲 Crear IT dedicado para FI333 (Devoluciones Liquidación)
5. 🔲 Activar los ITs `@Tag("integration")` en pipeline CI/CD

---

## Referencias

- Estándar de testing: [`05. Documentacion/markdown/Pruebas/TEST_STANDARDS.md`](../../../05.%20Documentacion/markdown/Pruebas/TEST_STANDARDS.md)
- Seeder compartido (A): `common/src/test/java/pe/restaurant/common/testutil/TestDataSeeder.java`
- Fachada compartida (A): `common/src/test/java/pe/restaurant/common/testutil/TestDataFactory.java`
- Factory B: `ms-finanzas/src/main/java/pe/restaurant/finanzas/testdata/FinanzasTestDataFactory.java`
- Fixtures C: `ms-finanzas/src/test/java/pe/restaurant/finanzas/FinanzasTestFixtures.java`
- Reporte QA completo: [`docs/qa/REPORTE-QA-ms-finanzas.md`] (pendiente de generar)

---

> Versión: 2.2 — ~986 tests, 81.0% branch coverage, 91.9% instruction coverage. QA: ✅ GO.
> Próximo objetivo: 80% branch consolidado — los 3 servicios críticos ya cumplen.
