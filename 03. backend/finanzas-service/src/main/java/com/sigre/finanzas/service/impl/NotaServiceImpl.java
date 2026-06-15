package com.sigre.finanzas.service.impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.finanzas.client.ContabilidadClient;
import com.sigre.finanzas.client.CoreMaestrosClient;
import com.sigre.finanzas.dto.request.CntasPagarAsientoRequest;
import com.sigre.finanzas.dto.request.CntasPagarDetAsientoRequest;
import com.sigre.finanzas.dto.request.NotaDetalleRequest;
import com.sigre.finanzas.dto.request.NotaRequest;
import com.sigre.finanzas.dto.response.GenerarAsientoResponse;
import com.sigre.finanzas.dto.response.NotaResponse;
import com.sigre.finanzas.entity.CntasPagar;
import com.sigre.finanzas.entity.CntasPagarDet;
import com.sigre.finanzas.enums.TipoNota;
import com.sigre.finanzas.mapper.NotaDetalleMapper;
import com.sigre.finanzas.mapper.NotaMapper;
import com.sigre.finanzas.repository.CntasPagarRepository;
import com.sigre.finanzas.service.CntasPagarDetImpService;
import com.sigre.finanzas.service.NotaService;
import com.sigre.finanzas.service.FinanzasErrorCodes;
import com.sigre.finanzas.service.support.CntasPagarCabeceraValidator;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NotaServiceImpl implements NotaService {

    private final CntasPagarRepository repository;
    private final NotaMapper mapper;
    private final NotaDetalleMapper detalleMapper;
    private final ContabilidadClient contabilidadClient;
    private final CoreMaestrosClient coreMaestrosClient;
    private final CntasPagarCabeceraValidator cabeceraValidator;
    private final CntasPagarDetImpService detImpService;

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public Page<NotaResponse> listarNotas(Pageable pageable) {
        log.info("Listando notas débito/crédito");
        Page<CntasPagar> page = repository.findNotas(pageable);
        return page.map(mapper::toResponse);
    }

    @Override
    public NotaResponse obtenerNotaPorId(Long id) {
        log.info("Buscando nota con id: {}", id);
        CntasPagar cxp = repository.findNotaById(id)
            .orElseThrow(() -> {
                log.warn("Nota no encontrada con id: {}", id);
                return new ResourceNotFoundException("Nota", id);
            });
        return mapper.toResponse(cxp);
    }

    @Override
    @Transactional
    public NotaResponse crearNota(NotaRequest request) {
        log.info("Creando nota - tipo: {}, proveedor: {}, total: {}", 
            request.getTipoNota(), request.getProveedorId(), request.getTotal());
        
        validarRequest(request);
        
        Long sucursalId = TenantContext.getSucursalId();
        
        // Crear cabecera de la nota primero (sin asiento)
        CntasPagar cxp = mapper.toEntity(request, sucursalId, null);
        cxp.setFechaRegistro(LocalDate.now());
        cxp.setTasaCambio(obtenerTasaCambio(request.getFechaEmision(), request.getMonedaId()));
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
        cxp = repository.save(cxp);
        
        // Crear detalles
        for (NotaDetalleRequest detalleRequest : request.getDetalles()) {
            CntasPagarDet detalle = detalleMapper.toEntity(detalleRequest, cxp.getId());
            detalle.setCntasPagar(cxp);
            detalle.setCreatedBy(TenantContext.getUsuarioId());
            if (detalle.getCreditoFiscalId() == null) {
                detalle.setCreditoFiscalId(obtenerCreditoFiscalDefault());
            }
            cxp.addDetalle(detalle);
        }
        
        repository.save(cxp);

        for (int i = 0; i < request.getDetalles().size(); i++) {
            detImpService.guardarImpuestos(cxp.getDetalles().get(i), request.getDetalles().get(i).getImpuestos());
        }

        CntasPagarAsientoRequest asientoRequest = convertirCntasPagarAsientoRequest(cxp, request);
        GenerarAsientoResponse asientoResponse = contabilidadClient.generarAsientoRegistroCntasPagar(asientoRequest).getData();
        
        // Actualizar la nota con el ID del asiento
        cxp.setCntblAsientoId(asientoResponse.getAsientoId());
        cxp.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(cxp);
        
        log.info("Nota creada con id: {}, asiento: {}", cxp.getId(), asientoResponse.getAsientoId());
        return mapper.toResponse(cxp);
    }

    @Override
    @Transactional
    public NotaResponse anularNota(Long id) {
        log.info("Anulando nota id: {}", id);
        
        CntasPagar cxp = repository.findNotaById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Nota", id));
        
        if (!"1".equals(cxp.getFlagEstado())) {
            throw new BusinessException("Solo se pueden anular notas activas", 
                FinanzasErrorCodes.ESTADO_INVALIDO);
        }
        
        // Anular asiento contable
        if (cxp.getCntblAsientoId() != null) {
            try {
                contabilidadClient.anularAsiento(cxp.getCntblAsientoId());
            } catch (Exception e) {
                log.error("Error al anular asiento contable: {}", e.getMessage());
                throw new BusinessException("Error al anular asiento contable", 
                    FinanzasErrorCodes.CONTABILIDAD_INVALIDA);
            }
        }
        
        cxp.setFlagEstado("0");
        cxp.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(cxp);
        
        log.info("Nota anulada id: {}", id);
        
        NotaResponse response = new NotaResponse();
        response.setId(id);
        response.setFlagEstado("0");
        
        return response;
    }
    
    private void validarRequest(NotaRequest request) {
        // Validar duplicado por unique key (proveedor_id, doc_tipo_id, serie, numero)
        boolean existeDocumento = repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(
            request.getProveedorId(), request.getDocTipoId(), request.getSerie(), request.getNumero());
        if (existeDocumento) {
            throw new BusinessException(
                String.format("Ya existe un documento para el proveedor %d con tipo %d, serie %s y número %s", 
                    request.getProveedorId(), request.getDocTipoId(), request.getSerie(), request.getNumero()),
                FinanzasErrorCodes.DOCUMENTO_UNIQUE_KEY_DUPLICADO);
        }
        
        // Validar proveedor
        try {
            coreMaestrosClient.obtenerEntidadPorId(request.getProveedorId());
        } catch (Exception e) {
            throw new BusinessException("El proveedor especificado no existe", 
                FinanzasErrorCodes.PROVEEDOR_NO_ENCONTRADO);
        }
        
        // Validar tipo de documento
        try {
            coreMaestrosClient.obtenerDocTipoPorId(request.getDocTipoId());
        } catch (Exception e) {
            throw new BusinessException("El tipo de documento especificado no existe", 
                FinanzasErrorCodes.DOC_TIPO_NO_ENCONTRADO);
        }
        
        // Validar moneda
        try {
            coreMaestrosClient.obtenerMonedaPorId(request.getMonedaId());
        } catch (Exception e) {
            throw new BusinessException("La moneda especificada no existe", 
                FinanzasErrorCodes.MONEDA_NO_ENCONTRADA);
        }
        
        // Validar fechas
        if (request.getFechaVencimiento() != null && 
            request.getFechaVencimiento().isBefore(request.getFechaEmision())) {
            throw new BusinessException("La fecha de vencimiento no puede ser anterior a la fecha de emisión", 
                FinanzasErrorCodes.FECHA_VENCIMIENTO_INVALIDA);
        }

        cabeceraValidator.validar(request.getAno(), request.getMes(), request.getCntblLibroId());
        
        // Validar tipo de nota y detalles
        String tipoMovEsperado = request.getTipoNota() == TipoNota.DEBITO ? "NOTA_DEBITO" : "NOTA_CREDITO";
        for (NotaDetalleRequest detalle : request.getDetalles()) {
            if (!tipoMovEsperado.equals(detalle.getTipoMov())) {
                throw new BusinessException("Los detalles deben ser de tipo " + tipoMovEsperado, 
                    FinanzasErrorCodes.ESTADO_INVALIDO);
            }
        }
    }
    
    /**
     * Convierte una nota a CntasPagarAsientoRequest para el endpoint de contabilidad-service.
     * El asiento se genera automáticamente en contabilidad-service basado en los datos de la nota.
     * 
     * @param cxp Cuenta por pagar ya creada
     * @param request Request original de la nota
     * @return CntasPagarAsientoRequest para enviar a contabilidad-service
     */
    private CntasPagarAsientoRequest convertirCntasPagarAsientoRequest(CntasPagar cxp, NotaRequest request) {
        int item = 1;
        List<CntasPagarDetAsientoRequest> detalles = new ArrayList<>();
        for (NotaDetalleRequest detalle : request.getDetalles()) {
            detalles.add(CntasPagarDetAsientoRequest.builder()
                    .item(item++)
                    .conceptoFinancieroId(detalle.getConceptoFinancieroId())
                    .monto(detalle.getMonto())
                    .tipoMov(detalle.getTipoMov())
                    .referencia(detalle.getReferencia())
                    .glosa(detalle.getDescripcion())
                    .impuestos(detalle.getImpuestos())
                    .build());
        }

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
                .glosa("Nota " + request.getTipoNota() + " - " + cxp.getSerie() + "-" + cxp.getNumero())
                .detalles(detalles)
                .build();
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
