# Reporte QA - ms-activos-fijos

> Modulo: `ms-activos-fijos`  
> Fecha de actualizacion: `2026-05-25`  
> Base de comparacion: [REPORTE_QA_MS_ACTIVOS_FIJOS_GO_NO_GO.md](C:/Users/Windows/Downloads/REPORTE_QA_MS_ACTIVOS_FIJOS_GO_NO_GO.md)  
> Estado final: `GO`

---

## 1. Resumen ejecutivo

El reporte QA original queda desactualizado frente al estado real del modulo. Hoy `ms-activos-fijos` tiene build estandar en verde, cobertura JaCoCo regenerada con `repository/**` incluido en el reporte, y una etapa formal de integracion controlada (`-Pit-controlado`) ya validada con evidencia real sobre el tenant.

Conclusión:

- `GO` tecnico para integracion y certificacion.
- Los puntos negativos principales del reporte viejo quedan cerrados o corregidos por evidencia nueva.
- El unico matiz operativo vigente es que una prueba de `ContabilidadIntegracionIT` sigue marcada como `skipped` por una precondicion explicita del tenant, no por falla del modulo.

---

## 2. Evidencia ejecutada hoy

### 2.1 Build estandar

Comando:

```bat
mvn --% -pl "02. Backend/ms-activos-fijos" test
```

Resultado:

- `996` tests
- `0` fallos
- `0` errores
- `0` skipped

### 2.2 Cobertura JaCoCo actualizada

HTML regenerado en:

- [index.html](D:/Restaurante/repo/restpe-contabilidad-back-end/02.%20Backend/ms-activos-fijos/target/site/jacoco/index.html)

Resumen actual:

| Metrica | Resultado |
|---|---:|
| Instructions | `94%` |
| Branch | `83%` |
| Methods | `92%` |
| Classes | `95%` |
| Lines | `94%` |

Paquetes mas relevantes:

| Paquete | Instructions | Branch |
|---|---:|---:|
| `pe.restaurant.activos.service.impl` | `93%` | `83%` |
| `pe.restaurant.activos.controller` | `94%` | `100%` |
| `pe.restaurant.activos.mapper` | `98%` | `80%` |
| `pe.restaurant.activos.repository` | `visible en JaCoCo` | `ya no excluido` |

Nota:

- `repository/**` ya no esta excluido del `pom.xml`.
- El paquete `repository` ahora aparece en el HTML de JaCoCo, por lo que la cobertura oficial ya no oculta esa capa.

### 2.3 Etapa de integracion controlada

Comando validado:

```bat
mvn --% -pl "02. Backend/ms-activos-fijos" -Pit-controlado -Djacoco.skip=true -Dit.test=AfClaseControllerIT,AfCalculoCntblControllerIT,ContabilidadIntegracionIT,ActivosTestDataFactorySmokeIT verify
```

Resultado:

- `14` tests
- `0` fallos
- `0` errores
- `1` skipped
- `BUILD SUCCESS`

Suites ejecutadas con evidencia real:

- `AfClaseControllerIT` -> `3/3` OK
- `AfCalculoCntblControllerIT` -> `2/2` OK
- `ContabilidadIntegracionIT` -> `4/5` OK, `1` skipped por precondicion del tenant
- `ActivosTestDataFactorySmokeIT` -> `4/4` OK

Detalle del `skipped` vigente:

- causa declarada por la propia suite: `Sin traslado EJECUTADO con CC distintos (centros_costo + columnas traslado en BD)`
- no corresponde a error funcional del modulo ni a falla de compilacion/arranque

La etapa formal y su uso quedaron documentados en:

- [test-data-y-pruebas.md](D:/Restaurante/repo/restpe-contabilidad-back-end/02.%20Backend/ms-activos-fijos/docs/test-data-y-pruebas.md)

---

## 3. Correccion de observaciones del reporte viejo

### 3.1 Ya no aplica "659 tests"

Estado anterior del reporte:

- indicaba `659 tests`

Estado real hoy:

- `996 tests`, `0` fallos, `0` errores, `0` skipped en `mvn test`

### 3.2 Ya no aplica "repository/** excluido"

Estado anterior del reporte:

- advertia que `repository/**` estaba fuera de JaCoCo y maquillaba cobertura

Estado real hoy:

- la exclusion fue retirada del `pom.xml`
- el paquete `pe.restaurant.activos.repository` ya aparece en el HTML de JaCoCo

### 3.3 Ya no aplica "sin IT real" o "no hay @SpringBootTest"

Estado anterior del reporte:

- sostenia que no habia validacion end-to-end real ni `@SpringBootTest` con BD real

Estado real hoy:

- la etapa `-Pit-controlado` existe formalmente en Maven
- `AfClaseControllerIT`, `AfCalculoCntblControllerIT`, `ContabilidadIntegracionIT` y `ActivosTestDataFactorySmokeIT` ya fueron ejecutadas contra el tenant real con `BUILD SUCCESS`
- `ContabilidadIntegracionIT` usa `@SpringBootTest` y valida persistencia real de asientos/activo-contabilidad

### 3.4 Ya no aplica "sin impl / reservado"

Estado anterior del reporte:

- marcaba como reservados o sin implementacion:
  - `ContabilidadAsientosEndpointConsumoTest`
  - `ComprasIntegracionServiceImplTest`
  - `ContabilidadIntegracionServiceImplTest`

Estado real hoy:

- ya existen pruebas directas para integracion contable y de compras en el repo
- `ContabilidadIntegracionIT` ya se ejecuto en etapa controlada con evidencia real
- el señalamiento "sin IT real" ya no corresponde al estado actual

---

## 4. Evaluacion final QA

### Hallazgos cerrados

- Build estandar estable y reproducible
- Cobertura JaCoCo actualizada y consistente con `repository/**` incluido
- Estrategia formal para IT reales en Maven
- Evidencia ampliada de integracion controlada, no solo smoke
- Integracion contable JDBC de pruebas alineada al tenant actual

### Riesgo residual no bloqueante

- Un escenario de `ContabilidadIntegracionIT` sigue condicionado por datos/precondiciones del tenant y se marca `skipped`
- Conviene seguir ampliando la tanda `-Pit-controlado` por familias funcionales, pero esto ya es mejora incremental y no condicion de `GO`

---

## 5. Veredicto

`GO`

Motivos:

- El modulo compila y pasa completo en el build estandar.
- La cobertura oficial fue regenerada y ya no oculta `repository/**`.
- La evidencia end-to-end ya no se limita a mocks ni a smoke tests.
- Las afirmaciones del reporte original sobre `659 tests`, "sin impl" y "sin IT real" quedaron superadas por ejecucion real del `2026-05-25`.
