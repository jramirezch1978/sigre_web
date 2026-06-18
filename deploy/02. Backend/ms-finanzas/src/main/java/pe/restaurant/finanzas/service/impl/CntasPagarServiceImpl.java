package pe.restaurant.finanzas.service.impl;

import io.micrometer.core.annotation.Timed;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.client.ContabilidadClient;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.dto.request.CntasPagarDetRequest;
import pe.restaurant.finanzas.dto.request.CntasPagarRequest;
import pe.restaurant.finanzas.dto.request.CntasPagarAsientoRequest;
import pe.restaurant.finanzas.dto.request.CntasPagarDetAsientoRequest;
import pe.restaurant.finanzas.dto.request.DetImpuestoRequest;
import pe.restaurant.finanzas.dto.response.DetImpuestoResponse;
import pe.restaurant.finanzas.dto.response.GenerarAsientoResponse;
import pe.restaurant.finanzas.dto.response.PendientesPagarResponse;
import pe.restaurant.finanzas.dto.response.PendientesPagarSimpleResponse;
import pe.restaurant.finanzas.entity.*;
import pe.restaurant.finanzas.domain.CntasPagarFlagEstado;
import pe.restaurant.finanzas.mapper.CntasPagarDetMapper;
import pe.restaurant.finanzas.mapper.CntasPagarMapper;
import pe.restaurant.finanzas.repository.*;
import pe.restaurant.finanzas.service.CntasPagarDetImpService;
import pe.restaurant.finanzas.service.CntasPagarService;
import pe.restaurant.finanzas.service.FinanzasErrorCodes;
import pe.restaurant.finanzas.service.support.CntasPagarCabeceraValidator;

