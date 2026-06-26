package pe.restaurant.finanzas.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.service.NumeradorDocumentoService;
import pe.restaurant.finanzas.client.ContabilidadClient;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.dto.request.CajaBancosDetalleRequest;
import pe.restaurant.finanzas.dto.request.CajaBancosRequest;
import pe.restaurant.finanzas.dto.request.CajaBancosAsientoRequest;
import pe.restaurant.finanzas.dto.request.CajaBancosDetAsientoRequest;
import pe.restaurant.finanzas.dto.response.AsientoContableResponse;
import pe.restaurant.finanzas.dto.response.GenerarAsientoResponse;
import pe.restaurant.finanzas.dto.response.CajaBancosDetalleResponse;
import pe.restaurant.finanzas.dto.response.CajaBancosResponse;
import pe.restaurant.finanzas.dto.response.EjecutarMovimientoResponse;
import pe.restaurant.finanzas.entity.BancoCnta;
import pe.restaurant.finanzas.entity.CajaBancos;
import pe.restaurant.finanzas.entity.CajaBancosDet;
import pe.restaurant.finanzas.mapper.CajaBancosDetMapper;
import pe.restaurant.finanzas.mapper.CajaBancosMapper;
import pe.restaurant.finanzas.repository.BancoCntaRepository;
import pe.restaurant.finanzas.repository.CajaBancosDetRepository;
import pe.restaurant.finanzas.repository.CajaBancosRepository;
import pe.restaurant.finanzas.service.support.CntasPagarCabeceraValidator;
import pe.restaurant.finanzas.specification.CajaBancosSpecification;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class CajaBancosService {

    // Constantes para tipos de transacción
    private static final String TIPO_TRANSACCION_COBRO = "C";
    private static final String TIPO_TRANSACCION_PAGO = "P";
    private static final String TIPO_TRANSACCION_TRANSFERENCIA = "T";
    private static final String TIPO_TRANSACCION_APLICACION_DOCUMENTOS = "A";
    
    // Constantes para estados
    private static final String ESTADO_ACTIVO = "1";
    private static final String ESTADO_INACTIVO = "0";
    
    
    private final CajaBancosRepository repository;
    private final CajaBancosDetRepository detRepository;
    private final BancoCntaRepository bancoCntaRepository;
    private final CajaBancosMapper mapper;
    private final CajaBancosDetMapper detMapper;
    private final NumeradorDocumentoService numeradorDocumentoService;
    private final ContabilidadClient contabilidadClient;
    private final CoreMaestrosClient coreMaestrosClient;
    private final CntasPagarCabeceraValidator cabeceraValidator;

    @Transactional(readOnly = true)
    public Page<CajaBancosResponse> listar(String flagTipoTransaccion, Long bancoCntaId, 
                                           LocalDate fechaDesde, LocalDate fechaHasta, 
                                           String estado, Long entidadContribuyenteId, 
                                           Pageable pageable) {
        Specification<CajaBancos> spec = Specification.where(null);
        
        if (flagTipoTransaccion != null && !flagTipoTransaccion.isEmpty()) {
            spec = spec.and(CajaBancosSpecification.conFlagTipoTransaccion(flagTipoTransaccion));
        }
        if (bancoCntaId != null) {
            spec = spec.and(CajaBancosSpecification.conBancoCntaId(bancoCntaId));
        }
        if (fechaDesde != null) {
            spec = spec.and(CajaBancosSpecification.conFechaEmisionDesde(fechaDesde));
        }
        if (fechaHasta != null) {
            spec = spec.and(CajaBancosSpecification.conFechaEmisionHasta(fechaHasta));
        }
        if (estado != null && !estado.isEmpty()) {
            spec = spec.and(CajaBancosSpecification.conEstado(estado));
        }
        if (entidadContribuyenteId != null) {
            spec = spec.and(CajaBancosSpecification.conEntidadContribuyenteId(entidadContribuyenteId));
        }
        
        Page<CajaBancos> page = repository.findAll(spec, pageable);
        return page.map(entity -> {
            CajaBancosResponse response = mapper.toResponse(entity);
            enriquecerConDatosMaestros(response);
            return response;
        });
    }

    @Transactional(readOnly = true)
    public CajaBancosDetalleResponse obtenerPorId(Long id) {
        CajaBancos entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Movimiento de caja/bancos", id));
        return mapper.toDetalleResponse(entity);
    }

    @Transactional
    public CajaBancosDetalleResponse crear(CajaBancosRequest request) {
        validarFlagTipoTransaccion(request.getFlagTipoTransaccion());
        validarCuentaBancaria(request.getBancoCntaId());
        
        if (TIPO_TRANSACCION_TRANSFERENCIA.equals(request.getFlagTipoTransaccion())) {
            if (request.getBancoCntaRefId() == null) {
                throw new BusinessException("La cuenta bancaria destino es obligatoria para transferencias", "FIN-VALIDACION");
            }
            validarCuentaBancariaDestino(request.getBancoCntaRefId());
            if (request.getBancoCntaId().equals(request.getBancoCntaRefId())) {
                throw new BusinessException("La cuenta origen y destino no pueden ser la misma", "FIN-VALIDACION");
            }
        }
        
        if (TIPO_TRANSACCION_APLICACION_DOCUMENTOS.equals(request.getFlagTipoTransaccion())) {
            if (request.getDetalles() == null || request.getDetalles().isEmpty()) {
                throw new BusinessException("Los detalles son obligatorios para aplicación de documentos", "FIN-VALIDACION");
            }
        }
        
        validarCuadreDetalles(request);
        cabeceraValidator.validar(request.getAno(), request.getMes(), request.getCntblLibroId());
        
        Long sucursalId = TenantContext.getSucursalId();
        Long usuarioId = TenantContext.getUsuarioId();
        
        CajaBancos entity = mapper.toEntity(request);
        
        String nroRegistro = numeradorDocumentoService.siguienteNroDocumento(
            "finanzas.caja_bancos",
            sucursalId,
            LocalDate.now().getYear()
        );
        entity.setNroRegistro(nroRegistro);
        entity.setSucursalId(sucursalId);
        entity.setCreatedBy(usuarioId);
        entity.setUpdatedBy(usuarioId);
        
        BigDecimal impAsignado = request.getDetalles().stream()
            .map(CajaBancosDetalleRequest::getImporte)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        entity.setImpAsignado(impAsignado);
        
        // Agregar detalles ANTES de guardar
        for (CajaBancosDetalleRequest detalleReq : request.getDetalles()) {
            CajaBancosDet detalle = detMapper.toEntity(detalleReq);
            detalle.setCreatedBy(usuarioId);
            detalle.setUpdatedBy(usuarioId);
            entity.addDetalle(detalle);
        }
        
        // Guardar UNA SOLA VEZ con todos los detalles (CascadeType.ALL los persiste automáticamente)
        log.info("[CREAR] Guardando entity con {} detalles", entity.getDetalles().size());
        CajaBancos saved = repository.saveAndFlush(entity);
        log.info("[CREAR] Entity guardada - ID: {} - Detalles persistidos: {}", saved.getId(), saved.getDetalles().size());
        
        log.info("Movimiento de caja/bancos creado: {} - Tipo: {}", nroRegistro, request.getFlagTipoTransaccion());
        
        return mapper.toDetalleResponse(saved);
    }

    @Transactional
    public CajaBancosDetalleResponse actualizar(Long id, CajaBancosRequest request) {
        CajaBancos entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Movimiento de caja/bancos", id));
        
        validarEstadoEditable(entity);
        validarFlagTipoTransaccion(request.getFlagTipoTransaccion());
        validarCuentaBancaria(request.getBancoCntaId());
        
        if (TIPO_TRANSACCION_TRANSFERENCIA.equals(request.getFlagTipoTransaccion())) {
            if (request.getBancoCntaRefId() == null) {
                throw new BusinessException("La cuenta bancaria destino es obligatoria para transferencias", "FIN-VALIDACION");
            }
            validarCuentaBancariaDestino(request.getBancoCntaRefId());
            if (request.getBancoCntaId().equals(request.getBancoCntaRefId())) {
                throw new BusinessException("La cuenta origen y destino no pueden ser la misma", "FIN-VALIDACION");
            }
        }
        
        validarCuadreDetalles(request);
        cabeceraValidator.validar(request.getAno(), request.getMes(), request.getCntblLibroId());
        
        Long usuarioId = TenantContext.getUsuarioId();
        
        mapper.updateEntity(entity, request);
        entity.setUpdatedBy(usuarioId);
        
        BigDecimal impAsignado = request.getDetalles().stream()
            .map(CajaBancosDetalleRequest::getImporte)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        entity.setImpAsignado(impAsignado);
        
        entity.clearDetalles();
        detRepository.flush();
        
        for (CajaBancosDetalleRequest detalleReq : request.getDetalles()) {
            CajaBancosDet detalle = detMapper.toEntity(detalleReq);
            detalle.setCreatedBy(usuarioId);
            detalle.setUpdatedBy(usuarioId);
            entity.addDetalle(detalle);
        }
        
        repository.save(entity);
        
        log.info("Movimiento de caja/bancos actualizado: {}", entity.getNroRegistro());
        
        return mapper.toDetalleResponse(entity);
    }

    @Transactional
    public EjecutarMovimientoResponse ejecutar(Long id) {
        CajaBancos entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Movimiento de caja/bancos", id));
        
        if (entity.getFechaEjecucion() != null) {
            throw new BusinessException("El movimiento ya fue ejecutado", "FIN-ESTADO_INVALIDO");
        }
        
        if (!ESTADO_ACTIVO.equals(entity.getFlagEstado())) {
            throw new BusinessException("El movimiento no está activo", "FIN-ESTADO_INVALIDO");
        }
        
        Long usuarioId = TenantContext.getUsuarioId();
        String flagTipo = entity.getFlagTipoTransaccion();
        
        AsientoContableResponse asiento = null;
        
        try {
            switch (flagTipo) {
                case TIPO_TRANSACCION_COBRO:
                    ejecutarCobro(entity);
                    break;
                case TIPO_TRANSACCION_PAGO:
                    ejecutarPago(entity);
                    break;
                case TIPO_TRANSACCION_TRANSFERENCIA:
                    ejecutarTransferencia(entity);
                    break;
                case TIPO_TRANSACCION_APLICACION_DOCUMENTOS:
                    ejecutarAplicacion(entity);
                    break;
                default:
                    throw new BusinessException("Tipo de transacción no válido", "FIN-VALIDACION");
            }
            
            entity.setFechaEjecucion(LocalDate.now());
            
            // Generar asiento contable para todos los tipos de transacción
            log.info("[EJECUTAR] Antes de crear asiento - Entity ID: {} - Detalles en memoria: {}", entity.getId(), entity.getDetalles().size());
            asiento = crearAsientoContable(entity);
            entity.setCntblAsientoId(asiento.getId());
            
            entity.setUpdatedBy(usuarioId);
            log.info("[EJECUTAR] Guardando entity después de asiento - Detalles: {}", entity.getDetalles().size());
            repository.save(entity);
            log.info("[EJECUTAR] Entity guardada - Detalles finales: {}", entity.getDetalles().size());
            
            log.info("Movimiento ejecutado: {} - Tipo: {} - Asiento: {}", 
                entity.getNroRegistro(), flagTipo, entity.getCntblAsientoId());
            
        } catch (Exception e) {
            log.error("Error al ejecutar movimiento, iniciando compensación", e);
            if (asiento != null) {
                try {
                    contabilidadClient.anularAsiento(asiento.getId());
                    log.info("Asiento {} anulado en compensación", asiento.getId());
                } catch (Exception compensationEx) {
                    log.error("Error crítico al anular asiento en compensación", compensationEx);
                }
            }
            throw e;
        }
        
        EjecutarMovimientoResponse response = new EjecutarMovimientoResponse();
        response.setId(entity.getId());
        response.setFechaEjecucion(entity.getFechaEjecucion());
        response.setCntblAsientoId(entity.getCntblAsientoId());
        response.setFlagEstado(entity.getFlagEstado());
        response.setUpdatedBy(entity.getUpdatedBy());
        response.setFecModificacion(entity.getFecModificacion());
        
        return response;
    }

    @Transactional
    public Map<String, Object> anular(Long id) {
        CajaBancos entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Movimiento de caja/bancos", id));
        
        validarEstadoAnulable(entity);
        
        Long usuarioId = TenantContext.getUsuarioId();
        
        entity.setFlagEstado(ESTADO_INACTIVO);
        entity.setUpdatedBy(usuarioId);
        
        repository.save(entity);
        
        log.info("Movimiento anulado: {}", entity.getNroRegistro());
        
        Map<String, Object> resultado = new HashMap<>();
        resultado.put("id", entity.getId());
        resultado.put("flagEstado", ESTADO_INACTIVO);
        resultado.put("updatedBy", entity.getUpdatedBy());
        resultado.put("fecModificacion", entity.getFecModificacion());
        
        return resultado;
    }

    private void ejecutarCobro(CajaBancos entity) {
        BancoCnta cuenta = bancoCntaRepository.findById(entity.getBancoCntaId())
            .orElseThrow(() -> new ResourceNotFoundException("Cuenta bancaria", entity.getBancoCntaId()));
        
        BigDecimal nuevoSaldo = cuenta.getSaldoDisponible().add(entity.getImpTotal());
        cuenta.setSaldoDisponible(nuevoSaldo);
        bancoCntaRepository.save(cuenta);
        
        log.info("Cobro ejecutado - Cuenta: {} - Incremento: {}", cuenta.getCodigo(), entity.getImpTotal());
    }

    private void ejecutarPago(CajaBancos entity) {
        BancoCnta cuenta = bancoCntaRepository.findById(entity.getBancoCntaId())
            .orElseThrow(() -> new ResourceNotFoundException("Cuenta bancaria", entity.getBancoCntaId()));
        
        validarSaldoDisponible(cuenta, entity.getImpTotal());
        
        BigDecimal nuevoSaldo = cuenta.getSaldoDisponible().subtract(entity.getImpTotal());
        cuenta.setSaldoDisponible(nuevoSaldo);
        bancoCntaRepository.save(cuenta);
        
        log.info("Pago ejecutado - Cuenta: {} - Decremento: {}", cuenta.getCodigo(), entity.getImpTotal());
    }

    private void ejecutarTransferencia(CajaBancos entity) {
        BancoCnta cuentaOrigen = bancoCntaRepository.findById(entity.getBancoCntaId())
            .orElseThrow(() -> new ResourceNotFoundException("Cuenta bancaria origen", entity.getBancoCntaId()));
        
        BancoCnta cuentaDestino = bancoCntaRepository.findById(entity.getBancoCntaRefId())
            .orElseThrow(() -> new ResourceNotFoundException("Cuenta bancaria destino", entity.getBancoCntaRefId()));
        
        validarSaldoDisponible(cuentaOrigen, entity.getImpTotal());
        
        BigDecimal nuevoSaldoOrigen = cuentaOrigen.getSaldoDisponible().subtract(entity.getImpTotal());
        cuentaOrigen.setSaldoDisponible(nuevoSaldoOrigen);
        
        BigDecimal nuevoSaldoDestino = cuentaDestino.getSaldoDisponible().add(entity.getImpTotal());
        cuentaDestino.setSaldoDisponible(nuevoSaldoDestino);
        
        bancoCntaRepository.save(cuentaOrigen);
        bancoCntaRepository.save(cuentaDestino);
        
        log.info("Transferencia ejecutada - Origen: {} - Destino: {} - Monto: {}", 
            cuentaOrigen.getCodigo(), cuentaDestino.getCodigo(), entity.getImpTotal());
    }

    private void ejecutarAplicacion(CajaBancos entity) {
        log.info("Aplicación de documentos ejecutada - No afecta saldo bancario");
    }

    private void validarFlagTipoTransaccion(String flagTipo) {
        if (flagTipo == null || (!flagTipo.equals(TIPO_TRANSACCION_COBRO) && !flagTipo.equals(TIPO_TRANSACCION_PAGO) && 
            !flagTipo.equals(TIPO_TRANSACCION_TRANSFERENCIA) && !flagTipo.equals(TIPO_TRANSACCION_APLICACION_DOCUMENTOS))) {
            throw new BusinessException("Tipo de transacción no válido. Debe ser C, P, T o A", "FIN-VALIDACION");
        }
    }

    private void validarCuentaBancaria(Long bancoCntaId) {
        BancoCnta cuenta = bancoCntaRepository.findById(bancoCntaId)
            .orElseThrow(() -> new ResourceNotFoundException("Cuenta bancaria", bancoCntaId));
        
        if (!ESTADO_ACTIVO.equals(cuenta.getFlagEstado())) {
            throw new BusinessException("La cuenta bancaria no está activa", "FIN-VALIDACION");
        }
    }

    private void validarCuentaBancariaDestino(Long bancoCntaRefId) {
        BancoCnta cuenta = bancoCntaRepository.findById(bancoCntaRefId)
            .orElseThrow(() -> new ResourceNotFoundException("Cuenta bancaria destino", bancoCntaRefId));
        
        if (!ESTADO_ACTIVO.equals(cuenta.getFlagEstado())) {
            throw new BusinessException("La cuenta bancaria destino no está activa", "FIN-VALIDACION");
        }
    }

    private void validarSaldoDisponible(BancoCnta cuenta, BigDecimal monto) {
        if (cuenta.getSaldoDisponible().compareTo(monto) < 0) {
            throw new BusinessException(
                String.format("Saldo insuficiente en cuenta %s. Disponible: %s, Requerido: %s", 
                    cuenta.getCodigo(), cuenta.getSaldoDisponible(), monto),
                "FIN-SALDO_INVALIDO"
            );
        }
    }

    private void validarCuadreDetalles(CajaBancosRequest request) {
        BigDecimal sumaDetalles = request.getDetalles().stream()
            .map(CajaBancosDetalleRequest::getImporte)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        if (sumaDetalles.compareTo(request.getImpTotal()) != 0) {
            throw new BusinessException(
                String.format("La suma de los detalles (%s) no coincide con el importe total (%s)", 
                    sumaDetalles, request.getImpTotal()),
                "FIN-VALIDACION"
            );
        }
    }

    private void validarEstadoEditable(CajaBancos entity) {
        if (entity.getFechaEjecucion() != null) {
            throw new BusinessException("No se puede editar un movimiento ejecutado", "FIN-ESTADO_INVALIDO");
        }
        
        if (!ESTADO_ACTIVO.equals(entity.getFlagEstado())) {
            throw new BusinessException("No se puede editar un movimiento anulado", "FIN-ESTADO_INVALIDO");
        }
    }

    private void validarEstadoAnulable(CajaBancos entity) {
        if (entity.getFechaEjecucion() != null) {
            throw new BusinessException("No se puede anular un movimiento ejecutado", "FIN-ESTADO_INVALIDO");
        }
        
        if (!ESTADO_ACTIVO.equals(entity.getFlagEstado())) {
            throw new BusinessException("El movimiento ya está anulado", "FIN-ESTADO_INVALIDO");
        }
    }

    /**
     * Crea el asiento contable para un movimiento de caja/bancos.
     * Utiliza el endpoint específico de ms-contabilidad según el tipo de transacción:
     * - COBRO: generarAsientoCarteraCobros
     * - PAGO: generarAsientoCarteraPagos
     * - TRANSFERENCIA: generarAsientoTransferencias
     * - APLICACIÓN DE DOCUMENTOS: generarAsientoAplicacionDocumentos
     * 
     * @param entity Movimiento de caja/bancos para el cual generar el asiento
     * @return Respuesta del asiento contable generado con el ID del asiento
     * @throws BusinessException Si hay error en la generación del asiento
     */
    private AsientoContableResponse crearAsientoContable(CajaBancos entity) {
        log.info("Generando asiento contable para caja/bancos: {} - Tipo: {}", 
            entity.getNroRegistro(), entity.getFlagTipoTransaccion());
        try {
            CajaBancosAsientoRequest asientoRequest = construirCajaBancosAsientoRequest(entity);
            
            GenerarAsientoResponse generarResponse;
            String flagTipo = entity.getFlagTipoTransaccion();
            
            switch (flagTipo) {
                case TIPO_TRANSACCION_COBRO:
                    generarResponse = contabilidadClient.generarAsientoCarteraCobros(asientoRequest).getData();
                    break;
                case TIPO_TRANSACCION_PAGO:
                    generarResponse = contabilidadClient.generarAsientoCarteraPagos(asientoRequest).getData();
                    break;
                case TIPO_TRANSACCION_TRANSFERENCIA:
                    generarResponse = contabilidadClient.generarAsientoTransferencias(asientoRequest).getData();
                    break;
                case TIPO_TRANSACCION_APLICACION_DOCUMENTOS:
                    generarResponse = contabilidadClient.generarAsientoAplicacionDocumentos(asientoRequest).getData();
                    break;
                default:
                    throw new BusinessException("Tipo de transacción no válido para generar asiento", "FIN-VALIDACION");
            }
            
            log.info("Asiento contable generado con ID: {} - Voucher: {}", 
                generarResponse.getAsientoId(), generarResponse.getVoucher());
            
            // Convertir GenerarAsientoResponse a AsientoContableResponse para mantener compatibilidad
            AsientoContableResponse asiento = new AsientoContableResponse();
            asiento.setId(generarResponse.getAsientoId());
            return asiento;
            
        } catch (feign.FeignException.Conflict e) {
            String mensaje = extraerMensajeDeError(e);
            log.error("Conflicto al generar asiento: {}", mensaje, e);
            throw new BusinessException(mensaje, HttpStatus.CONFLICT, "FIN-ASIENTO_DUPLICADO");
        } catch (feign.FeignException.UnprocessableEntity e) {
            String mensaje = extraerMensajeDeError(e);
            log.error("Error de validación en ms-contabilidad: {}", mensaje, e);
            throw new BusinessException(mensaje, HttpStatus.UNPROCESSABLE_ENTITY, "FIN-ASIENTO_NO_BALANCEADO");
        } catch (feign.FeignException.NotFound e) {
            String mensaje = extraerMensajeDeError(e);
            log.error("Recurso no encontrado en ms-contabilidad: {}", mensaje, e);
            throw new BusinessException(mensaje, HttpStatus.NOT_FOUND, "FIN-CONTABILIDAD_NOT_FOUND");
        } catch (feign.FeignException.BadRequest e) {
            String mensaje = extraerMensajeDeError(e);
            log.error("Solicitud inválida a ms-contabilidad: {}", mensaje, e);
            throw new BusinessException(mensaje, HttpStatus.BAD_REQUEST, "FIN-CONTABILIDAD_BAD_REQUEST");
        } catch (feign.FeignException e) {
            String mensaje = extraerMensajeDeError(e);
            log.error("Error al comunicarse con ms-contabilidad: {}", mensaje, e);
            throw new BusinessException(mensaje, HttpStatus.SERVICE_UNAVAILABLE, "FIN-CONTABILIDAD_NO_ACCESIBLE");
        }
    }

    private CajaBancosAsientoRequest construirCajaBancosAsientoRequest(CajaBancos entity) {
        List<CajaBancosDet> cajaBancosDetalles = entity.getDetalles();
        if (cajaBancosDetalles == null || cajaBancosDetalles.isEmpty()) {
            throw new BusinessException(
                "Se requieren detalles en caja_bancos_det para generar el asiento contable",
                "FIN-VALIDACION");
        }

        String glosa = construirGlosaAsiento(entity);

        List<CajaBancosDetAsientoRequest> detalles = cajaBancosDetalles.stream()
                .map(det -> CajaBancosDetAsientoRequest.builder()
                        .id(det.getId())
                        .item(det.getItem())
                        .entidadContribuyenteId(det.getEntidadContribuyenteId())
                        .docTipoId(det.getDocTipoId())
                        .nroDoc(det.getNroDoc())
                        .importe(det.getImporte())
                        .cntasPagarId(det.getCntasPagarId())
                        .cntasCobrarId(det.getCntasCobrarId())
                        .solicitudGiroId(det.getSolicitudGiroId())
                        .liquidacionId(det.getLiquidacionId())
                        .conceptoFinancieroId(det.getConceptoFinancieroId())
                        .centrosCostoId(det.getCentrosCostoId())
                        .monedaId(det.getMonedaId())
                        .sucursalRefId(det.getSucursalRefId())
                        .glosa(det.getNroDoc() != null ? "Doc: " + det.getNroDoc() : null)
                        .build())
                .toList();

        return CajaBancosAsientoRequest.builder()
                .id(entity.getId())
                .sucursalId(entity.getSucursalId())
                .fechaEmision(entity.getFechaEjecucion() != null ? entity.getFechaEjecucion() : LocalDate.now())
                .monedaId(entity.getMonedaId())
                .entidadContribuyenteId(entity.getEntidadContribuyenteId())
                .impTotal(entity.getImpTotal())
                .bancoCntaId(entity.getBancoCntaId())
                .bancoCntaRefId(entity.getBancoCntaRefId())
                .conceptoFinancieroId(entity.getConceptoFinancieroId())
                .tasaCambio(entity.getTasaCambio() != null ? entity.getTasaCambio() : BigDecimal.ONE)
                .ano(entity.getAno())
                .mes(entity.getMes())
                .cntblLibroId(entity.getCntblLibroId())
                .observacion(glosa)
                .flagTipoTransaccion(entity.getFlagTipoTransaccion())
                .docTipoId(entity.getDocTipoId())
                .nroDoc(entity.getNroDoc())
                .detalles(detalles)
                .build();
    }

    private String construirGlosaAsiento(CajaBancos entity) {
        String tipoTransaccion = switch (entity.getFlagTipoTransaccion()) {
            case TIPO_TRANSACCION_COBRO -> "Cobro";
            case TIPO_TRANSACCION_PAGO -> "Pago";
            case TIPO_TRANSACCION_TRANSFERENCIA -> "Transferencia";
            case TIPO_TRANSACCION_APLICACION_DOCUMENTOS -> "Aplicación de documentos";
            default -> "Movimiento";
        };

        return String.format("%s - %s - %s",
            tipoTransaccion,
            entity.getNroRegistro(),
            entity.getObservacion() != null ? entity.getObservacion() : "");
    }


    private void enriquecerConDatosMaestros(CajaBancosResponse response) {
        if (response == null) {
            return;
        }
        
        // Enriquecer con código de cuenta bancaria
        if (response.getBancoCntaId() != null) {
            try {
                BancoCnta bancoCnta = bancoCntaRepository.findById(response.getBancoCntaId()).orElse(null);
                if (bancoCnta != null) {
                    response.setBancoCntaCodigo(bancoCnta.getCodigo());
                }
            } catch (Exception e) {
                log.warn("No se pudo obtener código de cuenta bancaria {}: {}", response.getBancoCntaId(), e.getMessage());
            }
        }
        
        // Enriquecer con código de moneda
        if (response.getMonedaId() != null) {
            try {
                var monedaResponse = coreMaestrosClient.obtenerMonedaPorId(response.getMonedaId());
                if (monedaResponse != null && monedaResponse.getData() != null) {
                    response.setMonedaCodigo(monedaResponse.getData().getCodigo());
                }
            } catch (Exception e) {
                log.warn("No se pudo obtener código de moneda {}: {}", response.getMonedaId(), e.getMessage());
            }
        }
        
        // Enriquecer con razón social de entidad contribuyente
        if (response.getEntidadContribuyenteId() != null) {
            try {
                var entidadResponse = coreMaestrosClient.obtenerEntidadPorId(response.getEntidadContribuyenteId());
                if (entidadResponse != null && entidadResponse.getData() != null) {
                    response.setEntidadRazonSocial(entidadResponse.getData().getRazonSocial());
                }
            } catch (Exception e) {
                log.warn("No se pudo obtener razón social de entidad {}: {}", response.getEntidadContribuyenteId(), e.getMessage());
            }
        }
    }

    /**
     * Extrae el mensaje de error del response body de una excepción Feign.
     * Intenta parsear el JSON y extraer el campo "message".
     * 
     * @param e Excepción de Feign
     * @return Mensaje de error extraído o mensaje genérico
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
            log.warn("No se pudo extraer mensaje de error de FeignException, intentando método alternativo", ex);
            
            try {
                String responseBody = e.contentUTF8();
                if (responseBody != null && responseBody.contains("\"message\"")) {
                    int startIndex = responseBody.indexOf("\"message\"") + 10;
                    startIndex = responseBody.indexOf("\"", startIndex) + 1;
                    int endIndex = responseBody.indexOf("\"", startIndex);
                    if (endIndex > startIndex) {
                        return responseBody.substring(startIndex, endIndex);
                    }
                }
            } catch (Exception ex2) {
                log.warn("Método alternativo también falló", ex2);
            }
        }
        
        return "Error al generar el asiento contable";
    }
}
