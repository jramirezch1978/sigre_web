# Cómo funcionan los tests de ms-finanzas

> Explicación para desarrolladores que NO conocen Java ni Spring Boot.
> Pensá en esto como "la guía para entender qué carajo pasa cuando corremos los tests".

---

## 1. El problema que resuelven los tests

Cuando un desarrollador escribe código nuevo (ej: "agregar un botón para anular una cuenta por pagar"), necesita asegurarse de que:

1. **El código funciona** — si alguien llama al endpoint, responde lo que tiene que responder
2. **No rompe nada existente** — la función de anular no debería hacer que crear una cuenta explote
3. **Los casos raros funcionan** — ¿qué pasa si alguien manda `null`? ¿si el ID no existe? ¿si el servidor de contabilidad está caído?

Los tests se encargan de todo eso **automáticamente**. Cada vez que hacemos un cambio, corremos los tests y si todo pasa en verde, sabemos que no rompimos nada.

---

## 2. Los dos tipos de tests

### Unit Tests (pruebas unitarias)

**Idea**: probar una pieza chiquita de código, aislada del resto.

**Analogía**: como probar un motor de auto sacándolo del auto y conectándolo a una batería en un banco de trabajo. No necesitás todo el auto para saber si el motor prende.

**En la práctica**:
- No tocan la base de datos real
- No levantan el servidor
- Usan "mocks" — objetos falsos que simulan ser la base de datos o el servidor de contabilidad
- Son **ultrarrápidos** (milisegundos por test)
- Se corren con: `mvn test -pl ms-finanzas`

```
[NO base de datos] → [MOCK base datos] → [EL CÓDIGO QUE QUEREMOS PROBAR] → [MOCK servidor contabilidad]
```

### Integration Tests (pruebas de integración)

**Idea**: probar el sistema completo — desde que llega un request HTTP hasta que se escribe en la base de datos.

**Analogía**: encender el auto completo y meterlo en una pista de prueba. No es solo el motor, es todo: motor, ruedas, frenos, dirección.

**En la práctica**:
- Levantan el servidor Spring Boot completo
- Se conectan a una base de datos PostgreSQL real
- Insertan datos de prueba reales en tablas reales
- Hacen requests HTTP falsos y verifican las respuestas
- Son más lentos (segundos por test)
- Se corren con: `mvn test -pl ms-finanzas -Dgroups=integration`

```
[HTTP request] → [CONTROLADOR] → [SERVICIO] → [REPOSITORIO] → [BASE DE DATOS REAL]
```

---

## 3. Unit Tests en detalle

### Cómo se ven (para que entiendas la sintaxis)

```java
@Test
@DisplayName("crear() con moneda nula -> lanza error")
void crear_cuandoMonedaNula_lanzaBusinessException() {
    // 1. PREPARACIÓN (Arrange)
    CajaBancosRequest request = new CajaBancosRequest();
    request.setMonedaId(null);  // ← no le ponemos moneda

    // 2. EJECUCIÓN (Act)
    // Llamamos al servicio como si fuera código real
    
    // 3. VERIFICACIÓN (Assert)
    // Esperamos que tire un error diciendo "la moneda es obligatoria"
}
```

### El truco de los "mocks"

El servicio `CajaBancosService` normalmente necesita:
- Un repositorio (para guardar en base de datos)
- Un cliente HTTP (para llamar al microservicio de contabilidad)
- Un mapper (para convertir datos de un formato a otro)

En los unit tests, nada de eso es real. Son **mocks** — objetos que **simulan** ser esas cosas:

```java
@Mock
private CajaBancosRepository repository;    // ← parece base de datos pero no lo es

@Mock
private ContabilidadClient contabilidadClient; // ← parece servidor HTTP pero no lo es

@InjectMocks
private CajaBancosService service;  // ← el servicio REAL, pero con las dependencias falsas
```

Cuando el servicio llama a `repository.save(algo)`, el mock no guarda nada. En vez de eso, el test le dice al mock "cuando te llamen con esto, respondé ESTO":

```java
// "Cuando alguien llame a repository.save(), devolvé esto"
when(repository.save(any())).thenReturn(unObjetoFalso);
```

### Los dos tipos de errores que se prueban

**Errores esperados (BusinessException)**:
```java
assertThatThrownBy(() -> service.crear(request))
    .isInstanceOf(BusinessException.class)
    .hasMessageContaining("La moneda es obligatoria");
```
Esto dice: "ejecutá `service.crear(request)` y asegurate de que tire un error que diga 'La moneda es obligatoria'".

