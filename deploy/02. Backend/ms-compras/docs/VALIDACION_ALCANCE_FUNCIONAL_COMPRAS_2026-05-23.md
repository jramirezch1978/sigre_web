# Validacion Alcance Funcional ms-compras - 2026-05-23

## Resumen ejecutivo

Estado real de validacion al cierre:

- Build del modulo: `VALIDADO`
- Unit tests / controller tests: `VALIDADO`
- Cobertura objetivo QA (branch global 75%): `VALIDADO`
- Integracion real parcial con BD tenant: `VALIDADO PARCIAL`
- Alcance funcional completo end-to-end: `NO VALIDADO AL 100%`

## Evidencia ejecutada

- `mvn -pl "02. Backend/ms-compras" test`
  - Resultado: `823 tests`, `0 fallos`, `0 errores`
- `mvn -pl "02. Backend/ms-compras" "-Dcompras.it=true" "-Dsurefire.excludedGroups=" "-Dtest=ComprasFlowIntegrationTest,ComprasTestDataFactorySmokeIT" test`
  - Resultado: `20 tests`, `0 fallos`, `0 errores`, `10 skipped`

## Bloqueos reales de ambiente

El tenant de pruebas actual no expone estas tablas requeridas por parte del flujo compras:

- `compras.num_ord_srv`
- `compras.articulo_mov_proy`

Impacto:

- Sin `compras.num_ord_srv` no se puede certificar el flujo end-to-end de `OrdenServicio`.
- Sin `compras.articulo_mov_proy` no se puede certificar el flujo end-to-end de `OrdenCompra`.
- La conversion `Cotizacion -> OrdenCompra` queda indirectamente afectada por la misma ausencia de `articulo_mov_proy`.

## Bug funcional corregido hoy

Se corrigio un bug real en conversion de cotizacion a orden de compra:

- Archivo: [CotizacionServiceImpl.java](D:/Restaurante/repo/restpe-contabilidad-back-end/02.%20Backend/ms-compras/src/main/java/pe/restaurant/compras/service/impl/CotizacionServiceImpl.java)
- Hallazgo: al convertir una cotizacion a OC no se copiaba `fechaEntrega` a las lineas de la orden.
- Efecto: el validador de OC rechazaba la conversion con `COM-008`.
- Estado: `CORREGIDO Y VALIDADO`

## Matriz de alcance funcional

### 1. Solicitud de compra

Endpoints principales:

- `GET /api/compras/solicitudes-compra`
- `GET /api/compras/solicitudes-compra/{id}`
- `POST /api/compras/solicitudes-compra`
- `PUT /api/compras/solicitudes-compra/{id}`
- `POST /api/compras/solicitudes-compra/{id}/enviar`
- `POST /api/compras/solicitudes-compra/{id}/aprobar`
- `POST /api/compras/solicitudes-compra/{id}/rechazar`
- `POST /api/compras/solicitudes-compra/{id}/anular`
- `POST /api/compras/solicitudes-compra/{id}/convertir`
- `GET /api/compras/solicitudes-compra/{id}/trazabilidad`

Estado:

- Cobertura controller: `VALIDADA`
- Cobertura service: `VALIDADA`
- Integracion real:
  - crear: `VALIDADO`
  - enviar: `VALIDADO`
  - aprobar: `VALIDADO`
  - rechazar: `VALIDADO`
  - anular: `VALIDADO`
  - convertir: `VALIDADO PARCIAL`
- Dictamen funcional: `ALTO GRADO DE VALIDACION`

### 2. Cotizacion

Endpoints principales:

- `GET /api/compras/cotizaciones`
- `GET /api/compras/cotizaciones/comparativo`
- `GET /api/compras/cotizaciones/{id}`
- `POST /api/compras/cotizaciones`
- `PUT /api/compras/cotizaciones/{id}`
- `POST /api/compras/cotizaciones/{id}/seleccionar`
- `POST /api/compras/cotizaciones/{id}/descartar`
- `POST /api/compras/cotizaciones/{id}/anular`
- `POST /api/compras/cotizaciones/{id}/convertir-oc`

