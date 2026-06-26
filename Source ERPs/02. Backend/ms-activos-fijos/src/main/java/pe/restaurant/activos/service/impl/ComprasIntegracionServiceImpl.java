package pe.restaurant.activos.service.impl;

import feign.FeignException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.client.ComprasActivosClient;
import pe.restaurant.activos.client.dto.compras.OrdenCompraDetalleResponse;
import pe.restaurant.activos.client.dto.compras.OrdenCompraLineaResponse;
import pe.restaurant.activos.config.IntegracionProperties;
import pe.restaurant.activos.client.dto.compras.RecepcionResumenResponse;
import pe.restaurant.activos.dto.AfMaestroDesdeCompraRequest;
import pe.restaurant.activos.dto.AfMaestroDesdeFacturaCompraRequest;
import pe.restaurant.activos.dto.AfMaestroDesdeRecepcionRequest;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.service.AfHistorialRegistroService;
import pe.restaurant.activos.service.AfMaestroService;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.service.ComprasIntegracionService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;

import java.math.BigDecimal;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ComprasIntegracionServiceImpl implements ComprasIntegracionService {

    private final IntegracionProperties integracionProperties;
    private final ComprasActivosClient comprasClient;
    private final AfMaestroRepository maestroRepository;
    private final AfMaestroService maestroService;
    private final AfHistorialRegistroService historialRegistroService;
    private final ContabilidadIntegracionService contabilidadIntegracionService;
    private final ContabilidadAutoContabilizador contabilidadAutoContabilizador;
    private final JdbcTemplate jdbcTemplate;

    @Override
    @Transactional
    public AfMaestro crearMaestroDesdeOrdenCompra(AfMaestroDesdeCompraRequest request) {
        if (!integracionProperties.getCompras().isHabilitada()) {
            throw new BusinessException(
                    "Integración con compras deshabilitada",
                    HttpStatus.SERVICE_UNAVAILABLE,
                    ActivosErrorCodes.INTEGRACION_COMPRAS_DESHABILITADA);
        }

        if (existeActivoVinculadoOcLinea(request.getOrdenCompraId(), request.getOrdenCompraLineaId())) {
            throw new BusinessException(
                    "Ya existe un activo vinculado a esta línea de orden de compra",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.ACTIVO_YA_VINCULADO_OC);
        }

        OrdenCompraDetalleResponse oc = obtenerOrdenCompra(request.getOrdenCompraId());
        OrdenCompraLineaResponse linea = oc.getLineas().stream()
                .filter(l -> request.getOrdenCompraLineaId().equals(l.getId()))
                .findFirst()
                .orElseThrow(() -> new BusinessException(
                        "La línea no pertenece a la orden de compra indicada",
                        HttpStatus.BAD_REQUEST,
                        ActivosErrorCodes.ORDEN_COMPRA_LINEA_INVALIDA));

        validarImporteLinea(linea, request.getValorAdquisicion());
        validarProveedor(oc, request.getProveedorId());

        AfMaestro entity = new AfMaestro();
        entity.setCodigo(request.getCodigo());
        entity.setNombre(resolverNombre(request, linea));
        entity.setAfSubClaseId(request.getAfSubClaseId());
        entity.setAfUbicacionId(request.getAfUbicacionId());
        entity.setFechaAdquisicion(request.getFechaAdquisicion() != null
                ? request.getFechaAdquisicion()
                : oc.getFechaEmision());
        entity.setValorAdquisicion(request.getValorAdquisicion());
        entity.setValorResidual(request.getValorResidual());
        entity.setProveedorId(request.getProveedorId() != null ? request.getProveedorId() : oc.getProveedorId());
        entity.setOrdenCompraId(request.getOrdenCompraId());
        entity.setOrdenCompraLineaId(request.getOrdenCompraLineaId());

        AfMaestro creado = maestroService.create(entity);

        historialRegistroService.registrar(
                creado.getId(),
                "ALTA_DESDE_COMPRA",
                "Activo creado desde OC " + oc.getNroOrdenCompra() + " línea " + linea.getId(),
                null,
                "OC=" + request.getOrdenCompraId() + "|LINEA=" + request.getOrdenCompraLineaId(),
                "AF_COMPRAS");

        log.info("Activo {} creado desde OC {} línea {}", creado.getId(), request.getOrdenCompraId(),
                request.getOrdenCompraLineaId());
        contabilizarAltaSiAutomatico(creado);
        return creado;
    }

    @Override
    @Transactional
    public AfMaestro crearMaestroDesdeRecepcion(AfMaestroDesdeRecepcionRequest request) {
        if (!integracionProperties.getCompras().isHabilitada()) {
            throw new BusinessException(
                    "Integración con compras deshabilitada",
                    HttpStatus.SERVICE_UNAVAILABLE,
                    ActivosErrorCodes.INTEGRACION_COMPRAS_DESHABILITADA);
        }
        if (existeActivoVinculadoOcLinea(request.getOrdenCompraId(), request.getOrdenCompraLineaId())) {
            throw new BusinessException(
                    "Ya existe un activo vinculado a esta línea de orden de compra",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.ACTIVO_YA_VINCULADO_OC);
        }
        OrdenCompraDetalleResponse oc = obtenerOrdenCompra(request.getOrdenCompraId());
        validarRecepcion(request.getOrdenCompraId(), request.getRecepcionId());
        OrdenCompraLineaResponse linea = oc.getLineas().stream()
                .filter(l -> request.getOrdenCompraLineaId().equals(l.getId()))
                .findFirst()
                .orElseThrow(() -> new BusinessException(
                        "La línea no pertenece a la orden de compra indicada",
                        HttpStatus.BAD_REQUEST,
                        ActivosErrorCodes.ORDEN_COMPRA_LINEA_INVALIDA));
        validarImporteLinea(linea, request.getValorAdquisicion());
        validarProveedor(oc, request.getProveedorId());

        AfMaestro entity = new AfMaestro();
        entity.setCodigo(request.getCodigo());
        entity.setNombre(resolverNombreRecepcion(request, linea));
        entity.setAfSubClaseId(request.getAfSubClaseId());
        entity.setAfUbicacionId(request.getAfUbicacionId());
        entity.setFechaAdquisicion(request.getFechaAdquisicion() != null
                ? request.getFechaAdquisicion()
                : oc.getFechaEmision());
        entity.setValorAdquisicion(request.getValorAdquisicion());
        entity.setValorResidual(request.getValorResidual());
        entity.setProveedorId(request.getProveedorId() != null ? request.getProveedorId() : oc.getProveedorId());
        entity.setOrdenCompraId(request.getOrdenCompraId());
        entity.setOrdenCompraLineaId(request.getOrdenCompraLineaId());
        entity.setRecepcionCompraId(request.getRecepcionId());

        AfMaestro creado = maestroService.create(entity);
        historialRegistroService.registrar(
                creado.getId(),
                "ALTA_DESDE_RECEPCION",
                "Activo desde recepción " + request.getRecepcionId() + " OC " + oc.getNroOrdenCompra(),
                null,
                "OC=" + request.getOrdenCompraId() + "|REC=" + request.getRecepcionId(),
                "AF_COMPRAS");
        contabilizarAltaSiAutomatico(creado);
        return creado;
    }

    @Override
    @Transactional
    public AfMaestro crearMaestroDesdeFacturaCompra(AfMaestroDesdeFacturaCompraRequest request) {
        if (!integracionProperties.getCompras().isHabilitada()) {
            throw new BusinessException(
                    "Integración con compras deshabilitada",
                    HttpStatus.SERVICE_UNAVAILABLE,
                    ActivosErrorCodes.INTEGRACION_COMPRAS_DESHABILITADA);
        }
        if (existeActivoVinculadoOcLinea(request.getOrdenCompraId(), request.getOrdenCompraLineaId())) {
            throw new BusinessException(
                    "Ya existe un activo vinculado a esta línea de orden de compra",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.ACTIVO_YA_VINCULADO_OC);
        }

        OrdenCompraDetalleResponse oc = obtenerOrdenCompra(request.getOrdenCompraId());
        OrdenCompraLineaResponse linea = oc.getLineas().stream()
                .filter(l -> request.getOrdenCompraLineaId().equals(l.getId()))
                .findFirst()
                .orElseThrow(() -> new BusinessException(
                        "La línea no pertenece a la orden de compra indicada",
                        HttpStatus.BAD_REQUEST,
                        ActivosErrorCodes.ORDEN_COMPRA_LINEA_INVALIDA));

        if (linea.getCantFacturada() == null || linea.getCantFacturada().compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException(
                    "La línea de OC no tiene cantidad facturada; no procede alta desde factura",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.LINEA_SIN_FACTURAR);
        }

        validarImporteLinea(linea, request.getValorAdquisicion());
        Long proveedorId = request.getProveedorId() != null ? request.getProveedorId() : oc.getProveedorId();
        validarProveedor(oc, proveedorId);

        if (proveedorId != null && maestroRepository.existsByProveedorIdAndFacturaProveedorSerieIgnoreCaseAndFacturaProveedorNumeroIgnoreCase(
                proveedorId, request.getFacturaSerie().trim(), request.getFacturaNumero().trim())) {
            throw new BusinessException(
                    "Ya existe un activo con la misma factura de proveedor",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.FACTURA_PROVEEDOR_DUPLICADA);
        }

        AfMaestro entity = new AfMaestro();
        entity.setCodigo(request.getCodigo());
        entity.setNombre(resolverNombreFactura(request, linea));
        entity.setAfSubClaseId(request.getAfSubClaseId());
        entity.setAfUbicacionId(request.getAfUbicacionId());
        entity.setFechaAdquisicion(request.getFechaAdquisicion() != null
                ? request.getFechaAdquisicion()
                : request.getFacturaFecha());
        entity.setValorAdquisicion(request.getValorAdquisicion());
        entity.setValorResidual(request.getValorResidual());
        entity.setProveedorId(proveedorId);
        entity.setOrdenCompraId(request.getOrdenCompraId());
        entity.setOrdenCompraLineaId(request.getOrdenCompraLineaId());
        entity.setFacturaProveedorSerie(request.getFacturaSerie().trim());
        entity.setFacturaProveedorNumero(request.getFacturaNumero().trim());
        entity.setFacturaProveedorFecha(request.getFacturaFecha());

        AfMaestro creado = maestroService.create(entity);
        historialRegistroService.registrar(
                creado.getId(),
                "ALTA_DESDE_FACTURA",
                "Activo desde factura " + request.getFacturaSerie() + "-" + request.getFacturaNumero()
                        + " OC " + oc.getNroOrdenCompra(),
                null,
                "OC=" + request.getOrdenCompraId() + "|FAC=" + request.getFacturaSerie() + "-" + request.getFacturaNumero(),
                "AF_COMPRAS");
        contabilizarAltaSiAutomatico(creado);
        return creado;
    }

    private String resolverNombreFactura(AfMaestroDesdeFacturaCompraRequest request, OrdenCompraLineaResponse linea) {
        if (request.getNombre() != null && !request.getNombre().isBlank()) {
            return request.getNombre().trim();
        }
        if (linea.getArticuloDescripcion() != null && !linea.getArticuloDescripcion().isBlank()) {
            return linea.getArticuloDescripcion().trim();
        }
        return request.getCodigo();
    }

    private void contabilizarAltaSiAutomatico(AfMaestro creado) {
        contabilidadAutoContabilizador.ejecutarSiAutomatico(
                "alta-desde-compra",
                () -> contabilidadIntegracionService.contabilizarAltaActivo(creado.getId()));
    }

    private boolean existeActivoVinculadoOcLinea(Long ordenCompraId, Long ordenCompraLineaId) {
        if (ordenCompraId == null || ordenCompraLineaId == null) {
            return false;
        }
        if (jdbcTemplate == null) {
            return maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(ordenCompraId, ordenCompraLineaId);
        }
        if (!columnExists("activos", "af_maestro", "orden_compra_id")
                || !columnExists("activos", "af_maestro", "orden_compra_linea_id")) {
            log.debug("af_maestro no tiene columnas de compras en este tenant; se omite validacion OC/linea");
            return maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(ordenCompraId, ordenCompraLineaId);
        }
        Integer count = jdbcTemplate.queryForObject(
                """
                SELECT COUNT(*)::int
                FROM activos.af_maestro
                WHERE orden_compra_id = ?
                  AND orden_compra_linea_id = ?
                  AND flag_estado = '1'
                """,
                Integer.class,
                ordenCompraId,
                ordenCompraLineaId);
        return count != null && count > 0;
    }

    private boolean columnExists(String schema, String table, String column) {
        Integer count = jdbcTemplate.queryForObject(
                """
                SELECT COUNT(*)::int
                FROM information_schema.columns
                WHERE table_schema = ?
                  AND table_name = ?
                  AND column_name = ?
                """,
                Integer.class,
                schema,
                table,
                column);
        return count != null && count > 0;
    }

    private void validarRecepcion(Long ordenCompraId, Long recepcionId) {
        try {
            ApiResponse<java.util.List<RecepcionResumenResponse>> response =
                    comprasClient.listarRecepciones(ordenCompraId);
            if (response == null || response.getData() == null) {
                throw recepcionNoEncontrada();
            }
            boolean ok = response.getData().stream().anyMatch(r -> recepcionId.equals(r.getId()));
            if (!ok) {
                throw recepcionNoEncontrada();
            }
        } catch (FeignException e) {
            log.error("Error al listar recepciones: {}", e.getMessage());
            throw recepcionNoEncontrada();
        }
    }

    private static BusinessException recepcionNoEncontrada() {
        return new BusinessException(
                "Recepción no encontrada para la orden de compra",
                HttpStatus.NOT_FOUND,
                ActivosErrorCodes.RECEPCION_COMPRA_NO_ENCONTRADA);
    }

    private OrdenCompraDetalleResponse obtenerOrdenCompra(Long ordenCompraId) {
        try {
            ApiResponse<OrdenCompraDetalleResponse> response = comprasClient.obtenerOrdenCompra(ordenCompraId);
            if (response == null || response.getData() == null) {
                throw new BusinessException(
                        "Orden de compra no encontrada",
                        HttpStatus.NOT_FOUND,
                        ActivosErrorCodes.ORDEN_COMPRA_NO_ENCONTRADA);
            }
            OrdenCompraDetalleResponse oc = response.getData();
            if (oc.getLineas() == null || oc.getLineas().isEmpty()) {
                throw new BusinessException(
                        "La orden de compra no tiene líneas",
                        HttpStatus.BAD_REQUEST,
                        ActivosErrorCodes.ORDEN_COMPRA_LINEA_INVALIDA);
            }
            return oc;
        } catch (FeignException.NotFound e) {
            throw new BusinessException(
                    "Orden de compra no encontrada en ms-compras",
                    HttpStatus.NOT_FOUND,
                    ActivosErrorCodes.ORDEN_COMPRA_NO_ENCONTRADA);
        } catch (FeignException e) {
            log.error("Error Feign ms-compras: {}", e.getMessage());
            throw new BusinessException(
                    "No fue posible consultar la orden de compra: " + e.getMessage(),
                    HttpStatus.BAD_GATEWAY,
                    ActivosErrorCodes.ORDEN_COMPRA_NO_ENCONTRADA);
        }
    }

    private void validarImporteLinea(OrdenCompraLineaResponse linea, BigDecimal valorActivo) {
        BigDecimal referencia = linea.getSubtotal() != null ? linea.getSubtotal() : linea.getValorUnitario();
        if (referencia == null) {
            return;
        }
        BigDecimal diff = valorActivo.subtract(referencia).abs();
        if (diff.compareTo(integracionProperties.getCompras().getToleranciaImporte()) > 0) {
            throw new BusinessException(
                    "El valor de adquisición (" + valorActivo + ") no cuadra con el subtotal de la línea ("
                            + referencia + ")",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.IMPORTE_NO_CUADRA_COMPRA);
        }
    }

    private void validarProveedor(OrdenCompraDetalleResponse oc, Long proveedorRequest) {
        if (proveedorRequest == null || oc.getProveedorId() == null) {
            return;
        }
        if (!proveedorRequest.equals(oc.getProveedorId())) {
            throw new BusinessException(
                    "El proveedor del activo no coincide con el de la orden de compra",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.PROVEEDOR_NO_COINCIDE_OC);
        }
    }

    private String resolverNombre(AfMaestroDesdeCompraRequest request, OrdenCompraLineaResponse linea) {
        if (request.getNombre() != null && !request.getNombre().isBlank()) {
            return request.getNombre().trim();
        }
        if (linea.getArticuloDescripcion() != null && !linea.getArticuloDescripcion().isBlank()) {
            return linea.getArticuloDescripcion().trim();
        }
        return request.getCodigo();
    }

    private String resolverNombreRecepcion(AfMaestroDesdeRecepcionRequest request, OrdenCompraLineaResponse linea) {
        if (request.getNombre() != null && !request.getNombre().isBlank()) {
            return request.getNombre().trim();
        }
        if (linea.getArticuloDescripcion() != null && !linea.getArticuloDescripcion().isBlank()) {
            return linea.getArticuloDescripcion().trim();
        }
        return request.getCodigo();
    }
}