**Errores de servidores externos (FeignException)**:
Cuando el servicio llama al microservicio de contabilidad y este responde con error (400, 404, 422, 503), el servicio debe:
1. Capturar el error
2. NO explotar
3. Devolver un error en el idioma del negocio (ej: "El tipo de documento no existe")

Para probar esto, creamos errores HTTP falsos:
```java
FeignException error422 = new FeignException.UnprocessableEntity(
    "mensaje", requestHTTP, bodyBytes, headers);
when(contabilidadClient.generarAsiento(any())).thenThrow(error422);
```

### Qué cubre un test service típico

```
crear:
  ✅ validarMoneda    → moneda nula, moneda no existe
  ✅ validarProveedor → proveedor no existe  
  ✅ validarDocTipo   → tipo documento no existe
  ✅ validarFechas    → fecha vencimiento antes que emisión
  ✅ validarTotal     → total cero, total negativo
  ✅ validarDetalles  → detalles nulos, vacíos, artículo no existe
  ✅ validarDuplicado → documento repetido
  ✅ errores HTTP     → 422, 404, 400, 503, Conflict
  ✅ errores BD       → foreign key violada, unique constraint

listar:
  ✅ sin filtros
  ✅ con filtro proveedor
  ✅ con filtro tipo documento
  ✅ con filtro fechas
  ✅ con filtro estado

anular:
  ✅ normal
  ✅ con pagos ya aplicados (no se puede anular)
  ✅ sin asiento contable
  ✅ error del servidor de contabilidad
```

---

## 4. Integration Tests en detalle

### Cómo se ven

```java
@Tag("integration")     // ← etiqueta para separar de unit tests
@SpringBootTest         // ← levanta el servidor completo
@AutoConfigureMockMvc   // ← permite hacer HTTP requests falsos
@Transactional          // ← cada test se revierte al final (no ensucia BD)

void crear_conDatosValidos_retorna201() {
    // Hacemos un POST HTTP falso
    mockMvc.perform(post("/api/finanzas/cuentas-pagar")
            .header("Authorization", "Bearer mock-token")
            .contentType(MediaType.APPLICATION_JSON)
            .content("""{"proveedorId": 1, ...}"""))
        .andExpect(status().isCreated())     // ← esperamos HTTP 201
        .andExpect(jsonPath("$.success").value(true));
}
```

### La magia de @Transactional

Cada integration test corre dentro de una **transacción de base de datos**.
Cuando el test termina (pase o falle), la transacción se revierte automáticamente.
Esto significa que los tests **no contaminan la base de datos** entre ellos.

Los datos seed se insertan al principio y **desaparecen** cuando el test termina.

---

## 5. El sistema de semillas (A/B/C)

Cuando un integration test necesita datos en la base de datos, no los escribe a mano. Usa un sistema de 3 niveles:

### Nivel A — Datos compartidos (como los ingredientes básicos de la cocina)

Son datos que cualquier microservicio necesita: monedas (Soles, Dólares), sucursales, tipos de documento (Factura, Boleta, etc.).

Viven en la biblioteca `common` (compartida entre todos los microservicios).

```java
TestDataFactory.using(dataSource)
    .seedMoneda()      // INSERT Soles, Dólares
    .seedSucursal()    // INSERT sucursal principal
    .seedDocTipo();    // INSERT Factura, Boleta, etc.
```

Cada método `seed*()` es **idempotente**: si los datos ya existen, no los inserta de nuevo.

### Nivel B — Datos del módulo (como los ingredientes específicos de un plato)

Son datos que solo necesita finanzas: bancos, cuentas bancarias, conceptos financieros, cuentas por pagar de prueba.

Viven dentro del propio `ms-finanzas`.

```java
@Autowired
private FinanzasTestDataFactory moduloFactory;  // ← B

moduloFactory.ensureFinanzasTransactionalData();
```

Esto inserta:
- 2 bancos (Banco de la Nación, Banco de Crédito)
- 2 cuentas bancarias
- 4 conceptos financieros (Cobro, Pago, Transferencia, Aplicación)
- 2 cuentas por pagar con sus detalles
- 2 movimientos de caja/bancos
- 1 programación de pago

Cada método privado usa `COUNT(*)` para ver si los datos ya existen. Si no existen, los inserta. Si existen, no hace nada. Esto permite correr los tests muchas veces sin duplicar datos.

### Nivel C — Datos en memoria (como la lista de ingredientes antes de cocinar)

Son objetos Java comunes y corrientes que existen **solo en la RAM**. No están en la base de datos. Se usan exclusivamente en unit tests.

```java
// C — un objeto falso que parece un request HTTP
CajaBancosRequest request = new CajaBancosRequest();
request.setMonedaId(1L);
request.setTotal(new BigDecimal("1000.00"));
```

