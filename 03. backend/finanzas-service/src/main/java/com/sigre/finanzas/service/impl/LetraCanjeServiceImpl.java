package com.sigre.finanzas.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.common.service.NumeradorDocumentoService;
import com.sigre.common.service.NumeradorDocumentoService.DocumentoSerieNumero;
import com.sigre.finanzas.domain.CntasPagarFlagEstado;
import com.sigre.finanzas.dto.request.DestinoCanjeRequest;
import com.sigre.finanzas.dto.request.DetImpuestoRequest;
import com.sigre.finanzas.dto.request.LetraCanjeRequest;
import com.sigre.finanzas.dto.response.LetraCanjeDetalleResponse;
import com.sigre.finanzas.dto.response.LetraCanjeResponse;
import com.sigre.finanzas.entity.CntasPagar;
import com.sigre.finanzas.entity.CntasPagarDet;
import com.sigre.finanzas.entity.ConceptoFinanciero;
import com.sigre.finanzas.enums.TipoMovimientoCxP;
import com.sigre.finanzas.mapper.LetraCanjeMapper;
import com.sigre.finanzas.repository.CntasPagarDetRepository;
import com.sigre.finanzas.repository.CntasPagarRepository;
import com.sigre.finanzas.repository.ConceptoFinancieroRepository;
import com.sigre.finanzas.service.CntasPagarDetImpService;
import com.sigre.finanzas.service.FinanzasErrorCodes;
import com.sigre.finanzas.service.LetraCanjeService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class LetraCanjeServiceImpl implements LetraCanjeService {

    /**
     * Concepto de catálogo usado en líneas generadas por el motor de canje (alineado a seed CF004).
     */
    private static final String CONCEPTO_DETALLE_CANJE_CODIGO = "CF004";

    private final CntasPagarRepository cntasPagarRepository;
    private final CntasPagarDetRepository cntasPagarDetRepository;
    private final ConceptoFinancieroRepository conceptoFinancieroRepository;
    private final LetraCanjeMapper mapper;
    private final NumeradorDocumentoService numeradorDocumentoService;
    private final CntasPagarDetImpService detImpService;

    @Override
    public Page<LetraCanjeResponse> listarCanjes(String referencia, Long proveedorId,
                                                  LocalDate fechaDesde, LocalDate fechaHasta,
                                                  Pageable pageable) {
        log.info("Listando canjes - referencia: {}, proveedorId: {}", referencia, proveedorId);
        
        List<CntasPagarDet> detalles;
        
        if (referencia != null && !referencia.isBlank()) {
            detalles = cntasPagarDetRepository.findByReferenciaAndTipoMov(
                referencia, TipoMovimientoCxP.CANJE_ORIGEN.name());
        } else {
            detalles = cntasPagarDetRepository.findByTipoMov(
                TipoMovimientoCxP.CANJE_ORIGEN.name());
        }
        
        Map<String, List<CntasPagar>> canjesPorReferencia = new HashMap<>();
        
        for (CntasPagarDet detalle : detalles) {
            if (detalle.getReferencia() != null) {
                String ref = detalle.getReferencia();
                if (!canjesPorReferencia.containsKey(ref)) {
                    List<CntasPagar> origenes = cntasPagarRepository.findOrigenesCanjeByReferencia(ref);
                    if (!origenes.isEmpty()) {
                        if (proveedorId == null || origenes.get(0).getProveedorId().equals(proveedorId)) {
                            canjesPorReferencia.put(ref, origenes);
                        }
                    }
                }
            }
        }
        
        List<LetraCanjeResponse> responses = canjesPorReferencia.entrySet().stream()
            .map(entry -> {
                String ref = entry.getKey();
                List<CntasPagar> origenes = entry.getValue();
                List<CntasPagar> destinos = cntasPagarRepository.findDestinosCanjeByReferencia(ref);
                return mapper.toResponse(ref, origenes, destinos);
            })
            .collect(Collectors.toList());
        
        int start = (int) pageable.getOffset();
        int end = Math.min((start + pageable.getPageSize()), responses.size());
        
        if (start > responses.size()) {
            return new PageImpl<>(new ArrayList<>(), pageable, responses.size());
        }
        
        return new PageImpl<>(responses.subList(start, end), pageable, responses.size());
    }

    @Override
    public LetraCanjeDetalleResponse obtenerCanjePorReferencia(String referencia) {
        log.info("Obteniendo detalle de canje - referencia: {}", referencia);
        
        List<CntasPagar> origenes = cntasPagarRepository.findOrigenesCanjeByReferencia(referencia);
        List<CntasPagar> destinos = cntasPagarRepository.findDestinosCanjeByReferencia(referencia);
        
        if (origenes.isEmpty() && destinos.isEmpty()) {
            throw new ResourceNotFoundException("Canje", "referencia", referencia);
        }
        
        return mapper.toDetalleResponse(referencia, origenes, destinos);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "cntas_pagar", "operation", "canje"})
    @Override
    @Transactional
    public LetraCanjeDetalleResponse ejecutarCanje(LetraCanjeRequest request) {
        log.info("Ejecutando canje - referencia: {}, proveedor: {}", 
            request.getReferencia(), request.getProveedorId());
        
        validarReferenciaUnica(request.getReferencia());
        
        List<CntasPagar> origenes = cargarDocumentosOrigen(request);
        
        validarCoherenciaProveedor(origenes, request.getProveedorId());
        validarCoherenciaMoneda(origenes, request.getDestinos());
        validarEstadosDocumentos(origenes);
        validarSaldosSuficientes(origenes, request.getOrigenes());
        
        BigDecimal totalOrigenes = calcularTotalOrigenes(request.getOrigenes());
        BigDecimal totalDestinos = calcularTotalDestinos(request.getDestinos());
        validarBalanceMontos(totalOrigenes, totalDestinos);
        validarFechasVencimiento(request.getFechaCanje(), request.getDestinos());
        
        Map<Long, BigDecimal> montosCanjeadosPorOrigen = request.getOrigenes().stream()
            .collect(Collectors.toMap(
                o -> o.getCntasPagarId(),
                o -> o.getMontoCanjeado()
            ));
        
        for (CntasPagar origen : origenes) {
            BigDecimal montoCanjeado = montosCanjeadosPorOrigen.get(origen.getId());
            procesarOrigenCanje(origen, montoCanjeado, request.getFechaCanje(), request.getReferencia());
        }
        
        List<CntasPagar> destinos = new ArrayList<>();
        for (DestinoCanjeRequest destinoReq : request.getDestinos()) {
            CntasPagar destino = crearDestinoDocumento(
                destinoReq, 
                request.getProveedorId(), 
                request.getFechaCanje(), 
                request.getReferencia()
            );
            destinos.add(destino);
        }
        
        log.info("Canje ejecutado exitosamente - referencia: {}", request.getReferencia());
        return mapper.toDetalleResponse(request.getReferencia(), origenes, destinos);
    }

    @Override
    @Transactional
    public LetraCanjeDetalleResponse anularCanje(String referencia) {
        log.info("Anulando canje - referencia: {}", referencia);
        
        validarCanjeReversible(referencia);
        
        List<CntasPagar> origenes = cntasPagarRepository.findOrigenesCanjeByReferencia(referencia);
        List<CntasPagar> destinos = cntasPagarRepository.findDestinosCanjeByReferencia(referencia);
        
        if (origenes.isEmpty() && destinos.isEmpty()) {
            throw new ResourceNotFoundException("Canje", "referencia", referencia);
        }
        
        for (CntasPagar destino : destinos) {
            destino.setFlagEstado(CntasPagarFlagEstado.ANULADO);
            cntasPagarRepository.save(destino);
            
            List<CntasPagarDet> detallesDestino = cntasPagarDetRepository
                .findByCntasPagarIdOrderByFechaMovAsc(destino.getId());
            for (CntasPagarDet det : detallesDestino) {
                det.setFlagEstado(CntasPagarFlagEstado.ANULADO);
                cntasPagarDetRepository.save(det);
            }
        }
        
        for (CntasPagar origen : origenes) {
            restaurarSaldoOrigen(origen, referencia);
        }
        
        log.info("Canje anulado exitosamente - referencia: {}", referencia);
        return mapper.toDetalleResponse(referencia, origenes, destinos);
    }

    private void validarReferenciaUnica(String referencia) {
        if (cntasPagarRepository.existsByDetalles_Referencia(referencia)) {
            throw new BusinessException(
                "Ya existe un canje con la referencia: " + referencia,
                FinanzasErrorCodes.CANJE_REFERENCIA_DUPLICADA
            );
        }
    }

    private List<CntasPagar> cargarDocumentosOrigen(LetraCanjeRequest request) {
        List<CntasPagar> origenes = new ArrayList<>();
        for (var origenReq : request.getOrigenes()) {
            CntasPagar origen = cntasPagarRepository.findById(origenReq.getCntasPagarId())
                .orElseThrow(() -> new ResourceNotFoundException(
                    "Documento origen no encontrado", origenReq.getCntasPagarId()));
            origenes.add(origen);
        }
        return origenes;
    }

    private void validarCoherenciaProveedor(List<CntasPagar> origenes, Long proveedorId) {
        for (CntasPagar origen : origenes) {
            if (!origen.getProveedorId().equals(proveedorId)) {
                throw new BusinessException(
                    "Todos los documentos deben ser del mismo proveedor",
                    FinanzasErrorCodes.CANJE_PROVEEDOR_INCOHERENTE
                );
            }
        }
    }

    private void validarCoherenciaMoneda(List<CntasPagar> origenes, List<DestinoCanjeRequest> destinos) {
        if (origenes.isEmpty()) {
            return;
        }
        
        Long monedaOrigen = origenes.get(0).getMonedaId();
        
        for (CntasPagar origen : origenes) {
            if (!origen.getMonedaId().equals(monedaOrigen)) {
                throw new BusinessException(
                    "Todos los documentos origen deben estar en la misma moneda",
                    FinanzasErrorCodes.CANJE_MONEDA_INCOHERENTE
                );
            }
        }
        
        for (DestinoCanjeRequest destino : destinos) {
            if (destino.getMonedaId() != null && !destino.getMonedaId().equals(monedaOrigen)) {
                throw new BusinessException(
                    "Todos los documentos destino deben estar en la misma moneda que los orígenes",
                    FinanzasErrorCodes.CANJE_MONEDA_INCOHERENTE
                );
            }
        }
    }

    private void validarBalanceMontos(BigDecimal totalOrigenes, BigDecimal totalDestinos) {
        if (totalOrigenes.compareTo(totalDestinos) != 0) {
            throw new BusinessException(
                String.format("La suma de destinos (%.2f) debe ser igual al monto canjeado de orígenes (%.2f)",
                    totalDestinos, totalOrigenes),
                FinanzasErrorCodes.CANJE_MONTO_NO_COINCIDE
            );
        }
    }

    private void validarSaldosSuficientes(List<CntasPagar> origenes, List<com.sigre.finanzas.dto.request.OrigenCanjeRequest> origenesReq) {
        Map<Long, BigDecimal> montosCanjeados = origenesReq.stream()
            .collect(Collectors.toMap(
                o -> o.getCntasPagarId(),
                o -> o.getMontoCanjeado()
            ));
        
        for (CntasPagar origen : origenes) {
            BigDecimal montoCanjeado = montosCanjeados.get(origen.getId());
            if (origen.getSaldo().compareTo(montoCanjeado) < 0) {
                throw new BusinessException(
                    String.format("El documento %s-%s no tiene saldo suficiente. Saldo: %.2f, Monto a canjear: %.2f",
                        origen.getSerie(), origen.getNumero(), origen.getSaldo(), montoCanjeado),
                    FinanzasErrorCodes.CANJE_SALDO_INSUFICIENTE
                );
            }
        }
    }

    private void validarEstadosDocumentos(List<CntasPagar> origenes) {
        for (CntasPagar origen : origenes) {
            if (!CntasPagarFlagEstado.ACTIVO.equals(origen.getFlagEstado())) {
                throw new BusinessException(
                    String.format("El documento %s-%s está inactivo y no puede ser canjeado",
                        origen.getSerie(), origen.getNumero()),
                    FinanzasErrorCodes.CANJE_ESTADO_INVALIDO
                );
            }
            
            if (CntasPagarFlagEstado.ANULADO.equals(origen.getFlagEstado())) {
                throw new BusinessException(
                    String.format("El documento %s-%s está anulado y no puede ser canjeado",
                        origen.getSerie(), origen.getNumero()),
                    FinanzasErrorCodes.CANJE_ESTADO_INVALIDO
                );
            }
        }
    }

    private Long idConceptoDetalleCanje() {
        return conceptoFinancieroRepository.findByCodigoIgnoreCase(CONCEPTO_DETALLE_CANJE_CODIGO)
            .map(ConceptoFinanciero::getId)
            .orElseThrow(() -> new BusinessException(
                "Debe existir en catálogo el concepto financiero "
                    + CONCEPTO_DETALLE_CANJE_CODIGO
                    + " para registrar movimientos de canje",
                FinanzasErrorCodes.CONCEPTO_FINANCIERO_CANJE_REQUERIDO));
    }

    private void validarFechasVencimiento(LocalDate fechaCanje, List<DestinoCanjeRequest> destinos) {
        for (DestinoCanjeRequest destino : destinos) {
            if (destino.getFechaVencimiento() != null && 
                destino.getFechaVencimiento().isBefore(fechaCanje)) {
                throw new BusinessException(
                    "La fecha de vencimiento no puede ser anterior a la fecha de canje",
                    FinanzasErrorCodes.CANJE_FECHA_INVALIDA
                );
            }
        }
    }

    private void validarCanjeReversible(String referencia) {
        List<CntasPagar> destinos = cntasPagarRepository.findDestinosCanjeByReferencia(referencia);
        
        for (CntasPagar destino : destinos) {
            if (destino.getSaldo().compareTo(destino.getTotal()) != 0) {
                throw new BusinessException(
                    String.format("El documento destino %s-%s tiene pagos aplicados y no puede ser anulado",
                        destino.getSerie(), destino.getNumero()),
                    FinanzasErrorCodes.CANJE_NO_REVERSIBLE
                );
            }
        }
    }

    private BigDecimal calcularTotalOrigenes(List<com.sigre.finanzas.dto.request.OrigenCanjeRequest> origenes) {
        return origenes.stream()
            .map(com.sigre.finanzas.dto.request.OrigenCanjeRequest::getMontoCanjeado)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private BigDecimal calcularTotalDestinos(List<DestinoCanjeRequest> destinos) {
        return destinos.stream()
            .map(DestinoCanjeRequest::getTotal)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private void procesarOrigenCanje(CntasPagar origen, BigDecimal montoCanjeado, 
                                     LocalDate fechaCanje, String referencia) {
        // Obtener el primer detalle del documento origen para heredar valores obligatorios
        List<CntasPagarDet> detallesOrigen = cntasPagarDetRepository
            .findByCntasPagarIdOrderByFechaMovAsc(origen.getId());
        
        if (detallesOrigen.isEmpty()) {
            throw new BusinessException(
                "El documento origen no tiene detalles para heredar valores",
                FinanzasErrorCodes.CANJE_DOCUMENTO_SIN_DETALLES
            );
        }
        
        CntasPagarDet primerDetalle = detallesOrigen.get(0);
        
        CntasPagarDet detalle = new CntasPagarDet();
        detalle.setCntasPagar(origen);
        detalle.setItem(obtenerSiguienteItem(origen.getId()));
        detalle.setDescripcion("Canje de documento");
        detalle.setCantidad(BigDecimal.ONE);
        detalle.setPrecioUnitario(montoCanjeado);
        detalle.setCentrosCostoId(primerDetalle.getCentrosCostoId());
        detalle.setFechaMov(fechaCanje);
        detalle.setTipoMov(TipoMovimientoCxP.CANJE_ORIGEN.name());
        detalle.setMonto(montoCanjeado);
        detalle.setReferencia(referencia);
        detalle.setConceptoFinancieroId(idConceptoDetalleCanje());
        detalle.setFlagEstado(CntasPagarFlagEstado.ACTIVO);
        detalle.setCreatedBy(TenantContext.getUsuarioId());
        detalle.setFecCreacion(java.time.Instant.now());
        
        CntasPagarDet savedDetalle = cntasPagarDetRepository.save(detalle);
        copiarImpuestosDesdeDetalle(savedDetalle, primerDetalle.getId());

        BigDecimal nuevoSaldo = origen.getSaldo().subtract(montoCanjeado);
        origen.setSaldo(nuevoSaldo);
        
        actualizarEstadoDocumento(origen);
        cntasPagarRepository.save(origen);
    }

    /**
     * Crea un nuevo documento destino (letra) en el canje.
     * Genera automáticamente el número de documento usando el numerador SUNAT para evitar duplicados.
     * La serie viene del request pero el número se genera automáticamente desde core.doc_tipo_num_serie.
     * 
     * @param destino Request con datos del documento destino (tipo, serie, fechas, monto)
     * @param proveedorId ID del proveedor al que pertenece la letra
     * @param fechaCanje Fecha en que se ejecuta el canje
     * @param referencia Referencia única del canje para trazabilidad
     * @return Documento CntasPagar creado y persistido con su detalle inicial
     */
    private CntasPagar crearDestinoDocumento(DestinoCanjeRequest destino, Long proveedorId,
                                             LocalDate fechaCanje, String referencia) {
        Long sucursalId = TenantContext.getSucursalId();
        log.info("Creando destino documento - sucursalId desde TenantContext: {}", sucursalId);
        
        DocumentoSerieNumero numeroGenerado = numeradorDocumentoService.siguienteNroDocumentoSunat(
            destino.getDocTipoId(),
            destino.getSerie(),
            sucursalId
        );
        
        log.info("Generando letra de canje - serie: {}, número: {}", 
            numeroGenerado.serie(), numeroGenerado.numero());
        
        CntasPagar nuevoCxP = new CntasPagar();
        nuevoCxP.setSucursalId(sucursalId);
        nuevoCxP.setProveedorId(proveedorId);
        nuevoCxP.setDocTipoId(destino.getDocTipoId());
        nuevoCxP.setSerie(numeroGenerado.serie());
        nuevoCxP.setNumero(numeroGenerado.numero());
        nuevoCxP.setFechaEmision(destino.getFechaEmision());
        nuevoCxP.setFechaVencimiento(destino.getFechaVencimiento());
        nuevoCxP.setMonedaId(destino.getMonedaId());
        nuevoCxP.setTotal(destino.getTotal());
        nuevoCxP.setSaldo(destino.getTotal());
        nuevoCxP.setFlagEstado(CntasPagarFlagEstado.ACTIVO);
        nuevoCxP.setCreatedBy(TenantContext.getUsuarioId());
        
        nuevoCxP = cntasPagarRepository.save(nuevoCxP);
        
        CntasPagarDet detalle = new CntasPagarDet();
        detalle.setCntasPagar(nuevoCxP);
        detalle.setItem(1);
        detalle.setDescripcion("Letra generada por canje");
        detalle.setCantidad(BigDecimal.ONE);
        detalle.setPrecioUnitario(destino.getTotal());
        detalle.setCentrosCostoId(obtenerCentroCostoDefault());
        detalle.setFechaMov(fechaCanje);
        detalle.setTipoMov(TipoMovimientoCxP.CANJE_DESTINO.name());
        detalle.setMonto(destino.getTotal());
        detalle.setReferencia(referencia);
        detalle.setConceptoFinancieroId(idConceptoDetalleCanje());
        detalle.setFlagEstado(CntasPagarFlagEstado.ACTIVO);
        detalle.setCreatedBy(TenantContext.getUsuarioId());
        detalle.setFecCreacion(java.time.Instant.now());
        
        cntasPagarDetRepository.save(detalle);
        
        return nuevoCxP;
    }

    /**
     * Obtiene el siguiente número de item para un documento.
     * Busca el máximo item existente y suma 1.
     * 
     * @param cntasPagarId ID del documento
     * @return Siguiente número de item disponible
     */
    private Integer obtenerSiguienteItem(Long cntasPagarId) {
        List<CntasPagarDet> detalles = cntasPagarDetRepository
            .findByCntasPagarIdOrderByFechaMovAsc(cntasPagarId);
        
        if (detalles.isEmpty()) {
            return 1;
        }
        
        return detalles.stream()
            .map(CntasPagarDet::getItem)
            .max(Integer::compareTo)
            .orElse(0) + 1;
    }

    private void copiarImpuestosDesdeDetalle(CntasPagarDet destino, Long detalleOrigenId) {
        List<DetImpuestoRequest> impuestos = detImpService.listarPorDetalle(detalleOrigenId).stream()
                .map(r -> new DetImpuestoRequest(r.getTiposImpuestoId(), r.getImporte()))
                .toList();
        detImpService.guardarImpuestos(destino, impuestos);
    }

    /**
     * Obtiene el centro de costo por defecto.
     * En un canje de letras, se usa un centro de costo genérico.
     * 
     * @return ID del centro de costo default (1L representa el centro genérico)
     */
    private Long obtenerCentroCostoDefault() {
        return 1L;
    }

    /**
     * Actualiza el flag_estado del documento según su saldo.
     * En canje, el documento origen siempre permanece ACTIVO aunque su saldo sea cero,
     * ya que el canje no anula el documento, solo reduce su saldo.
     * 
     * @param documento Documento a actualizar
     */
    private void actualizarEstadoDocumento(CntasPagar documento) {
        // En canje, el documento origen siempre permanece activo
        // El saldo puede ser cero (totalmente canjeado) o parcial
        documento.setFlagEstado(CntasPagarFlagEstado.ACTIVO);
    }

    private void restaurarSaldoOrigen(CntasPagar origen, String referencia) {
        List<CntasPagarDet> detallesCanje = cntasPagarDetRepository
            .findByReferenciaAndTipoMov(referencia, TipoMovimientoCxP.CANJE_ORIGEN.name());
        
        for (CntasPagarDet detalle : detallesCanje) {
            if (detalle.getCntasPagar().getId().equals(origen.getId())) {
                detalle.setFlagEstado(CntasPagarFlagEstado.ANULADO);
                cntasPagarDetRepository.save(detalle);
                
                BigDecimal saldoRestaurado = origen.getSaldo().add(detalle.getMonto());
                origen.setSaldo(saldoRestaurado);
                actualizarEstadoDocumento(origen);
                cntasPagarRepository.save(origen);
            }
        }
    }
}
