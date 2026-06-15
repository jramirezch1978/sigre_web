package com.sigre.finanzas.service.impl;

import io.micrometer.core.annotation.Timed;
import feign.FeignException;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.common.service.NumeradorDocumentoService;
import com.sigre.finanzas.dto.request.RetencionRequest;
import com.sigre.finanzas.dto.response.RetencionResponse;
import com.sigre.finanzas.entity.CntasPagar;
import com.sigre.finanzas.entity.Retencion;
import com.sigre.finanzas.mapper.RetencionMapper;
import com.sigre.finanzas.repository.CajaBancosRepository;
import com.sigre.finanzas.repository.CntasPagarRepository;
import com.sigre.finanzas.repository.RetencionRepository;
import com.sigre.finanzas.service.RetencionService;
import com.sigre.finanzas.service.FinanzasErrorCodes;
import com.sigre.finanzas.client.CoreMaestrosClient;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RetencionServiceImpl implements RetencionService {

    private static final String FLAG_ESTADO_ACTIVO = "1";
    private static final String FLAG_ESTADO_INACTIVO = "0";
    private static final String DOC_TIPO_RETENCION_CODIGO = "CRI"; // Comprobante de Retención (core.doc_tipo.codigo) - para consultar series
    private static final Long DOC_TIPO_RETENCION_ID = 97L; // Comprobante de Retención (core.doc_tipo.id) - para generar número
    private static final String SERIE_RETENCION_DEFAULT = "R001"; // Serie debe existir en core.doc_tipo_num_serie

    private final RetencionRepository repository;
    private final CntasPagarRepository cntasPagarRepository;
    private final CajaBancosRepository cajaBancosRepository;
    private final RetencionMapper mapper;
    private final CoreMaestrosClient coreMaestrosClient;
    private final NumeradorDocumentoService numeradorDocumentoService;

    @Override
    public Page<RetencionResponse> listar(String nroCertificado, Long cntasPagarId,
                                          String flagEstado, Pageable pageable) {
        log.info("Listando retenciones - certificado: {}, cxp: {}, estado: {}",
                nroCertificado, cntasPagarId, flagEstado);

        Specification<Retencion> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (nroCertificado != null && !nroCertificado.isBlank()) {
                predicates.add(cb.like(cb.lower(root.get("nroCertificado")),
                        "%" + nroCertificado.toLowerCase() + "%"));
            }
            if (cntasPagarId != null) {
                predicates.add(cb.equal(root.get("cntasPagarId"), cntasPagarId));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            } else {
                predicates.add(cb.equal(root.get("flagEstado"), FLAG_ESTADO_ACTIVO));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<Retencion> page = repository.findAll(spec, pageable);
        return page.map(mapper::toResponse);
    }

    @Override
    public RetencionResponse obtenerPorId(Long id) {
        log.info("Obteniendo retención por ID: {}", id);

        Retencion retencion = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Retención", id));

        return mapper.toResponse(retencion);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "retencion", "operation", "create"})
    @Override
    @Transactional
    public RetencionResponse crear(RetencionRequest request) {
        log.info("Creando retención");

        validarCuentaPorPagar(request.getCntasPagarId());
        validarProveedor(request.getProveedorId());
        validarMovimientoCajaBancos(request.getNroRegCajaBan());
        validarImporte(request.getImporteDoc());

        Retencion retencion = mapper.toEntity(request);
        Long sucursalId = TenantContext.getSucursalId();
        
        // Generar número de certificado automáticamente si no viene del request
        if (retencion.getNroCertificado() == null || retencion.getNroCertificado().isEmpty()) {
            String serie = obtenerSerieRetencion(sucursalId);
            var resultado = numeradorDocumentoService.siguienteNroDocumentoSunat(
                DOC_TIPO_RETENCION_ID,
                serie,
                sucursalId
            );
            retencion.setNroCertificado(resultado.nroDocumento());
            log.info("Número de certificado generado: {} con serie: {}", resultado.nroDocumento(), serie);
        } else {
            validarUnicidad(retencion.getNroCertificado());
            log.info("Creando retención con certificado proporcionado: {}", retencion.getNroCertificado());
        }
        
        retencion.setFlagEstado(FLAG_ESTADO_ACTIVO);
        retencion.setSucursalId(sucursalId);
        Long monedaId = cntasPagarRepository.findById(request.getCntasPagarId())
                .map(CntasPagar::getMonedaId)
                .orElse(null);
        retencion.setTasaCambio(obtenerTipoCambio(request.getFechaEmision(), monedaId));
        retencion.setCreatedBy(TenantContext.getUsuarioId());

        Retencion saved = repository.save(retencion);
        log.info("Retención creada con ID: {}", saved.getId());

        return mapper.toResponse(saved);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "retencion", "operation", "update"})
    @Override
    @Transactional
    public RetencionResponse actualizar(Long id, RetencionRequest request) {
        log.info("Actualizando retención ID: {}", id);

        Retencion retencion = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Retención", id));

        validarEstadoEditable(retencion);
        validarCuentaPorPagar(request.getCntasPagarId());
        validarProveedor(request.getProveedorId());
        validarMovimientoCajaBancos(request.getNroRegCajaBan());
        validarImporte(request.getImporteDoc());

        if (!retencion.getNroCertificado().equals(request.getNroCertificado())) {
            validarUnicidad(request.getNroCertificado());
        }

        retencion.setCntasPagarId(request.getCntasPagarId());
        retencion.setNroCertificado(request.getNroCertificado());
        retencion.setFechaEmision(request.getFechaEmision());
        retencion.setProveedorId(request.getProveedorId());
        retencion.setImporteDoc(request.getImporteDoc());
        retencion.setSaldoSol(request.getSaldoSol());
        retencion.setSaldoDol(request.getSaldoDol());
        retencion.setNroRegCajaBan(request.getNroRegCajaBan());
        retencion.setFecPago(request.getFecPago());
        Long monedaId = cntasPagarRepository.findById(request.getCntasPagarId())
                .map(CntasPagar::getMonedaId)
                .orElse(null);
        retencion.setTasaCambio(obtenerTipoCambio(request.getFechaEmision(), monedaId));
        retencion.setUpdatedBy(TenantContext.getUsuarioId());

        Retencion updated = repository.save(retencion);
        log.info("Retención actualizada: {}", id);

        return mapper.toResponse(updated);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "retencion", "operation", "activar"})
    @Override
    @Transactional
    public RetencionResponse activar(Long id) {
        log.info("Activando retención ID: {}", id);

        Retencion retencion = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Retención", id));

        if (FLAG_ESTADO_ACTIVO.equals(retencion.getFlagEstado())) {
            throw new BusinessException(
                    "La retención ya está activa",
                    FinanzasErrorCodes.RETENCION_ESTADO_INVALIDO);
        }

        retencion.setFlagEstado(FLAG_ESTADO_ACTIVO);
        retencion.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(retencion);

        log.info("Retención activada: {}", id);
        return mapper.toResponse(retencion);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "retencion", "operation", "desactivar"})
    @Override
    @Transactional
    public RetencionResponse desactivar(Long id) {
        log.info("Desactivando retención ID: {}", id);

        Retencion retencion = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Retención", id));

        if (FLAG_ESTADO_INACTIVO.equals(retencion.getFlagEstado())) {
            throw new BusinessException(
                    "La retención ya está inactiva",
                    FinanzasErrorCodes.RETENCION_ESTADO_INVALIDO);
        }

        retencion.setFlagEstado(FLAG_ESTADO_INACTIVO);
        retencion.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(retencion);

        log.info("Retención desactivada: {}", id);
        return mapper.toResponse(retencion);
    }

    private void validarUnicidad(String nroCertificado) {
        if (repository.existsByNroCertificadoAndFlagEstado(nroCertificado, FLAG_ESTADO_ACTIVO)) {
            throw new BusinessException(
                    "Ya existe una retención activa con el certificado " + nroCertificado,
                    FinanzasErrorCodes.RETENCION_DUPLICADA);
        }
    }

    private void validarCuentaPorPagar(Long cntasPagarId) {
        if (cntasPagarId != null && !cntasPagarRepository.existsById(cntasPagarId)) {
            throw new BusinessException(
                    "La cuenta por pagar con ID " + cntasPagarId + " no existe. Verifique que la cuenta esté registrada.",
                    FinanzasErrorCodes.RETENCION_IMPORTE_INVALIDO);
        }
    }

    private void validarImporte(BigDecimal importe) {
        if (importe == null || importe.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException(
                    "El importe debe ser mayor a cero",
                    FinanzasErrorCodes.RETENCION_IMPORTE_INVALIDO);
        }
    }

    private void validarEstadoEditable(Retencion retencion) {
        if (!FLAG_ESTADO_ACTIVO.equals(retencion.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede actualizar una retención inactiva",
                    FinanzasErrorCodes.RETENCION_NO_EDITABLE);
        }
    }

    private void validarProveedor(Long proveedorId) {
        try {
            var apiResponse = coreMaestrosClient.obtenerEntidadPorId(proveedorId);
            if (apiResponse == null || apiResponse.getData() == null) {
                throw new ResourceNotFoundException("EntidadContribuyente", proveedorId);
            }
        } catch (FeignException.NotFound e) {
            throw new ResourceNotFoundException("EntidadContribuyente", proveedorId);
        } catch (Exception e) {
            log.error("Error al validar proveedor {}: {}", proveedorId, e.getMessage());
            throw new BusinessException(
                    "Error al validar proveedor",
                    FinanzasErrorCodes.ERROR_COMUNICACION_CORE_MAESTROS
            );
        }
    }

    private void validarMovimientoCajaBancos(Long nroRegCajaBan) {
        if (nroRegCajaBan == null) {
            throw new BusinessException(
                    "El movimiento de caja/bancos es obligatorio",
                    FinanzasErrorCodes.RETENCION_IMPORTE_INVALIDO);
        }
        if (!cajaBancosRepository.existsById(nroRegCajaBan)) {
            throw new BusinessException(
                    "El movimiento de caja/bancos con ID " + nroRegCajaBan + " no existe",
                    FinanzasErrorCodes.RETENCION_IMPORTE_INVALIDO);
        }
    }

    private BigDecimal obtenerTipoCambio(LocalDate fecha, Long monedaId) {
        if (fecha == null) {
            fecha = LocalDate.now();
        }
        if (monedaId == null) {
            return BigDecimal.ONE;
        }
        try {
            var monedaResponse = coreMaestrosClient.obtenerMonedaPorId(monedaId);
            if (monedaResponse != null && monedaResponse.isSuccess() && monedaResponse.getData() != null) {
                String codigo = monedaResponse.getData().getCodigo();
                if ("PEN".equals(codigo) || "SOL".equals(codigo)) {
                    return BigDecimal.ONE;
                }
            }
        } catch (Exception e) {
            log.warn("No se pudo obtener monedaId {}, consultando tipo de cambio directamente", monedaId, e);
        }
        log.debug("Obteniendo tipo de cambio para fecha: {}, monedaId: {}", fecha, monedaId);
        try {
            var response = coreMaestrosClient.obtenerUltimoTipoCambioPorFecha(fecha, monedaId);
            if (response != null && response.isSuccess() && response.getData() != null && response.getData().getCompra() != null) {
                return response.getData().getCompra();
            }
        } catch (Exception e) {
            log.error("Error al obtener tipo de cambio para fecha {} y monedaId {}", fecha, monedaId, e);
        }
        throw new BusinessException("No se encontró una tasa de cambio activa para la moneda y fecha especificada",
            FinanzasErrorCodes.TIPO_CAMBIO_NO_ENCONTRADO);
    }

    /**
     * Obtiene la serie de retención para generar el número de certificado.
     * Intenta recuperar la serie desde ms-core-maestros consultando la tabla core.doc_tipo_num_serie.
     * Si el endpoint no existe o hay error de comunicación, usa la serie por defecto.
     * 
     * @param sucursalId ID de la sucursal del contexto del usuario
     * @return Serie activa de retención (ej. "R001") o serie por defecto si no se encuentra
     */
    private String obtenerSerieRetencion(Long sucursalId) {
        try {
            log.debug("Intentando obtener serie de retención desde ms-core-maestros para sucursal: {}", sucursalId);
            var response = coreMaestrosClient.listarSeriesPorCodigoDocYSucursal(DOC_TIPO_RETENCION_CODIGO, sucursalId);
            
            if (response != null && response.getData() != null && !response.getData().isEmpty()) {
                var serie = response.getData().stream()
                        .filter(s -> FLAG_ESTADO_ACTIVO.equals(s.getFlagEstado()))
                        .findFirst()
                        .map(s -> s.getSerie())
                        .orElse(SERIE_RETENCION_DEFAULT);
                log.info("Serie obtenida desde ms-core-maestros: {}", serie);
                return serie;
            }
        } catch (FeignException.NotFound e) {
            log.warn("Endpoint de series no encontrado en ms-core-maestros (404). Usando serie por defecto: {}", SERIE_RETENCION_DEFAULT);
        } catch (Exception e) {
            log.warn("Error al obtener serie desde ms-core-maestros: {}. Usando serie por defecto: {}", 
                    e.getMessage(), SERIE_RETENCION_DEFAULT);
        }
        
        log.info("Usando serie por defecto: {}", SERIE_RETENCION_DEFAULT);
        return SERIE_RETENCION_DEFAULT;
    }
}