Estos objetos viven en `FinanzasTestFixtures.java` o se crean inline en cada test.

### Reglas de oro

| Situación | Usar |
|-----------|------|
| Unit test (sin base de datos) | Solo **C** |
| Integration test que necesita monedas | **A** + **B** |
| Integration test que necesita datos transaccionales | **A** + **B** |
| Body de un request HTTP en IT | **C** (solo para el JSON) |
| ¿Usar `seedAll()`? | **NUNCA** sin justificación documentada |

### El Listener mágico

En vez de correr los seeds A+B en cada test (lo cual es lento), hay un **listener** que los corre UNA SOLA VEZ al principio de toda la suite de integración:

```
[Inicio de la suite]
  │
  ├─ FinanzasTestDataExecutionListener
  │     ├─ seed A (monedas, sucursales...)
  │     └─ seed B (bancos, cuentas...)
  │
  ├─ Test 1 → usa los datos seedeados ✅
  ├─ Test 2 → usa los datos seedeados ✅
  ├─ ...
  └─ Test N → usa los datos seedeados ✅

[Fin de la suite]
```

Los datos se insertan una vez y cada test los ve gracias a `@Transactional` — cada test ve el estado inicial y al terminar sus cambios se revierten.

---

## 6. Cómo correr los tests

```bash
# Solo unit tests (rápido, 30 segundos aprox)
mvn test -pl ms-finanzas

# Solo integration tests (más lento, necesita conexión a BD)
mvn test -pl ms-finanzas -Dgroups=integration

# Unit + Integration
mvn test -pl ms-finanzas -Dsurefire.excludedGroups=

# Unit + JaCoCo (medir cobertura)
mvn clean test jacoco:report -pl ms-finanzas

# Ver cobertura
open ms-finanzas/target/site/jacoco/index.html
```

### Lo que significa cada cosa

- `-pl ms-finanzas`: solo este microservicio, no todo el proyecto
- `-Dgroups=integration`: solo los tests que tienen la etiqueta `@Tag("integration")`
- `jacoco:report`: genera un HTML con el porcentaje de código cubierto
- Los integration tests NO se corren por defecto porque son lentos y necesitan BD

---

## 7. Cómo organizamos los tests de servicios

Esta sección explica el **patrón concreto** que usamos en los 3 servicios que recién arreglamos (AutorizadorGiro, CuentaBancaria, Detracción).

### 7.1 El esqueleto de un test de servicio

> En el reporte JaCoCo, abrí `ms-finanzas/target/site/jacoco/index.html` — la columna **Element** tiene las clases, **Missed Instructions** son líneas no ejecutadas, **Missed Branches** son caminos lógicos (`if`) no probados.

```java
@ExtendWith(MockitoExtension.class)        // ← Mockito configura los mocks automáticamente
@DisplayName("Pruebas Unitarias - MiServicio")
class MiServicioImplTest {

    @Mock private MiRepositorio repository;           // ← simula la base de datos
    @Mock private CoreMaestrosClient coreMaestros;    // ← simula ms-core-maestros (Feign)
    @InjectMocks private MiServicioImpl service;      // ← el servicio REAL, con mocks inyectados

    private MiEntidad entidadValida;                   // ← datos de prueba (C)

    @BeforeEach
    void setUp() {
        entidadValida = new MiEntidad();
        entidadValida.setId(1L);
        entidadValida.setCodigo("TEST-001");
    }
```

**Qué significa cada cosa:**
- `@Mock`: crea un objeto falso. Si llamás a `repository.save()`, no guarda nada en BD.
- `@InjectMocks`: crea el servicio real y le mete los mocks adentro (como si le hiciera `setter` injection).
- `@BeforeEach`: se ejecuta antes de CADA test. Acá creamos los datos de prueba limpios.

### 7.2 Los 3 tipos de tests que escribimos

Cada método del servicio (crear, actualizar, eliminar) tiene 3 tipos de tests:

**✅ Camino feliz (happy path)** — todo sale bien:
```java
@Test
@DisplayName("create - Con datos válidos debe crear")
void create_ConDatosValidos_DebeCrear() {
    // Le decimos al mock: "cuando pregunten si el código existe, decí que no"
    when(repository.existsByCodigoIgnoreCase("TEST-001")).thenReturn(false);
    // Le decimos al mock: "cuando guarden, devolvé esto"
    when(repository.save(any())).thenReturn(entidadValida);

    BancoCnta resultado = service.create(entidadValida);

    assertThat(resultado).isNotNull();
    verify(repository).save(any());  // ← verificamos que SÍ se llamó a save()
}
```

