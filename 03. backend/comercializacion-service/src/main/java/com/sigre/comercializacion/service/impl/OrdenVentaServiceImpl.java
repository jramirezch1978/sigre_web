package com.sigre.comercializacion.service.impl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import feign.FeignException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.client.AlmacenClient;
import com.sigre.comercializacion.client.dto.IntegracionSalidaOvRequest;
import com.sigre.comercializacion.client.dto.MovimientoDetalleResponse;
import com.sigre.comercializacion.dto.request.DespachoOvRequest;
import com.sigre.common.service.NumeradorDocumentoService;
import com.sigre.comercializacion.dto.request.OrdenVentaDetLineRequest;
import com.sigre.comercializacion.dto.request.OrdenVentaRequest;
import com.sigre.comercializacion.dto.response.DespachoOvResponse;
import com.sigre.comercializacion.entity.OrdenVenta;
import com.sigre.comercializacion.entity.OrdenVentaDet;
import com.sigre.comercializacion.repository.OrdenVentaRepository;
import com.sigre.comercializacion.service.OrdenVentaService;
import com.sigre.comercializacion.service.VentasErrorCodes;
import com.sigre.comercializacion.service.VentasNumeradorTablas;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class OrdenVentaServiceImpl implements OrdenVentaService {

    private static final String FLAG_ACTIVO = "1";

    /** Numeración correlativa vía {@link NumeradorDocumentoService} (common) → {@code core.fn_get_document_number}. */
    private final NumeradorDocumentoService numeradorDocumentoService;
    private final OrdenVentaRepository repository;
    private final AlmacenClient almacenClient;

    private static void requireCabeceraActiva(OrdenVenta ov) {
        if (!FLAG_ACTIVO.equals(ov.getFlagEstado())) {
            throw new BusinessException("Operación no permitida sobre un documento inactivo", VentasErrorCodes.OV_STATE);
        }
    }

    @Override
    public Page<OrdenVenta> findAll(Long sucursalId, Long clienteId, String nro, Pageable pageable) {
        return repository.findWithFilters(sucursalId, clienteId, nro, pageable);
    }

    @Override
    public OrdenVenta findById(Long id) {
        return repository.findByIdWithDetalles(id)
                .orElseThrow(() -> new ResourceNotFoundException("OrdenVenta", id));
    }

    @Override
    @Transactional
    public OrdenVenta create(OrdenVentaRequest request) {
        String nro = request.getNroOrdenVenta();
        if (nro == null || nro.isBlank()) {
            // Numerador corporativo: tabla + sucursal + año → CHAR(12). Ver NumeradorDocumentoService en common.
            nro = numeradorDocumentoService.siguienteNroDocumento(
                    VentasNumeradorTablas.ORDEN_VENTA,
                    request.getSucursalId(),
                    request.getFechaEmision().getYear());
        } else if (repository.existsByNroOrdenVenta(nro)) {
            throw new BusinessException("Número de orden ya existe", VentasErrorCodes.OV_NUMERO_DUPLICADO);
        }

        OrdenVenta ov = new OrdenVenta();
        ov.setSucursalId(request.getSucursalId());
        ov.setNroOrdenVenta(nro);
        ov.setClienteId(request.getClienteId());
        ov.setVendedorId(request.getVendedorId());
        ov.setFechaEmision(request.getFechaEmision());
        ov.setFechaRegistro(Instant.now());
        ov.setMonedaId(request.getMonedaId());
        ov.setDocTipoId(request.getDocTipoId());
        ov.setFormaPagoId(request.getFormaPagoId());
        ov.setObservaciones(request.getObservaciones());
        ov.setMontoFacturado(BigDecimal.ZERO);
        ov.setCreatedBy(TenantContext.getUsuarioId());
        aplicarDetalles(ov, request.getDetalles());
        return repository.save(ov);
    }

    @Override
    @Transactional
    public OrdenVenta update(Long id, OrdenVentaRequest request) {
        OrdenVenta ov = findById(id);
        requireCabeceraActiva(ov);
        ov.setClienteId(request.getClienteId());
        ov.setVendedorId(request.getVendedorId());
        ov.setFechaEmision(request.getFechaEmision());
        ov.setMonedaId(request.getMonedaId());
        ov.setDocTipoId(request.getDocTipoId());
        ov.setFormaPagoId(request.getFormaPagoId());
        ov.setObservaciones(request.getObservaciones());
        ov.setUpdatedBy(TenantContext.getUsuarioId());
        aplicarDetalles(ov, request.getDetalles());
        return repository.save(ov);
    }

    @Override
    @Transactional
    public OrdenVenta confirmar(Long id) {
        OrdenVenta ov = findById(id);
        requireCabeceraActiva(ov);
        ov.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(ov);
    }

    @Override
    @Transactional
    public OrdenVenta anular(Long id) {
        OrdenVenta ov = findById(id);
        requireCabeceraActiva(ov);
        ov.setFlagEstado("0");
        ov.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(ov);
    }

    @Override
    @Transactional
    public OrdenVenta cerrar(Long id) {
        OrdenVenta ov = findById(id);
        requireCabeceraActiva(ov);
        ov.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(ov);
    }

    private String generarNroUnico(Long sucursalId) {
        for (int i = 0; i < 10; i++) {
            String nro = "OV-" + sucursalId + "-" + LocalDate.now().getYear() + "-"
                    + UUID.randomUUID().toString().replace("-", "").substring(0, 8).toUpperCase();
            if (!repository.existsByNroOrdenVenta(nro)) {
                return nro;
            }
        }
        throw new BusinessException("No se pudo generar número único de OV", VentasErrorCodes.OV_NUMERO_DUPLICADO);
    }

    @Override
    @Transactional
    public DespachoOvResponse despacharEnAlmacen(Long id, DespachoOvRequest request) {
        OrdenVenta ov = findById(id);

        if (!"1".equals(ov.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede despachar una OV activa (flagEstado=1)",
                    HttpStatus.CONFLICT, VentasErrorCodes.OV_DESPACHO_ESTADO_INVALIDO);
        }

        boolean tieneLineasConAlmacen = ov.getDetalles().stream()
                .anyMatch(d -> request.getAlmacenId().equals(d.getAlmacenId()));
        if (!tieneLineasConAlmacen) {
            throw new BusinessException(
                    "La OV no tiene líneas asignadas al almacén " + request.getAlmacenId(),
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.OV_DESPACHO_SIN_LINEAS);
        }

        IntegracionSalidaOvRequest integracionRequest = IntegracionSalidaOvRequest.builder()
                .ordenVentaId(id)
                .articuloMovTipoId(request.getArticuloMovTipoId())
                .almacenId(request.getAlmacenId())
                .fechaMov(request.getFechaMov())
                .observaciones(request.getObservaciones())
                .build();

        MovimientoDetalleResponse movimiento;
        try {
            movimiento = almacenClient.salidaOrdenVenta(integracionRequest).getData();
        } catch (FeignException.NotFound e) {
            throw new BusinessException(
                    extraerMensajeFeign(e, "OV o almacén no encontrado en almacen-service"),
                    HttpStatus.NOT_FOUND, VentasErrorCodes.OV_DESPACHO_ALMACEN_NOT_FOUND);
        } catch (FeignException.UnprocessableEntity e) {
            throw new BusinessException(
                    extraerMensajeFeign(e, "No fue posible generar la salida en almacén"),
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.OV_DESPACHO_VALIDACION);
        } catch (FeignException.BadRequest e) {
            throw new BusinessException(
                    extraerMensajeFeign(e, "Solicitud inválida al despachar en almacén"),
                    HttpStatus.BAD_REQUEST, VentasErrorCodes.OV_DESPACHO_REQUEST_INVALIDO);
        } catch (FeignException e) {
            throw new BusinessException(
                    extraerMensajeFeign(e, "Error de comunicación con almacen-service"),
                    HttpStatus.SERVICE_UNAVAILABLE, VentasErrorCodes.OV_DESPACHO_COMUNICACION);
        }

        ov.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(ov);

        return DespachoOvResponse.builder()
                .ordenVentaId(ov.getId())
                .nroOrdenVenta(ov.getNroOrdenVenta())
                .movimiento(movimiento)
                .build();
    }

    private String extraerMensajeFeign(FeignException e, String mensajeDefault) {
        try {
            String body = e.contentUTF8();
            if (body != null && !body.isBlank()) {
                JsonNode node = new ObjectMapper().readTree(body);
                if (node.has("message")) {
                    return node.get("message").asText();
                }
            }
        } catch (Exception ex) {
            log.warn("No se pudo extraer el mensaje de error de almacen-service", ex);
        }
        return mensajeDefault;
    }

    private void aplicarDetalles(OrdenVenta ov, java.util.List<OrdenVentaDetLineRequest> lines) {
        ov.getDetalles().clear();
        if (lines == null || lines.isEmpty()) {
            ov.setMontoTotal(BigDecimal.ZERO.setScale(4, RoundingMode.HALF_UP));
            return;
        }
        BigDecimal sum = BigDecimal.ZERO;
        int autoLine = 1;
        for (OrdenVentaDetLineRequest r : lines) {
            BigDecimal imp = r.getValorImpuesto() != null ? r.getValorImpuesto() : BigDecimal.ZERO;
            BigDecimal sub = r.getCantProyectada().multiply(r.getValorUnitario()).add(imp)
                    .setScale(4, RoundingMode.HALF_UP);
            OrdenVentaDet d = new OrdenVentaDet();
            d.setOrdenVenta(ov);
            d.setArticuloId(r.getArticuloId());
            d.setLineaNro(r.getLineaNro() != null ? r.getLineaNro() : autoLine++);
            d.setCantProyectada(r.getCantProyectada());
            d.setValorUnitario(r.getValorUnitario());
            d.setTiposImpuestoId(r.getTiposImpuestoId());
            d.setValorImpuesto(imp);
            d.setSubtotal(sub);
            d.setAlmacenId(r.getAlmacenId());
            d.setCantProcesada(BigDecimal.ZERO);
            d.setCantFacturada(BigDecimal.ZERO);
            d.setCreatedBy(TenantContext.getUsuarioId());
            ov.getDetalles().add(d);
            sum = sum.add(sub);
        }
        ov.setMontoTotal(sum.setScale(4, RoundingMode.HALF_UP));
    }
}