Estado:

- Cobertura controller: `VALIDADA`
- Cobertura service: `VALIDADA`
- Integracion real:
  - crear: `VALIDADO`
  - convertir a OC: `BLOQUEADO POR AMBIENTE`
- Dictamen funcional: `PARCIALMENTE VALIDADO`

### 3. Orden de compra

Endpoints principales:

- `GET /api/compras/ordenes-compra`
- `GET /api/compras/ordenes-compra/pendientes-aprobacion`
- `GET /api/compras/ordenes-compra/{id}`
- `POST /api/compras/ordenes-compra`
- `PUT /api/compras/ordenes-compra/{id}`
- `POST /api/compras/ordenes-compra/{id}/enviar-aprobacion`
- `POST /api/compras/ordenes-compra/{id}/aprobar`
- `POST /api/compras/ordenes-compra/{id}/rechazar`
- `POST /api/compras/ordenes-compra/{id}/devolver`
- `POST /api/compras/ordenes-compra/{id}/anular`
- `POST /api/compras/ordenes-compra/{id}/cerrar`
- `GET /api/compras/ordenes-compra/{id}/historial-aprobaciones`
- `GET /api/compras/ordenes-compra/{id}/recepciones`
- `GET /api/compras/ordenes-compra/{id}/saldo-pendiente`
- `POST /api/compras/ordenes-compra/{id}/recepcionar-almacen`
- `GET /api/compras/ordenes-compra/datos-articulo`
- `POST /api/compras/ordenes-compra/{id}/enviar-proveedor`
- `POST /api/compras/ordenes-compra/{id}/pdf`

Estado:

- Cobertura controller: `VALIDADA`
- Cobertura service: `VALIDADA`
- Integracion real: `NO CERTIFICABLE EN ESTE TENANT`
- Causa: falta `compras.articulo_mov_proy`
- Dictamen funcional: `VALIDACION PARCIAL SOLO POR UNIT/CONTROLLER`

### 4. Orden de servicio

Endpoints principales:

- `GET /api/compras/ordenes-servicio`
- `GET /api/compras/ordenes-servicio/pendientes-aprobacion`
- `GET /api/compras/ordenes-servicio/{id}`
- `POST /api/compras/ordenes-servicio`
- `PUT /api/compras/ordenes-servicio/{id}`
- `POST /api/compras/ordenes-servicio/{id}/enviar-aprobacion`
- `POST /api/compras/ordenes-servicio/{id}/aprobar`
- `POST /api/compras/ordenes-servicio/{id}/rechazar`
- `POST /api/compras/ordenes-servicio/{id}/devolver`
- `POST /api/compras/ordenes-servicio/{id}/anular`
- `POST /api/compras/ordenes-servicio/{id}/cerrar`
- `POST /api/compras/ordenes-servicio/{id}/lineas/{lineaId}/conformidad`
- `DELETE /api/compras/ordenes-servicio/{id}/lineas/{lineaId}/conformidad`
- `POST /api/compras/ordenes-servicio/{id}/ajuste-valor`
- `GET /api/compras/ordenes-servicio/{id}/historial-aprobaciones`
- `GET /api/compras/ordenes-servicio/{id}/saldo-pendiente`
- `GET /api/compras/ordenes-servicio/{id}/cuentas-pagar`
- `GET /api/compras/ordenes-servicio/servicios-disponibles`
- `GET /api/compras/ordenes-servicio/datos-servicio`
- `POST /api/compras/ordenes-servicio/{id}/enviar-proveedor`
- `GET /api/compras/ordenes-servicio/pendientes-conformidad`
- `POST /api/compras/ordenes-servicio/{id}/asignar-oc`
- `GET /api/compras/ordenes-servicio/{id}/pdf`
- `GET /api/compras/ordenes-servicio/{id}/acta-conformidad/pdf`

Estado:

- Cobertura controller: `VALIDADA`
- Cobertura service: `VALIDADA`
- Integracion real: `NO CERTIFICABLE EN ESTE TENANT`
- Causa: falta `compras.num_ord_srv`
- Dictamen funcional: `VALIDACION PARCIAL SOLO POR UNIT/CONTROLLER`

### 5. Conformidad de servicio

Endpoints principales:

- `GET /api/compras/actas-conformidad`
- `GET /api/compras/actas-conformidad/pendientes`
- `GET /api/compras/actas-conformidad/{id}`
- `POST /api/compras/actas-conformidad`
- `PUT /api/compras/actas-conformidad/{id}`
- `POST /api/compras/actas-conformidad/{id}/aprobar`
- `POST /api/compras/actas-conformidad/{id}/anular`
- `GET /api/compras/actas-conformidad/{id}/pdf`

Estado:

- Cobertura controller: `VALIDADA`
- Cobertura service: `VALIDADA`
- Integracion real end-to-end: `NO VALIDADA`
- Dictamen funcional: `PARCIALMENTE VALIDADO`

### 6. Programacion de compras

Endpoints principales:

- `GET /api/compras/programaciones`
- `GET /api/compras/programaciones/{id}`
- `POST /api/compras/programaciones`
- `PUT /api/compras/programaciones/{id}`
- `POST /api/compras/programaciones/{id}/confirmar`
- `POST /api/compras/programaciones/{id}/anular`

Estado:

- Cobertura controller: `VALIDADA`
- Cobertura service: `VALIDADA`
- Integracion real end-to-end: `NO VALIDADA`
- Dictamen funcional: `PARCIALMENTE VALIDADO`

### 7. Contrato marco

Endpoints principales:

- `GET /api/compras/contratos-marco`
- `GET /api/compras/contratos-marco/por-vencer`
- `GET /api/compras/contratos-marco/{id}`
- `POST /api/compras/contratos-marco`
- `PUT /api/compras/contratos-marco/{id}`
- `POST /api/compras/contratos-marco/{id}/suspender`
- `POST /api/compras/contratos-marco/{id}/reabrir`
- `POST /api/compras/contratos-marco/{id}/cerrar`
- `POST /api/compras/contratos-marco/{id}/anular`
- `GET /api/compras/contratos-marco/{id}/oc-generadas`

Estado:

- Cobertura controller: `VALIDADA`
- Cobertura service: `VALIDADA`
- Integracion real end-to-end: `NO VALIDADA`
- Dictamen funcional: `PARCIALMENTE VALIDADO`

### 8. Maestros

Incluye:

- `tipos-entidad-contribuyente`
- `aprobadores`
- `compradores`
- `compradores/{id}/categorias`
- `articulo-precios-pactados`
- `articulo-estructuras`
- `servicios-catalogo`

Estado:

- Cobertura controller: `VALIDADA`
- Cobertura service: `VALIDADA`
- Integracion real end-to-end: `NO VALIDADA DE FORMA INTEGRAL`
- Dictamen funcional: `PARCIALMENTE VALIDADO`

## Conclusiones

1. El modulo `ms-compras` quedo fuerte en unitarios, controllers y cobertura.
2. Se validaron flujos funcionales reales de `SolicitudCompra` y parte de `Cotizacion`.
3. No existe evidencia para afirmar hoy que TODO el alcance funcional esta validado end-to-end.
4. La principal causa no es ausencia de pruebas unitarias, sino falta de esquema completo en el tenant de integracion y falta de ITs que cubran todos los subdominios.

## Recomendacion formal

Estado recomendado:

- `GO TECNICO CONDICIONADO`

Condiciones para afirmar validacion funcional completa:

1. Provisionar en el tenant de pruebas las tablas `compras.num_ord_srv` y `compras.articulo_mov_proy`.
2. Rehabilitar como obligatorios los escenarios de `OrdenCompra`, `OrdenServicio` y `Cotizacion -> OC` hoy marcados como `skipped`.
3. Extender las IT para `ConformidadServicio`, `ProgramacionCompras`, `ContratoMarco` y maestros criticos.