**❌ Validaciones de negocio** — datos inválidos → error:
```java
@Test
@DisplayName("create - Cuando código ya existe debe lanzar error")
void create_CuandoCodigoDuplicado_DebeLanzarExcepcion() {
    // Le decimos al mock: "el código ya existe"
    when(repository.existsByCodigoIgnoreCase("TEST-001")).thenReturn(true);

    assertThatThrownBy(() -> service.create(entidadValida))
        .isInstanceOf(BusinessException.class)
        .hasMessageContaining("Ya existe");
    // verify(repository, never()).save(any());  // ← opcional: nunca llegó a guardar
}
```

**⚠️ Errores de comunicación** — el otro microservicio no responde:
```java
@Test
@DisplayName("create - Cuando Feign falla con error genérico")
void create_CuandoFeignError_DebeLanzarExcepcion() {
    // Le decimos al mock Feign: "tirá un error de comunicación"
    when(coreMaestros.obtenerPlanContableDetPorId(100L))
        .thenThrow(mock(FeignException.class));  // ← cualquier error Feign

    assertThatThrownBy(() -> service.create(entidadValida))
        .isInstanceOf(BusinessException.class)
        .hasMessageContaining("Error al validar");
}
```

### 7.3 El problema de las cadenas de validación

Algunos servicios validan varias cosas **en cadena** antes de crear. Ejemplo de `CuentaBancariaServiceImpl.create()`:

```
1. ¿planContableDetId es null?                → error si null
2. ¿existe el plan contable en ms-core?       → error si no existe
3. ¿el plan contable está activo?             → error si inactivo
4. ¿bancoId no es null?                       → validar banco local
5. ¿existe el banco en BD?                    → error si no existe
6. ¿monedaId no es null?                      → validar moneda
7. ¿existe la moneda en ms-core?              → error si no existe
8. ¿la moneda está activa?                    → error si inactiva
9. ¿ya existe el código?                      → error si duplicado
10. Guardar en BD                             → OK
```

**El truco**: cuando escribís un test para el paso 2 (plan contable no existe), tenés que asegurarte de que los pasos 1 y 3-9 no interfieran. Si el mock del paso 2 tira error, los pasos 3-9 nunca se ejecutan — pero Mockito igual se queja si hay stubs sin usar.

**Solución**: usar `lenient()` para los stubs que SOLO se usan en algunos tests:

```java
// En @BeforeEach o en el test mismo, para stubs que NO siempre se usan:
lenient().when(coreMaestros.obtenerMonedaPorId(1L))
    .thenReturn(FinanzasTestFixtures.mockMonedaResponse());
```

`lenient()` le dice a Mockito: "no te quejes si este stub nunca se usa en este test en particular".

### 7.4 Cómo mockeamos FeignException

FeignException es tricky porque sus métodos clave son `final` (no se pueden mockear). Por eso **no usamos** `when(feign.getMessage()).thenReturn(...)`.

En cambio, usamos `mock(FeignException.class)` directamente:

```java
// Para un 404 (Not Found):
when(coreMaestros.obtenerPlanContableDetPorId(999L))
    .thenThrow(mock(FeignException.NotFound.class));

// Para un error genérico (timeout, 500, etc):
when(coreMaestros.obtenerMonedaPorId(1L))
    .thenThrow(mock(FeignException.class));
```

El servicio captura estos errores y los traduce a `BusinessException` con mensajes del negocio.

### 7.5 Cómo medimos si un test es bueno

```java
// MAL TEST: solo prueba el camino feliz
void crear_conDatosValidos_funciona() { ... }

// BUEN TEST: prueba EL ÁRBOL DE DECISIONES completo
void crear_conDatosValidos_funciona() { ... }
void crear_sinMoneda_lanzaError() { ... }
void crear_sinProveedor_lanzaError() { ... }
void crear_conFeignError_lanzaError() { ... }
void crear_conDuplicado_lanzaError() { ... }
// Cada "if" en el código = al menos 2 tests (verdadero/falso)
```

**La regla de oro**: por cada `if` en el código, debería haber al menos 2 tests — uno para cada rama. Eso es lo que mide JaCoCo con "branch coverage".

---

## 8. Cómo leemos el reporte de cobertura (JaCoCo) — explicación técnica

> Ya viste arriba qué es cada columna. Acá explicamos **cómo interpretar los números** y por qué algunos paquetes tienen valores bajos sin que sea un problema.

### Cómo JaCoCo mide las ramas (branches)

