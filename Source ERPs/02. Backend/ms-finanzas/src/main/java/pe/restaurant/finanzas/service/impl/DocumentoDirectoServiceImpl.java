package pe.restaurant.finanzas.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.dto.request.DocumentoDirectoDetalleRequest;
import pe.restaurant.finanzas.dto.request.DocumentoDirectoRequest;
import pe.restaurant.finanzas.dto.response.DocumentoDirectoResponse;
import pe.restaurant.finanzas.entity.CntasPagar;
import pe.restaurant.finanzas.entity.CntasPagarDet;
import pe.restaurant.finanzas.mapper.DocumentoDirectoDetalleMapper;
import pe.restaurant.finanzas.mapper.DocumentoDirectoMapper;
import pe.restaurant.finanzas.repository.CntasPagarDetRepository;
import pe.restaurant.finanzas.repository.CntasPagarRepository;
import pe.restaurant.finanzas.service.CntasPagarDetImpService;
import pe.restaurant.finanzas.service.DocumentoDirectoService;
import pe.restaurant.finanzas.service.FinanzasErrorCodes;
import pe.restaurant.finanzas.service.support.CntasPagarCabeceraValidator;

import java.time.LocalDate;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DocumentoDirectoServiceImpl implements DocumentoDirectoService {

    private final CntasPagarRepository repository;
    private final CntasPagarDetRepository detalleRepository;
    private final DocumentoDirectoMapper mapper;
    private final DocumentoDirectoDetalleMapper detalleMapper;
    private final CoreMaestrosClient coreMaestrosClient;
    private final CntasPagarCabeceraValidator cabeceraValidator;
    private final CntasPagarDetImpService detImpService;

    @Override
    public Page<DocumentoDirectoResponse> listarDirectos(Pageable pageable) {
        log.info("Listando documentos directos");
        Page<CntasPagar> page = repository.findDocumentosDirectos(pageable);
        return page.map(mapper::toResponse);
    }

    @Override
    public DocumentoDirectoResponse obtenerDirectoPorId(Long id) {
        log.info("Buscando documento directo con id: {}", id);
        CntasPagar cxp = repository.findDocumentoDirectoById(id)
            .orElseThrow(() -> {
                log.warn("Documento directo no encontrado con id: {}", id);
                return new ResourceNotFoundException("Documento directo", id);
            });
        return mapper.toResponse(cxp);
    }

    @Override
    @Transactional
    public DocumentoDirectoResponse crearDirecto(DocumentoDirectoRequest request) {
        log.info("Creando documento directo - proveedor: {}, total: {}", 
            request.getProveedorId(), request.getTotal());
        
        validarRequest(request);
        
        Long sucursalId = TenantContext.getSucursalId();
        
        // Crear cabecera
        CntasPagar cxp = mapper.toEntity(request, sucursalId);
        cxp = repository.save(cxp);
        
        // Crear detalles
        for (DocumentoDirectoDetalleRequest detalleRequest : request.getDetalles()) {
            CntasPagarDet detalle = detalleMapper.toEntity(detalleRequest, cxp.getId());
            detalle.setCntasPagar(cxp);
            cxp.addDetalle(detalle);
        }

        repository.save(cxp);

        for (int i = 0; i < request.getDetalles().size(); i++) {
            detImpService.guardarImpuestos(cxp.getDetalles().get(i), request.getDetalles().get(i).getImpuestos());
        }

        log.info("Documento directo creado con id: {}", cxp.getId());
        return mapper.toResponse(cxp);
    }

    @Override
    @Transactional
    public DocumentoDirectoResponse actualizarDirecto(Long id, DocumentoDirectoRequest request) {
        log.info("Actualizando documento directo id: {}", id);
        
        CntasPagar cxp = repository.findDocumentoDirectoById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Documento directo", id));
        
        if (!"1".equals(cxp.getFlagEstado())) {
            throw new BusinessException("Solo se pueden modificar documentos activos", 
                FinanzasErrorCodes.ESTADO_INVALIDO);
        }
        
        // Validar que no tenga movimientos posteriores
        if (cxp.getDetalles().stream().anyMatch(d -> !"DIRECTO".equals(d.getTipoMov()))) {
            throw new BusinessException("No se puede modificar: documento tiene movimientos posteriores", 
                FinanzasErrorCodes.ESTADO_INVALIDO);
        }
        
        validarRequest(request);
        
        // Actualizar cabecera
        Long sucursalId = TenantContext.getSucursalId();
        CntasPagar cxpActualizado = mapper.toEntity(request, sucursalId);
        cxpActualizado.setId(id);
        cxpActualizado.setCreatedBy(cxp.getCreatedBy());
        cxpActualizado.setFecCreacion(cxp.getFecCreacion());
        
        // Limpiar detalles existentes
        cxp.getDetalles().clear();
        
        // Agregar nuevos detalles
        for (DocumentoDirectoDetalleRequest detalleRequest : request.getDetalles()) {
            CntasPagarDet detalle = detalleMapper.toEntity(detalleRequest, id);
            detalle.setCntasPagar(cxpActualizado);
            cxpActualizado.addDetalle(detalle);
        }
        
        cxpActualizado = repository.save(cxpActualizado);

        for (int i = 0; i < request.getDetalles().size(); i++) {
            detImpService.guardarImpuestos(cxpActualizado.getDetalles().get(i), request.getDetalles().get(i).getImpuestos());
        }

        log.info("Documento directo actualizado id: {}", id);
        return mapper.toResponse(cxpActualizado);
    }

    @Override
    @Transactional
    public DocumentoDirectoResponse anularDirecto(Long id) {
        log.info("Anulando documento directo id: {}", id);
        
        CntasPagar cxp = repository.findDocumentoDirectoById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Documento directo", id));
        
        if (!"1".equals(cxp.getFlagEstado())) {
            throw new BusinessException("Solo se pueden anular documentos activos", 
                FinanzasErrorCodes.ESTADO_INVALIDO);
        }
        
        cxp.setFlagEstado("0");
        repository.save(cxp);
        
        log.info("Documento directo anulado id: {}", id);
        
        DocumentoDirectoResponse response = new DocumentoDirectoResponse();
        response.setId(id);
        response.setFlagEstado("0");
        
        return response;
    }
    
    private void validarRequest(DocumentoDirectoRequest request) {
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
        
        // Validar que todos los detalles sean de tipo DIRECTO
        for (DocumentoDirectoDetalleRequest detalle : request.getDetalles()) {
            if (!"DIRECTO".equals(detalle.getTipoMov())) {
                throw new BusinessException("Todos los detalles deben ser de tipo DIRECTO", 
                    FinanzasErrorCodes.ESTADO_INVALIDO);
            }
        }
    }
}