import java.util.ArrayList;
import java.util.stream.Collectors;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CntasPagarServiceImpl implements CntasPagarService {

    private final CntasPagarRepository repository;
    private final CntasPagarDetRepository detalleRepository;
    private final CntasPagarMapper mapper;
    private final CntasPagarDetMapper detalleMapper;
    private final CoreMaestrosClient coreMaestrosClient;
    private final ContabilidadClient contabilidadClient;
    
    // Repositorios adicionales para pendientes por pagar
    private final LiquidacionRepository liquidacionRepository;
    private final SolicitudGiroRepository solicitudGiroRepository;
    private final RetencionRepository retencionRepository;
    private final DetraccionRepository detraccionRepository;
    private final CntasPagarCabeceraValidator cabeceraValidator;
    private final CntasPagarDetImpService detImpService;

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public Page<CntasPagar> listar(Long proveedorId, Long docTipoId, String estado,
                                   LocalDate fechaDesde, LocalDate fechaHasta, 
                                   LocalDate fechaVencimientoDesde, LocalDate fechaVencimientoHasta,
                                   Pageable pageable) {
        log.info("Listando cuentas por pagar con filtros - proveedorId: {}, docTipoId: {}, estado: {}, " +
                "fechaDesde: {}, fechaHasta: {}, fechaVencimientoDesde: {}, fechaVencimientoHasta: {}",
                proveedorId, docTipoId, estado, fechaDesde, fechaHasta, fechaVencimientoDesde, fechaVencimientoHasta);
        
        // Construir especificación dinámica para filtros combinados
        Specification<CntasPagar> spec = (root, query, cb) -> cb.conjunction();
        
        if (proveedorId != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("proveedorId"), proveedorId));
        }
        
        if (docTipoId != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("docTipoId"), docTipoId));
        }
        
        if (estado != null && !estado.trim().isEmpty()) {
            String flagEstadoFiltro = CntasPagarFlagEstado.fromFiltro(estado);
            if (flagEstadoFiltro != null) {
                spec = spec.and((root, query, cb) -> cb.equal(root.get("flagEstado"), flagEstadoFiltro));
            }
        }
        
        if (fechaDesde != null && fechaHasta != null) {
            spec = spec.and((root, query, cb) -> cb.between(root.get("fechaEmision"), fechaDesde, fechaHasta));
        } else if (fechaDesde != null) {
            spec = spec.and((root, query, cb) -> cb.greaterThanOrEqualTo(root.get("fechaEmision"), fechaDesde));
        } else if (fechaHasta != null) {
            spec = spec.and((root, query, cb) -> cb.lessThanOrEqualTo(root.get("fechaEmision"), fechaHasta));
        }
        
        if (fechaVencimientoDesde != null && fechaVencimientoHasta != null) {
            spec = spec.and((root, query, cb) -> cb.between(root.get("fechaVencimiento"), fechaVencimientoDesde, fechaVencimientoHasta));
        } else if (fechaVencimientoDesde != null) {
            spec = spec.and((root, query, cb) -> cb.greaterThanOrEqualTo(root.get("fechaVencimiento"), fechaVencimientoDesde));
        } else if (fechaVencimientoHasta != null) {
            spec = spec.and((root, query, cb) -> cb.lessThanOrEqualTo(root.get("fechaVencimiento"), fechaVencimientoHasta));
        }
        
        return repository.findAll(spec, pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "cntas_pagar", "operation", "findById"})
    @Override
    public CntasPagar obtenerPorId(Long id) {
        log.info("Buscando cuenta por pagar con id: {}", id);
        return repository.findByIdWithDetalles(id)
            .orElseThrow(() -> {
                log.warn("Cuenta por pagar no encontrada con id: {}", id);
                return new ResourceNotFoundException("Cuenta por pagar", id);
            });
    }

    /**
     * Crea una cuenta por pagar con su asiento contable asociado.
     * Implementa Saga Pattern: primero crea la CxP local, luego el asiento contable.
     * Si falla la creación del asiento, compensa anulando la CxP creada.
     * 
     * @param request Datos de la cuenta por pagar y su asiento contable
     * @return Cuenta por pagar creada con sus detalles
     * @throws BusinessException Si falla alguna validación o la creación del asiento
     */
    @Timed(value = "app.db.query", extraTags = {"table", "cntas_pagar", "operation", "create"})
    @Override
    @Transactional
    public CntasPagar crear(CntasPagarRequest request) {
        log.info("Creando cuenta por pagar - proveedor: {}, total: {}", 
            request.getProveedorId(), request.getTotal());
        
        validarDocumentoDuplicado(request.getProveedorId(), request.getDocTipoId(), request.getSerie(), request.getNumero());
        validarMoneda(request.getMonedaId());
        validarProveedor(request.getProveedorId());
        validarDocTipo(request.getDocTipoId());
        validarFechas(request.getFechaEmision(), request.getFechaVencimiento());
        validarTotal(request.getTotal());
        cabeceraValidator.validar(request.getAno(), request.getMes(), request.getCntblLibroId());
        validarDetalles(request.getDetalles());
        
        CntasPagar cxp = crearCxPLocal(request);
        GenerarAsientoResponse asiento = null;
        
        try {
            CntasPagarAsientoRequest asientoReq = prepararCntasPagarAsientoRequest(cxp);
            asiento = generarAsientoContable(asientoReq);
            
            cxp.setCntblAsientoId(asiento.getAsientoId());
            cxp.setUpdatedBy(TenantContext.getUsuarioId());
            repository.save(cxp);
            
            log.info("Cuenta por pagar creada exitosamente con id: {}", cxp.getId());
            return repository.findByIdWithDetalles(cxp.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Cuenta por pagar", cxp.getId()));
                
        } catch (Exception ex) {
            compensarCreacionCxP(cxp, asiento != null ? asiento.getAsientoId() : null, ex);
            throw ex;
        }
    }
    
    /**
     * Crea la cuenta por pagar y sus detalles en la base de datos local.
     * El campo cntblAsientoId se deja en null hasta que se cree el asiento.
     * 
     * @param request Datos de la cuenta por pagar
     * @return Cuenta por pagar guardada con sus detalles
     */
    private CntasPagar crearCxPLocal(CntasPagarRequest request) {
        log.info("Creando CxP local sin asiento contable");
        
        CntasPagar cxp = mapper.toEntity(request);
        cxp.setSucursalId(TenantContext.getSucursalId());
        cxp.setFechaRegistro(LocalDate.now());
        cxp.setTasaCambio(obtenerTasaCambio(request.getFechaEmision(), request.getMonedaId()));
        cxp.setSaldo(request.getTotal());
        cxp.setCntblAsientoId(null);
        cxp.setCreatedBy(TenantContext.getUsuarioId());
        if (cxp.getFlagDetraccion() == null) {
            cxp.setFlagDetraccion("0");
        }
        if (cxp.getImporteDetraccion() == null) {
            cxp.setImporteDetraccion(BigDecimal.ZERO);
        }
        if (cxp.getFlagRetencion() == null) {
            cxp.setFlagRetencion("0");
        }
        
        CntasPagar savedCxp = repository.save(cxp);
        log.info("Cuenta por pagar creada localmente con id: {}", savedCxp.getId());
        
        for (CntasPagarDetRequest detRequest : request.getDetalles()) {
            CntasPagarDet detalle = detalleMapper.toEntity(detRequest);
            detalle.setCntasPagar(savedCxp);
            detalle.setCreatedBy(TenantContext.getUsuarioId());
            if (detalle.getCreditoFiscalId() == null) {
                detalle.setCreditoFiscalId(obtenerCreditoFiscalDefault());
            }
            CntasPagarDet savedDetalle = detalleRepository.save(detalle);
            detImpService.guardarImpuestos(savedDetalle, detRequest.getImpuestos());
            savedCxp.getDetalles().add(savedDetalle);
        }
        
        log.info("CxP creada con {} detalles", savedCxp.getDetalles().size());
        return savedCxp;
    }
    
    private Long obtenerCreditoFiscalDefault() {
        try {
            Number result = (Number) entityManager.createNativeQuery(
                    "SELECT id FROM core.credito_fiscal WHERE codigo = '01'")
                    .setMaxResults(1)
                    .getSingleResult();
            return result.longValue();
        } catch (Exception e) {
            log.warn("No se pudo obtener credito_fiscal default, usando 1: {}", e.getMessage());
            return 1L;
        }
    }

    /**
     * Prepara el request para generar el asiento contable automáticamente.
     * Convierte los datos de la CxP y sus detalles al formato esperado por ms-contabilidad.
     * 
     * @param cxp Cuenta por pagar ya creada con sus detalles
     * @return Request para generar el asiento contable
     */
    private CntasPagarAsientoRequest prepararCntasPagarAsientoRequest(CntasPagar cxp) {
        List<CntasPagarDetAsientoRequest> detalles = cxp.getDetalles().stream()
            .map(det -> CntasPagarDetAsientoRequest.builder()
                    .id(det.getId())
                    .item(det.getItem())
                    .conceptoFinancieroId(det.getConceptoFinancieroId())
                    .descripcion(det.getDescripcion())
                    .articuloId(det.getArticuloId())
                    .cantidad(det.getCantidad())
                    .precioUnitario(det.getPrecioUnitario())
                    .monto(det.getMonto())
                    .centrosCostoId(det.getCentrosCostoId())
                    .impuestos(toImpuestoRequests(detImpService.listarPorDetalle(det.getId())))
                    .fechaMov(det.getFechaMov())
                    .tipoMov(det.getTipoMov())
                    .referencia(det.getReferencia())
                    .build())
            .toList();

        return CntasPagarAsientoRequest.builder()
                .id(cxp.getId())
                .sucursalId(cxp.getSucursalId())
                .proveedorId(cxp.getProveedorId())
                .docTipoId(cxp.getDocTipoId())
                .serie(cxp.getSerie())
                .numero(cxp.getNumero())
                .fechaEmision(cxp.getFechaEmision())
                .monedaId(cxp.getMonedaId())
                .total(cxp.getTotal())
                .saldo(cxp.getSaldo())
                .tasaCambio(cxp.getTasaCambio())
                .ano(cxp.getAno())
                .mes(cxp.getMes())
                .cntblLibroId(cxp.getCntblLibroId())
                .glosa(String.format("Provisión CxP - %s-%s", cxp.getSerie(), cxp.getNumero()))
                .detalles(detalles)
                .build();
    }
    
    /**
     * Genera el asiento contable automáticamente en ms-contabilidad.
     * Maneja los diferentes tipos de errores de Feign y los convierte en BusinessException.
     * 
     * @param asientoReq Request para generar el asiento contable
     * @return Respuesta con el asiento contable generado
     * @throws BusinessException Si el asiento no está balanceado, hay recursos no encontrados,
     *                          solicitud inválida o error de comunicación
     */
    private GenerarAsientoResponse generarAsientoContable(CntasPagarAsientoRequest asientoReq) {
        try {
            log.info("Generando asiento contable automático para CxP");
            GenerarAsientoResponse asiento = contabilidadClient.generarAsientoRegistroCntasPagar(asientoReq).getData();
            log.info("Asiento contable generado con id: {}", asiento.getAsientoId());
            return asiento;
        } catch (feign.FeignException.UnprocessableEntity e) {
            String mensaje = extraerMensajeDeError(e);
            log.error("Error de validación en ms-contabilidad: {}", mensaje, e);
            throw new BusinessException(
                mensaje != null ? mensaje : "Error de validación al crear asiento contable",
                HttpStatus.UNPROCESSABLE_ENTITY,
                FinanzasErrorCodes.CONTABILIDAD_INVALIDA
            );
        } catch (feign.FeignException.NotFound e) {
            String mensaje = extraerMensajeDeError(e);
            log.error("Recurso no encontrado en ms-contabilidad: {}", mensaje, e);
            throw new BusinessException(
                mensaje,
                HttpStatus.NOT_FOUND,
                FinanzasErrorCodes.ERROR_COMUNICACION_CONTABILIDAD
            );
        } catch (feign.FeignException.BadRequest e) {
            String mensaje = extraerMensajeDeError(e);
            log.error("Solicitud inválida a ms-contabilidad: {}", mensaje, e);
            throw new BusinessException(
                mensaje,
                HttpStatus.BAD_REQUEST,
                FinanzasErrorCodes.ERROR_COMUNICACION_CONTABILIDAD
            );
        } catch (feign.FeignException e) {
            String mensaje = extraerMensajeDeError(e);
            log.error("Error al comunicarse con ms-contabilidad: {}", mensaje, e);
            throw new BusinessException(
                mensaje != null ? mensaje : "Error al crear el asiento contable",
                HttpStatus.SERVICE_UNAVAILABLE,
                FinanzasErrorCodes.ERROR_COMUNICACION_CONTABILIDAD
            );
        }
    }
    
    /**
     * Compensa la creación de una cuenta por pagar cuando falla el proceso.
     * Implementa el patrón de compensación de Saga:
     * 1. Anula el asiento contable si fue creado
     * 2. Anula la cuenta por pagar local
     * 3. Lanza la excepción apropiada según el tipo de error
     * 
     * @param cxp Cuenta por pagar a compensar
     * @param asientoId ID del asiento contable a anular (puede ser null si no se creó)
     * @param errorOriginal Excepción que causó la necesidad de compensación
     * @throws BusinessException Con el mensaje de error apropiado según el tipo de fallo
     */
    private void compensarCreacionCxP(CntasPagar cxp, Long asientoId, Exception errorOriginal) {
        log.error("Iniciando compensación para CxP {} debido a error: {}", cxp.getId(), errorOriginal.getMessage());
        
        if (asientoId != null) {
            try {
                contabilidadClient.anularAsiento(asientoId);
                log.info("Asiento {} anulado exitosamente", asientoId);
            } catch (Exception compensationEx) {
                log.error("Error crítico al anular asiento {}", asientoId, compensationEx);
            }
        }
        
        try {
            cxp.setFlagEstado(CntasPagarFlagEstado.ANULADO);
            cxp.setUpdatedBy(TenantContext.getUsuarioId());
            repository.save(cxp);
            log.info("CxP {} anulada exitosamente en compensación", cxp.getId());
        } catch (Exception compensationEx) {
            log.error("Error crítico al anular CxP {} en compensación", cxp.getId(), compensationEx);
        }
        
        if (errorOriginal instanceof DataIntegrityViolationException) {
            DataIntegrityViolationException ex = (DataIntegrityViolationException) errorOriginal;
            String errorMsg = ex.getMessage() != null ? ex.getMessage().toLowerCase() : "";
            
            if (errorMsg.contains("foreign key") || errorMsg.contains("fk_")) {
                if (errorMsg.contains("proveedor")) {
                    throw new BusinessException(
                        "El proveedor especificado no existe",
                        HttpStatus.NOT_FOUND,
                        FinanzasErrorCodes.PROVEEDOR_NO_ENCONTRADO
                    );
                } else if (errorMsg.contains("doc_tipo")) {
                    throw new BusinessException(
                        "El tipo de documento especificado no existe",
                        HttpStatus.NOT_FOUND,
                        FinanzasErrorCodes.DOC_TIPO_NO_ENCONTRADO
                    );
                } else if (errorMsg.contains("moneda")) {
                    throw new BusinessException(
                        "La moneda especificada no existe",
                        HttpStatus.NOT_FOUND,
                        FinanzasErrorCodes.MONEDA_NO_ENCONTRADA
                    );
                } else if (errorMsg.contains("articulo")) {
                    throw new BusinessException(
                        "El artículo especificado no existe",
                        HttpStatus.NOT_FOUND,
                        FinanzasErrorCodes.ARTICULO_NO_ENCONTRADO
                    );
                }
            }
            
            if (errorMsg.contains("unique") || errorMsg.contains("duplicate") || 
                errorMsg.contains("cntas_pagar_proveedor_id_doc_tipo_id_serie_numero")) {
                throw new BusinessException(
                    "Ya existe un documento con el mismo proveedor, tipo, serie y número",
                    HttpStatus.CONFLICT,
                    FinanzasErrorCodes.DOCUMENTO_DUPLICADO
                );
            }
            
            // Registrar el error completo para debugging
            log.error("Error de integridad de datos no manejado: {}", ex.getMessage());
            
            // Para errores de FK no identificados, retornar el mensaje original
            if (errorMsg.contains("foreign key") || errorMsg.contains("fk_")) {
                throw new BusinessException(
                    "Error de referencia: " + ex.getMessage(),
                    HttpStatus.NOT_FOUND,
                    FinanzasErrorCodes.ERROR_INTERNO
                );
            }
            
            throw new BusinessException(
                "Error al crear la cuenta por pagar: " + ex.getMessage(),
                HttpStatus.INTERNAL_SERVER_ERROR,
                FinanzasErrorCodes.ERROR_INTERNO
            );
        }
    }

    @Timed(value = "app.db.query", extraTags = {"table", "cntas_pagar", "operation", "update"})
    @Override
    @Transactional
    public CntasPagar actualizar(Long id, CntasPagarRequest request) {
        log.info("Actualizando cuenta por pagar con id: {}", id);
        
        CntasPagar cxp = obtenerPorId(id);
        
        if (!CntasPagarFlagEstado.ACTIVO.equals(cxp.getFlagEstado())) {
            throw new BusinessException(
                "Solo se pueden actualizar cuentas por pagar en estado ACTIVO",
                HttpStatus.UNPROCESSABLE_ENTITY,
                FinanzasErrorCodes.ESTADO_INVALIDO
            );
        }
        
        validarDocumentoDuplicado(request.getProveedorId(), request.getDocTipoId(), request.getSerie(), request.getNumero(), id);
        validarMoneda(request.getMonedaId());
        validarProveedor(request.getProveedorId());
        validarDocTipo(request.getDocTipoId());
        validarFechas(request.getFechaEmision(), request.getFechaVencimiento());
        validarTotal(request.getTotal());
        cabeceraValidator.validar(request.getAno(), request.getMes(), request.getCntblLibroId());
        validarDetalles(request.getDetalles());
        
        cxp.setProveedorId(request.getProveedorId());
        cxp.setDocTipoId(request.getDocTipoId());
        cxp.setSerie(request.getSerie());
        cxp.setNumero(request.getNumero());
        cxp.setFechaEmision(request.getFechaEmision());
        cxp.setFechaVencimiento(request.getFechaVencimiento());
        cxp.setMonedaId(request.getMonedaId());
        cxp.setTotal(request.getTotal());
        cxp.setSaldo(request.getTotal());
        cxp.setAno(request.getAno());
        cxp.setMes(request.getMes());
        cxp.setCntblLibroId(request.getCntblLibroId());
        cxp.setUpdatedBy(TenantContext.getUsuarioId());
        
        // Eliminar impuestos asociados antes de eliminar los detalles
        detImpService.eliminarPorCntasPagarId(id);

        // Limpiar la colección de detalles para evitar conflicto de entidades eliminadas
        cxp.getDetalles().clear();

        // Eliminar detalles existentes
        detalleRepository.deleteByCntasPagarId(id);

        // Crear nuevos detalles
        for (CntasPagarDetRequest detRequest : request.getDetalles()) {
            CntasPagarDet detalle = detalleMapper.toEntity(detRequest);
            detalle.setCntasPagar(cxp);
            detalle.setCreatedBy(TenantContext.getUsuarioId());
            CntasPagarDet savedDetalle = detalleRepository.save(detalle);
            detImpService.guardarImpuestos(savedDetalle, detRequest.getImpuestos());
        }
        
        // Guardar la CxP actualizada
        repository.save(cxp);
        
        log.warn("NOTA: La actualización de CxP no regenera el asiento contable. " +
                "Si necesita ajustar el asiento, debe hacerlo directamente en ms-contabilidad.");
        
        log.info("Cuenta por pagar actualizada exitosamente con id: {}", id);
        return obtenerPorId(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "cntas_pagar", "operation", "anular"})
    @Override
    @Transactional
    public CntasPagar anular(Long id) {
        log.info("Anulando cuenta por pagar con id: {}", id);
        
        CntasPagar cxp = obtenerPorId(id);
        
        if (cxp.getSaldo().compareTo(cxp.getTotal()) != 0) {
            throw new BusinessException(
                "No se puede anular una cuenta por pagar con pagos aplicados",
                HttpStatus.UNPROCESSABLE_ENTITY,
                FinanzasErrorCodes.SALDO_INVALIDO
            );
        }
        
        if (cxp.getCntblAsientoId() != null) {
            try {
                contabilidadClient.anularAsiento(cxp.getCntblAsientoId());
                log.info("Asiento contable {} anulado exitosamente", cxp.getCntblAsientoId());
            } catch (Exception e) {
                log.error("Error al anular asiento contable {}: {}", cxp.getCntblAsientoId(), e.getMessage());
                throw new BusinessException(
                    "Error al anular el asiento contable asociado",
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    FinanzasErrorCodes.ERROR_INTERNO
                );
            }
        }
        
        cxp.setFlagEstado(CntasPagarFlagEstado.ANULADO);
        cxp.setUpdatedBy(TenantContext.getUsuarioId());
        
        repository.save(cxp);
        log.info("Cuenta por pagar anulada exitosamente con id: {}", id);
        
        return repository.findByIdWithDetalles(id)
            .orElseThrow(() -> new ResourceNotFoundException("Cuenta por pagar", id));
    }
    
    /**
     * Valida que no exista un documento duplicado con la misma combinación de
     * proveedor, tipo de documento, serie y número.
     * 
     * @param proveedorId ID del proveedor
     * @param docTipoId ID del tipo de documento
     * @param serie Serie del documento
     * @param numero Número del documento
     * @throws BusinessException Si ya existe un documento con la misma unique key
     */
    private void validarDocumentoDuplicado(Long proveedorId, Long docTipoId, String serie, String numero) {
        validarDocumentoDuplicado(proveedorId, docTipoId, serie, numero, null);
    }

    private void validarDocumentoDuplicado(Long proveedorId, Long docTipoId, String serie, String numero, Long excludeId) {
        repository.findByProveedorIdAndDocTipoIdAndSerieAndNumero(proveedorId, docTipoId, serie, numero)
            .ifPresent(existing -> {
                if (excludeId == null || !existing.getId().equals(excludeId)) {
                    throw new BusinessException(
                        String.format("Ya existe un documento para el proveedor %d con tipo %d, serie %s y número %s",
                            proveedorId, docTipoId, serie, numero),
                        HttpStatus.CONFLICT,
                        FinanzasErrorCodes.DOCUMENTO_UNIQUE_KEY_DUPLICADO
                    );
                }
            });
    }
    
    private void validarMoneda(Long monedaId) {
        if (monedaId == null) {
            throw new BusinessException(
                "La moneda es obligatoria",
                HttpStatus.BAD_REQUEST,
                FinanzasErrorCodes.MONEDA_NO_ENCONTRADA
            );
        }
        
        try {
            coreMaestrosClient.obtenerMonedaPorId(monedaId);
        } catch (feign.FeignException.NotFound e) {
            throw new BusinessException(
                "Moneda no encontrada",
                HttpStatus.NOT_FOUND,
                FinanzasErrorCodes.MONEDA_NO_ENCONTRADA
            );
        }
    }
    
    private void validarProveedor(Long proveedorId) {
        try {
            coreMaestrosClient.obtenerEntidadPorId(proveedorId);
        } catch (feign.FeignException.NotFound e) {
            throw new BusinessException(
                "Proveedor no encontrado",
                HttpStatus.NOT_FOUND,
                FinanzasErrorCodes.PROVEEDOR_NO_ENCONTRADO
            );
        }
    }
    
    private void validarDocTipo(Long docTipoId) {
        try {
            coreMaestrosClient.obtenerDocTipoPorId(docTipoId);
        } catch (feign.FeignException.NotFound e) {
            throw new BusinessException(
                "Tipo de documento no encontrado",
                HttpStatus.NOT_FOUND,
                FinanzasErrorCodes.DOC_TIPO_NO_ENCONTRADO
            );
        }
    }
    
    private void validarFechas(LocalDate fechaEmision, LocalDate fechaVencimiento) {
        if (fechaVencimiento != null && fechaVencimiento.isBefore(fechaEmision)) {
            throw new BusinessException(
                "La fecha de vencimiento debe ser mayor o igual a la fecha de emisión",
                HttpStatus.UNPROCESSABLE_ENTITY,
                FinanzasErrorCodes.FECHA_VENCIMIENTO_INVALIDA
            );
        }
    }
    
    private void validarTotal(BigDecimal total) {
        if (total.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException(
                "El total debe ser mayor a cero",
                HttpStatus.BAD_REQUEST,
                FinanzasErrorCodes.SALDO_INVALIDO
            );
        }
    }
    
    private void validarDetalles(List<CntasPagarDetRequest> detalles) {
        if (detalles == null || detalles.isEmpty()) {
            throw new BusinessException(
                "La cuenta por pagar debe tener al menos un detalle",
                HttpStatus.BAD_REQUEST,
                FinanzasErrorCodes.SALDO_INVALIDO
            );
        }
        
        for (CntasPagarDetRequest detalle : detalles) {
            if (detalle.getArticuloId() != null) {
                validarArticulo(detalle);
            }
        }
    }
    
    private void validarArticulo(CntasPagarDetRequest detalle) {
        try {
            coreMaestrosClient.obtenerArticuloPorId(detalle.getArticuloId());
        } catch (feign.FeignException.NotFound e) {
            throw new BusinessException(
                "El artículo " + detalle.getDescripcion() + " no existe",
                HttpStatus.NOT_FOUND,
                FinanzasErrorCodes.ARTICULO_NO_ENCONTRADO
            );
        }
    }
    
    /**
     * Extrae el mensaje de error desde una excepción de Feign.
     * Intenta parsear el JSON de respuesta para obtener el campo "message".
     * Si falla el parseo JSON, intenta extracción manual por búsqueda de texto.
     * 
     * @param e Excepción de Feign con respuesta del servicio remoto
     * @return Mensaje de error extraído o mensaje genérico si no se puede extraer
     */
    private String extraerMensajeDeError(feign.FeignException e) {
        try {
            String responseBody = e.contentUTF8();
            if (responseBody != null && !responseBody.isEmpty()) {
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                com.fasterxml.jackson.databind.JsonNode jsonNode = mapper.readTree(responseBody);
                
                if (jsonNode.has("message")) {
                    String mensaje = jsonNode.get("message").asText();
                    log.debug("Mensaje extraído de error remoto: {}", mensaje);
                    return mensaje;
                }
            }
        } catch (Exception ex) {
            log.warn("No se pudo parsear JSON de error, intentando extracción manual", ex);
            
            try {
                String responseBody = e.contentUTF8();
                if (responseBody != null && responseBody.contains("\"message\"")) {
                    int messageIndex = responseBody.indexOf("\"message\"");
                    int colonIndex = responseBody.indexOf(":", messageIndex);
                    int startIndex = responseBody.indexOf("\"", colonIndex) + 1;
                    int endIndex = responseBody.indexOf("\"", startIndex);
                    
                    if (startIndex > 0 && endIndex > startIndex) {
                        String mensaje = responseBody.substring(startIndex, endIndex);
                        log.debug("Mensaje extraído manualmente: {}", mensaje);
                        return mensaje;
                    }
                }
            } catch (Exception ex2) {
                log.warn("Extracción manual de mensaje también falló", ex2);
            }
        }
        
        return "Error al comunicarse con el servicio de contabilidad";
    }

    // ==================== CONSTANTES DESCRIPTIVAS ====================
    
    private static final String FLAG_ESTADO_ACTIVO = "1";
    private static final String MONEDA_SOLES = "PEN";
    private static final String MONEDA_DOLARES = "USD";

    // ==================== MÉTODOS DE PENDIENTES POR PAGAR ====================

    /**
     * Lista todos los documentos pendientes por pagar agrupados por tipo.
     * Consulta múltiples repositorios y agrupa los resultados con totales calculados.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param proveedorId ID de proveedor (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Respuesta agrupada con listas por tipo y totales
     */
    @Override
    public PendientesPagarResponse listarPendientesPorPagarAgrupado(
            Long sucursalId, Long proveedorId, LocalDate fechaDesde, LocalDate fechaHasta) {
        
        log.info("Listando pendientes por pagar agrupados - sucursal: {}, proveedor: {}, fechas: {} - {}", 
                sucursalId, proveedorId, fechaDesde, fechaHasta);

        // Consultar cada tipo de documento
        List<CntasPagar> cuentasPagar = repository.findPendientesPorPagar(sucursalId, proveedorId, fechaDesde, fechaHasta);
        List<SolicitudGiro> ordenesGiro = solicitudGiroRepository.findPendientesPorPagar(sucursalId, null, fechaDesde, fechaHasta);
        List<Liquidacion> liquidaciones = liquidacionRepository.findPendientesPorPagar(sucursalId, proveedorId, fechaDesde, fechaHasta);
        List<Retencion> retenciones = retencionRepository.findPendientes(sucursalId, proveedorId, fechaDesde, fechaHasta);
        List<Detraccion> detracciones = detraccionRepository.findPendientes(fechaDesde, fechaHasta);

        // Mapear a DTOs
        List<PendientesPagarResponse.CuentaPagarItem> cuentasPagarItems = mapearCuentasPagar(cuentasPagar);
        List<PendientesPagarResponse.OrdenGiroItem> ordenesGiroItems = mapearOrdenesGiro(ordenesGiro);
        List<PendientesPagarResponse.LiquidacionItem> liquidacionesItems = mapearLiquidaciones(liquidaciones);
        List<PendientesPagarResponse.RetencionItem> retencionesItems = mapearRetenciones(retenciones);
        List<PendientesPagarResponse.DetraccionItem> detraccionesItems = mapearDetracciones(detracciones);

        // Calcular totales
        PendientesPagarResponse.Totales totales = calcularTotales(
                cuentasPagarItems, ordenesGiroItems, liquidacionesItems, retencionesItems, detraccionesItems);

        return PendientesPagarResponse.builder()
                .cuentasPagar(cuentasPagarItems)
                .ordenesGiro(ordenesGiroItems)
                .liquidaciones(liquidacionesItems)
                .retenciones(retencionesItems)
                .detracciones(detraccionesItems)
                .totales(totales)
                .build();
    }

    /**
     * Lista todos los documentos pendientes por pagar en formato simple unificado.
     * Combina todos los tipos de documentos en una lista plana.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param proveedorId ID de proveedor (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista simple unificada de pendientes
     */
    @Override
    public PendientesPagarSimpleResponse listarPendientesPorPagarSimple(
            Long sucursalId, Long proveedorId, LocalDate fechaDesde, LocalDate fechaHasta) {
        
        log.info("Listando pendientes por pagar simple - sucursal: {}, proveedor: {}, fechas: {} - {}", 
                sucursalId, proveedorId, fechaDesde, fechaHasta);

        List<PendientesPagarSimpleResponse.PendientePagarItem> items = new ArrayList<>();

        // Agregar cuentas por pagar
        List<CntasPagar> cuentasPagar = repository.findPendientesPorPagar(sucursalId, proveedorId, fechaDesde, fechaHasta);
        items.addAll(mapearCuentasPagarSimple(cuentasPagar));

        // Agregar órdenes de giro
        List<SolicitudGiro> ordenesGiro = solicitudGiroRepository.findPendientesPorPagar(sucursalId, null, fechaDesde, fechaHasta);
        items.addAll(mapearOrdenesGiroSimple(ordenesGiro));

        // Agregar liquidaciones
        List<Liquidacion> liquidaciones = liquidacionRepository.findPendientesPorPagar(sucursalId, proveedorId, fechaDesde, fechaHasta);
        items.addAll(mapearLiquidacionesSimple(liquidaciones));

        // Agregar retenciones
        List<Retencion> retenciones = retencionRepository.findPendientes(sucursalId, proveedorId, fechaDesde, fechaHasta);
        items.addAll(mapearRetencionesSimple(retenciones));

        // Agregar detracciones
        List<Detraccion> detracciones = detraccionRepository.findPendientes(fechaDesde, fechaHasta);
        items.addAll(mapearDetraccionesSimple(detracciones));

        // Calcular total pendiente
        BigDecimal totalPendiente = items.stream()
                .map(PendientesPagarSimpleResponse.PendientePagarItem::getSaldo)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return PendientesPagarSimpleResponse.builder()
                .content(items)
                .totalPendiente(totalPendiente)
                .build();
    }

    // ==================== MÉTODOS AUXILIARES DE MAPEO - VERSIÓN AGRUPADA ====================

    private List<PendientesPagarResponse.CuentaPagarItem> mapearCuentasPagar(List<CntasPagar> cuentas) {
        return cuentas.stream()
                .map(c -> PendientesPagarResponse.CuentaPagarItem.builder()
                        .id(c.getId())
                        .proveedorId(c.getProveedorId())
                        .proveedorRazonSocial("Proveedor " + c.getProveedorId()) // TODO: Obtener de ms-core
                        .docTipoId(c.getDocTipoId())
                        .docTipoNombre("Tipo " + c.getDocTipoId()) // TODO: Obtener de ms-core
                        .serie(c.getSerie())
                        .numero(c.getNumero())
                        .fechaEmision(c.getFechaEmision())
                        .fechaVencimiento(c.getFechaVencimiento())
                        .monedaCodigo(obtenerCodigoMoneda(c.getMonedaId()))
                        .total(c.getTotal())
                        .saldo(c.getSaldo())
                        .esDirecto(esDocumentoDirecto(c))
                        .build())
                .collect(Collectors.toList());
    }

    private List<PendientesPagarResponse.OrdenGiroItem> mapearOrdenesGiro(List<SolicitudGiro> ordenes) {
        return ordenes.stream()
                .map(o -> PendientesPagarResponse.OrdenGiroItem.builder()
                        .id(o.getId())
                        .numero(o.getNumero())
                        .fecha(o.getFecha())
                        .solicitanteId(o.getSolicitanteId())
                        .solicitanteNombre("Usuario " + o.getSolicitanteId()) // TODO: Obtener de ms-auth
                        .monto(o.getMonto())
                        .motivo(o.getMotivo())
                        .tipoSolicitud(o.getTipoSolicitud())
                        .build())
                .collect(Collectors.toList());
    }

    private List<PendientesPagarResponse.LiquidacionItem> mapearLiquidaciones(List<Liquidacion> liquidaciones) {
        return liquidaciones.stream()
                .map(l -> PendientesPagarResponse.LiquidacionItem.builder()
                        .id(l.getId())
                        .nroLiquidacion(l.getNroLiquidacion())
                        .fechaRegistro(l.getFechaRegistro())
                        .proveedorId(l.getProveedorId())
                        .proveedorRazonSocial("Proveedor " + l.getProveedorId()) // TODO: Obtener de ms-core
                        .monedaCodigo(obtenerCodigoMoneda(l.getMonedaId()))
                        .importeNeto(l.getImporteNeto())
                        .saldo(l.getSaldo())
                        .build())
                .collect(Collectors.toList());
    }

    private List<PendientesPagarResponse.RetencionItem> mapearRetenciones(List<Retencion> retenciones) {
        return retenciones.stream()
                .map(r -> PendientesPagarResponse.RetencionItem.builder()
                        .id(r.getId())
                        .nroCertificado(r.getNroCertificado())
                        .fechaEmision(r.getFechaEmision())
                        .proveedorId(r.getProveedorId())
                        .proveedorRazonSocial("Proveedor " + r.getProveedorId()) // TODO: Obtener de ms-core
                        .saldoSol(r.getSaldoSol())
                        .saldoDol(r.getSaldoDol())
                        .importeDoc(r.getImporteDoc())
                        .build())
                .collect(Collectors.toList());
    }

    private List<PendientesPagarResponse.DetraccionItem> mapearDetracciones(List<Detraccion> detracciones) {
        return detracciones.stream()
                .map(d -> PendientesPagarResponse.DetraccionItem.builder()
                        .id(d.getId())
                        .nroDetraccion(d.getNroDetraccion())
                        .fechaRegistro(d.getFechaRegistro())
                        .nroDeposito(d.getNroDeposito())
                        .fechaDeposito(d.getFechaDeposito())
                        .importe(d.getImporte())
                        .build())
                .collect(Collectors.toList());
    }

    // ==================== MÉTODOS AUXILIARES DE MAPEO - VERSIÓN SIMPLE ====================

    private List<PendientesPagarSimpleResponse.PendientePagarItem> mapearCuentasPagarSimple(List<CntasPagar> cuentas) {
        return cuentas.stream()
                .map(c -> PendientesPagarSimpleResponse.PendientePagarItem.builder()
                        .tipoDocumento(PendientesPagarSimpleResponse.TipoDocumentoPagar.CUENTA_PAGAR)
                        .id(c.getId())
                        .numero(c.getSerie() + "-" + c.getNumero())
                        .fecha(c.getFechaEmision())
                        .proveedor("Proveedor " + c.getProveedorId())
                        .total(c.getTotal())
                        .saldo(c.getSaldo())
                        .moneda(obtenerCodigoMoneda(c.getMonedaId()))
                        .observacion(esDocumentoDirecto(c) ? "Documento Directo" : null)
                        .build())
                .collect(Collectors.toList());
    }

    private List<PendientesPagarSimpleResponse.PendientePagarItem> mapearOrdenesGiroSimple(List<SolicitudGiro> ordenes) {
        return ordenes.stream()
                .map(o -> PendientesPagarSimpleResponse.PendientePagarItem.builder()
                        .tipoDocumento(PendientesPagarSimpleResponse.TipoDocumentoPagar.ORDEN_GIRO)
                        .id(o.getId())
                        .numero(o.getNumero())
                        .fecha(o.getFecha())
                        .proveedor("Solicitante: Usuario " + o.getSolicitanteId())
                        .total(o.getMonto())
                        .saldo(o.getMonto())
                        .moneda(MONEDA_SOLES)
                        .observacion(o.getMotivo())
                        .build())
                .collect(Collectors.toList());
    }

    private List<PendientesPagarSimpleResponse.PendientePagarItem> mapearLiquidacionesSimple(List<Liquidacion> liquidaciones) {
        return liquidaciones.stream()
                .map(l -> PendientesPagarSimpleResponse.PendientePagarItem.builder()
                        .tipoDocumento(PendientesPagarSimpleResponse.TipoDocumentoPagar.LIQUIDACION)
                        .id(l.getId())
                        .numero(l.getNroLiquidacion())
                        .fecha(l.getFechaRegistro())
                        .proveedor("Proveedor " + l.getProveedorId())
                        .total(l.getImporteNeto())
                        .saldo(l.getSaldo().abs()) // Valor absoluto del saldo negativo
                        .moneda(obtenerCodigoMoneda(l.getMonedaId()))
                        .observacion(l.getObservacion())
                        .build())
                .collect(Collectors.toList());
    }

    private List<PendientesPagarSimpleResponse.PendientePagarItem> mapearRetencionesSimple(List<Retencion> retenciones) {
        return retenciones.stream()
                .map(r -> PendientesPagarSimpleResponse.PendientePagarItem.builder()
                        .tipoDocumento(PendientesPagarSimpleResponse.TipoDocumentoPagar.RETENCION)
                        .id(r.getId())
                        .numero(r.getNroCertificado())
                        .fecha(r.getFechaEmision())
                        .proveedor("Proveedor " + r.getProveedorId())
                        .total(r.getImporteDoc())
                        .saldo(r.getSaldoSol().add(r.getSaldoDol())) // Suma de saldos en ambas monedas
                        .moneda("MIXTO")
                        .observacion("Saldo S/: " + r.getSaldoSol() + " - $: " + r.getSaldoDol())
                        .build())
                .collect(Collectors.toList());
    }

    private List<PendientesPagarSimpleResponse.PendientePagarItem> mapearDetraccionesSimple(List<Detraccion> detracciones) {
        return detracciones.stream()
                .map(d -> PendientesPagarSimpleResponse.PendientePagarItem.builder()
                        .tipoDocumento(PendientesPagarSimpleResponse.TipoDocumentoPagar.DETRACCION)
                        .id(d.getId())
                        .numero(d.getNroDetraccion())
                        .fecha(d.getFechaRegistro())
                        .proveedor("SUNAT")
                        .total(d.getImporte())
                        .saldo(d.getImporte())
                        .moneda(MONEDA_SOLES)
                        .observacion("Depósito: " + d.getNroDeposito())
                        .build())
                .collect(Collectors.toList());
    }

    // ==================== MÉTODOS AUXILIARES DE CÁLCULO ====================

    /**
     * Calcula los totales por tipo de documento y el total general.
     * 
     * @param cuentasPagar Lista de cuentas por pagar
     * @param ordenesGiro Lista de órdenes de giro
     * @param liquidaciones Lista de liquidaciones
     * @param retenciones Lista de retenciones
     * @param detracciones Lista de detracciones
     * @return Objeto con totales calculados
     */
    private PendientesPagarResponse.Totales calcularTotales(
            List<PendientesPagarResponse.CuentaPagarItem> cuentasPagar,
            List<PendientesPagarResponse.OrdenGiroItem> ordenesGiro,
            List<PendientesPagarResponse.LiquidacionItem> liquidaciones,
            List<PendientesPagarResponse.RetencionItem> retenciones,
            List<PendientesPagarResponse.DetraccionItem> detracciones) {

        BigDecimal totalCuentasPagar = cuentasPagar.stream()
                .map(PendientesPagarResponse.CuentaPagarItem::getSaldo)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalOrdenesGiro = ordenesGiro.stream()
                .map(PendientesPagarResponse.OrdenGiroItem::getMonto)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalLiquidaciones = liquidaciones.stream()
                .map(l -> l.getSaldo().abs()) // Valor absoluto del saldo negativo
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalRetenciones = retenciones.stream()
                .map(r -> r.getSaldoSol().add(r.getSaldoDol()))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalDetracciones = detracciones.stream()
                .map(PendientesPagarResponse.DetraccionItem::getImporte)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalGeneral = totalCuentasPagar
                .add(totalOrdenesGiro)
                .add(totalLiquidaciones)
                .add(totalRetenciones)
                .add(totalDetracciones);

        return PendientesPagarResponse.Totales.builder()
                .cuentasPagar(totalCuentasPagar)
                .ordenesGiro(totalOrdenesGiro)
                .liquidaciones(totalLiquidaciones)
                .retenciones(totalRetenciones)
                .detracciones(totalDetracciones)
                .totalGeneral(totalGeneral)
                .build();
    }

    /**
     * Determina si una cuenta por pagar es un documento directo.
     * Verifica si algún detalle tiene tipo_mov = 'DIRECTO'.
     * 
     * @param cuentaPagar Cuenta por pagar a verificar
     * @return true si es documento directo, false en caso contrario
     */
    private boolean esDocumentoDirecto(CntasPagar cuentaPagar) {
        return cuentaPagar.getDetalles().stream()
                .anyMatch(det -> "DIRECTO".equals(det.getTipoMov()));
    }

    /**
     * Obtiene el código de moneda basado en el ID.
     * 
     * @param monedaId ID de la moneda
     * @return Código de moneda (PEN, USD, etc.)
     */
    private String obtenerCodigoMoneda(Long monedaId) {
        if (monedaId == null) {
            return MONEDA_SOLES;
        }
        // TODO: Obtener de ms-core-maestros
        return monedaId == 1L ? MONEDA_SOLES : MONEDA_DOLARES;
    }

    private List<DetImpuestoRequest> toImpuestoRequests(List<DetImpuestoResponse> impuestos) {
        if (impuestos == null || impuestos.isEmpty()) {
            return List.of();
        }
        return impuestos.stream()
                .map(r -> new DetImpuestoRequest(r.getTiposImpuestoId(), r.getImporte()))
                .toList();
    }

    private BigDecimal obtenerTasaCambio(LocalDate fecha, Long monedaId) {
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
}