JaCoCo no mira tu código fuente. Mira el **bytecode** que genera Java al compilar. Esto significa que cosas como `||` (OR lógico) que en tu código son una sola línea, en bytecode son **múltiples saltos condicionales**.

**Ejemplo: el `||` en `AutorizadorGiroServiceImpl.update()`**

```java
// Código fuente — parece una condición simple:
if ((!centros.equals(request.getCentrosCostoId())
      || !usuarioId.equals(usuarioIdToken))
    && repository.existsByCentrosCostoIdAndUsuarioIdAndIdNot(...)) {
    throw new BusinessException(...);
}
```

**En bytecode, esto genera MÚLTIPLES branches:**
```
branch 1: ¿centrosCostoId cambió?          → sí / no (2 branches)
branch 2: (solo si branch1=no) ¿usuarioId cambió? → sí / no (2 branches)
branch 3: (solo si branch1=sí o branch2=sí) ¿existe duplicado? → sí / no (2 branches)
```

**Total: 6 branches en una sola línea de código.** Si solo probás el caso donde `centrosCostoId` cambia y no hay duplicado, cubrís solo 2 de 6 branches.

**Lo que hicimos para llegar a 100%:** agregamos tests para:
- `centrosCostoId` igual + `usuarioId` igual → no evalúa `existsBy` (branch 1=no, branch 2=no)
- `centrosCostoId` igual + `usuarioId` distinto (via TenantContext) → evalúa `existsBy` (branch 1=no, branch 2=sí)

### El artefacto de controllers con 0% branch

Algunos paquetes aparecen con branch coverage bajo o 0% en el reporte. Esto NO significa que no tengan tests:

| Paquete | Branch reportado | Por qué |
|---------|-----------------|---------|
| `controller` | 0% o bajo | Los controllers Spring MVC casi no tienen `if` propios — delegan todo a servicios. JaCoCo no encuentra branches que medir. |
| `entity` | 50% | Lombok genera `equals()` y `hashCode()` que JaCoCo ve como branches, pero nadie los prueba porque no son lógica de negocio. |
| `constants` | 0% | Clases que solo tienen `static final String`. JaCoCo las ve como código no ejecutado. |

**Estos valores bajos son esperables y NO indican problemas de calidad.**

El reporte de JaCoCo tiene dos números clave:

| Métrica | Qué mide | Ejemplo |
|---------|----------|---------|
| **Instructions** | ¿Qué % de líneas de código se ejecutaron? | 91.9% = de cada 100 líneas, 92 se ejecutaron |
| **Branch** | ¿Qué % de caminos lógicos (`if`, `switch`) se probaron? | 81% = de cada 100 caminos, 81 se probaron |

**Branch es la más importante** porque mide qué tan bien cubriste los casos raros.

### El progreso que logramos

| Servicio | Branch antes | Branch ahora | Tests nuevos | Qué hicimos |
|----------|-------------|-------------|-------------|-------------|
| AutorizadorGiroServiceImpl | **43.8%** 🔴 | **100%** 🟢 | +15 tests | Eliminamos código muerto + cubrimos todas las ramas del `update()` |
| CuentaBancariaServiceImpl | **66.7%** 🔴 | **91.7%** 🟢 | +16 tests | Tests para validación Feign: response null, data null, inactivo, error 404, error genérico |
| DetraccionServiceImpl | **60%** 🔴 | **80.0%** 🟢 | +12 tests | Crear con/sin nro, actualizar validaciones, activar/desactivar edge cases |

---

## 9. Glosario (para no-Java)

| Término | Explicación |
|---------|-------------|
| **Maven** | Herramienta que compila el código y corre los tests. Como `npm` pero para Java. |
| **Spring Boot** | Framework que levanta el servidor web. Como Express.js o Django. |
| **Mockito** | Librería para crear "mocks" (objetos falsos) en unit tests. |
| **JUnit 5** | El "runner" de tests — el que dice "este método es un test" y lo ejecuta. |
| **AssertJ** | Librería para hacer verificaciones: `assertThat(resultado).isEqualTo(esperado)`. |
| **JaCoCo** | Herramienta que mide qué porcentaje del código está cubierto por tests. |
| **Feign** | Cliente HTTP para llamar a otros microservicios. Como `fetch` o `axios`. |
| **JPA / Hibernate** | ORM que convierte tablas SQL en objetos Java. |
| **Lombok** | Librería que genera getters/setters automáticamente. |
| **MapStruct** | Librería que genera código para convertir un tipo de objeto a otro. |

---

> Este documento asume cero conocimiento de Java/Spring. Si algo no se entiende,
> probablemente falta una analogía o ejemplo. Mejorarlo es responsabilidad de todos.
