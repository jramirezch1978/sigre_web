# ms-compras — Test Data y Pruebas

> Alineado con `TEST_STANDARDS.md` (convencion A / B / C).

---

## Tabla A / B / C

| Rol | Clase | Ubicacion | Metodos clave |
|-----|-------|-----------|---------------|
| **A** | `TestDataFactory` / `TestDataSeeder` (common) | `common/src/test/.../testutil/` | `seedDocTipo()`, `seedArticulo()`, `seedEntidadContribuyente()`, `seedComprador()`, `seedAprobadorConfigurado()`, `seedServicio()` |
| **B** | `ComprasTestDataFactory` | `src/main/.../testdata/` | `ensureComprasTransactionalData()`, `resolveArticuloId()`, `resolveProveedorId()`, `resolveSucursalId()`, `resolveServicioId()`, `resolveDocTipoId(codigo)` |
| **C** | `ComprasTestFixtures` | `src/test/.../compras/` | Entities: `ordenCompra()`, `ordenServicio()`, `solicitudCompra()`, `cotizacion()`, etc. Requests: `ordenCompraRequest()`, `ordenServicioRequest()`, etc. |

---

## Datos que siembra A (minimo compartido)

| Metodo seed | Tabla(s) | Registros |
|-------------|----------|-----------|
| `seedDocTipo()` | `core.doc_tipo` | OC, OS, SC, SS, FAP, FAC, BOL, RET, GRR, LCO |
| `seedArticulo()` | `core.articulo` | 5 articulos (ART-001..ART-005) |
| `seedEntidadContribuyente()` | `core.entidad_contribuyente` | 3 entidades (proveedor, cliente, transportista) |
| `seedComprador()` | `compras.comprador` | 2 compradores |
| `seedAprobadorConfigurado()` | `compras.aprobador_configurado` | 2 aprobadores (OC nivel 1, OS nivel 1) |
| `seedServicio()` | `compras.servicio` | 3 servicios (SRV001..SRV003) |

## Datos que siembra B (dominio compras)

| Metodo privado | Tabla(s) | Que hace |
|----------------|----------|----------|
| `ensureSingleActiveComprador()` | `compras.comprador` | Desactiva compradores duplicados para usuario_id=1 |
| `ensureNumOrdenServicio()` | `compras.num_ord_srv` | Crea numerador para OS en sucursales LM% |
| `ensureConfiguracionAprobacion()` | `core.configuracion` | Activa aprobacion para OC y OS |
| `ensureTipoPercepcion()` | `compras.tipo_percepcion` | Percepcion Venta Interna (51, 2%) |

---

## Comandos Maven

```bash
# Unitarios (rapido, sin BD)
mvn test -pl ms-compras

# Solo integration tests
mvn test -pl ms-compras -Dgroups=integration

# Con cobertura
mvn clean verify -pl ms-compras
```

---

## Estructura de directorios

```
ms-compras/
├── src/
│   ├── main/java/pe/restaurant/compras/
│   │   └── testdata/
│   │       └── ComprasTestDataFactory.java       <- B
│   └── test/java/pe/restaurant/compras/
│       ├── ComprasTestFixtures.java              <- C
│       ├── service/impl/                         <- Unit tests
│       ├── service/                              <- Validator/Calculator tests
│       ├── controller/                           <- Controller unit tests
│       ├── mapper/                               <- Mapper tests
│       ├── spec/                                 <- Specification tests
│       ├── config/                               <- Config tests
│       ├── util/                                 <- Utility tests
│       └── integration/                          <- IT (@Tag("integration"))
│           ├── ComprasFlowIntegrationTest.java
│           └── ComprasTestDataFactorySmokeIT.java
├── docs/
│   └── test-data-y-pruebas.md                    <- Este archivo
└── pom.xml
```
