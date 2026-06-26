package pe.restaurant.finanzas.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.finanzas.dto.request.CerrarEnBloqueRequest;
import pe.restaurant.finanzas.dto.request.LiquidacionDetalleRequest;
import pe.restaurant.finanzas.dto.request.LiquidacionRequest;
import pe.restaurant.finanzas.dto.response.BatchResultItem;
import pe.restaurant.finanzas.dto.response.LiquidacionDetalleResponse;
import pe.restaurant.finanzas.dto.response.LiquidacionResponse;
import pe.restaurant.finanzas.dto.response.ValidacionCierreResponse;
import pe.restaurant.finanzas.entity.Liquidacion;
import pe.restaurant.finanzas.entity.LiquidacionDet;
import pe.restaurant.finanzas.entity.SolicitudGiro;
import pe.restaurant.finanzas.mapper.LiquidacionDetMapper;
import pe.restaurant.finanzas.mapper.LiquidacionMapper;
import pe.restaurant.finanzas.repository.LiquidacionDetRepository;
import pe.restaurant.finanzas.repository.LiquidacionRepository;
import pe.restaurant.finanzas.repository.SolicitudGiroRepository;
import pe.restaurant.common.service.NumeradorDocumentoService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class LiquidacionService {

    private final LiquidacionRepository repository;
    private final LiquidacionDetRepository detRepository;
    private final SolicitudGiroRepository solicitudGiroRepository;
    private final LiquidacionMapper mapper;
    private final LiquidacionDetMapper detMapper;
    private final NumeradorDocumentoService numeradorDocumentoService;
    private final PermisoCierreValidator permisoValidator;

    @Transactional(readOnly = true)
    public Page<LiquidacionResponse> listarLiquidaciones(Pageable pageable) {
        Page<Liquidacion> page = repository.findAll(pageable);
        return page.map(mapper::toResponse);
    }

    @Transactional(readOnly = true)
    public LiquidacionDetalleResponse obtenerPorId(Long id) {
        Liquidacion entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));
        return mapper.toDetalleResponse(entity);
    }

    @Transactional
    public LiquidacionDetalleResponse crearLiquidacion(LiquidacionRequest request) {
        validarSolicitudGiro(request.getSolicitudGiroId());
        validarCuadreDetalles(request);
        
        Long sucursalId = request.getSucursalId() != null ? request.getSucursalId() : 
            pe.restaurant.common.security.TenantContext.getSucursalId();
        
        Long usuarioId = pe.restaurant.common.security.TenantContext.getUsuarioId();
        
        Liquidacion entity = mapper.toEntity(request);
        
        // Generar número automáticamente solo si no viene del request
        if (entity.getNroLiquidacion() == null || entity.getNroLiquidacion().isEmpty()) {
            String nroLiquidacion = numeradorDocumentoService.siguienteNroDocumento(
                "finanzas.liquidacion",
                sucursalId,
                LocalDate.now().getYear()
            );
            entity.setNroLiquidacion(nroLiquidacion);
        }
        entity.setFechaRegistro(LocalDate.now());
        
        // Establecer campos de auditoría
        entity.setCreatedBy(usuarioId);
        entity.setUpdatedBy(usuarioId);
        
        Liquidacion saved = repository.save(entity);
        
        for (LiquidacionDetalleRequest detalleReq : request.getDetalles()) {
            LiquidacionDet detalle = detMapper.toEntity(detalleReq);
            // La moneda de cada línea siempre es la de la cabecera de la liquidación.
            detalle.setMonedaId(saved.getMonedaId());
            detalle.setCreatedBy(usuarioId);
            detalle.setUpdatedBy(usuarioId);
            saved.addDetalle(detalle);
        }
        
        repository.save(saved);
        
        return mapper.toDetalleResponse(saved);
    }

    @Transactional
    public LiquidacionDetalleResponse actualizarLiquidacion(Long id, LiquidacionRequest request) {
        Liquidacion entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));
        
        // Editable si está Activa(1) o si fue Observada(3) por el aprobador (HU-FIN-OPE-004, 6.7):
        // la observación devuelve la liquidación a edición para que se corrija.
        if (!"1".equals(entity.getFlagEstado()) && !"3".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                "Solo se pueden actualizar liquidaciones activas u observadas",
                FinanzasErrorCodes.LIQUIDACION_ESTADO_INVALIDO
            );
        }

        validarCuadreDetalles(request);
        
        Long usuarioId = pe.restaurant.common.security.TenantContext.getUsuarioId();
        
        boolean estabaObservada = "3".equals(entity.getFlagEstado());

        mapper.updateEntity(entity, request);
        entity.setUpdatedBy(usuarioId);

        // HU-FIN-OPE-004 (6.7): al corregir una liquidación observada, vuelve a Pendiente
        // para que el aprobador la reevalúe.
        if (estabaObservada) {
            entity.setFlagEstado("1");
        }

        // Limpiar detalles existentes y forzar flush para evitar conflictos de unicidad
        entity.clearDetalles();
        repository.saveAndFlush(entity);
        
        // Agregar nuevos detalles
        for (LiquidacionDetalleRequest detalleReq : request.getDetalles()) {
            LiquidacionDet detalle = detMapper.toEntity(detalleReq);
            // La moneda de cada línea siempre es la de la cabecera de la liquidación.
            detalle.setMonedaId(entity.getMonedaId());
            detalle.setCreatedBy(usuarioId);
            detalle.setUpdatedBy(usuarioId);
            entity.addDetalle(detalle);
        }
        
        repository.save(entity);
        
        return mapper.toDetalleResponse(entity);
    }

    @Transactional
    public Map<String, Object> anularLiquidacion(Long id) {
        Liquidacion entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));
        
        if ("2".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                "No se puede anular una liquidación cerrada",
                FinanzasErrorCodes.LIQUIDACION_ESTADO_INVALIDO
            );
        }
        
        entity.setFlagEstado("0");
        entity.setUpdatedBy(pe.restaurant.common.security.TenantContext.getUsuarioId());
        repository.save(entity);
        
        Map<String, Object> response = new HashMap<>();
        response.put("id", entity.getId());
        response.put("flagEstado", entity.getFlagEstado());
        
        return response;
    }

    @Transactional(readOnly = true)
    public ValidacionCierreResponse validarCierre(Long id) {
        Liquidacion entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));
        
        BigDecimal sumaDetalles = detRepository.calcularSumaImportes(id);
        if (sumaDetalles == null) {
            sumaDetalles = BigDecimal.ZERO;
        }
        
        boolean cuadrado = entity.getImporteNeto().compareTo(sumaDetalles) == 0;
        // Activa(1) o Aprobada(4) pueden cerrarse contablemente (HU-FIN-OPE-004 habilita el cierre).
        boolean estadoCerrable = "1".equals(entity.getFlagEstado()) || "4".equals(entity.getFlagEstado());
        boolean puedeCerrar = estadoCerrable && cuadrado;
        
        SolicitudGiro solicitudGiro = solicitudGiroRepository.findById(entity.getSolicitudGiroId())
            .orElse(null);
        
        ValidacionCierreResponse response = new ValidacionCierreResponse();
        response.setId(entity.getId());
        response.setNroLiquidacion(entity.getNroLiquidacion());
        response.setImporteNeto(entity.getImporteNeto());
        response.setSumaDetalles(sumaDetalles);
        response.setCuadrado(cuadrado);
        response.setSolicitudGiroId(entity.getSolicitudGiroId());
        response.setSolicitudGiroNumero(solicitudGiro != null ? solicitudGiro.getNumero() : null);
        response.setPuedeCerrar(puedeCerrar);
        
        return response;
    }

    @Transactional
    public LiquidacionDetalleResponse cerrarLiquidacion(Long id, String observacion) {
        Liquidacion entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));
        
        if (!"1".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                "Solo se pueden cerrar liquidaciones activas",
                FinanzasErrorCodes.LIQUIDACION_ESTADO_INVALIDO
            );
        }
        
        BigDecimal sumaDetalles = detRepository.calcularSumaImportes(id);
        if (sumaDetalles == null) {
            sumaDetalles = BigDecimal.ZERO;
        }
        
        if (entity.getImporteNeto().compareTo(sumaDetalles) != 0) {
            throw new BusinessException(
                "Los detalles no cuadran con el importe neto",
                FinanzasErrorCodes.LIQUIDACION_TOTALES_NO_CUADRAN
            );
        }
        
        entity.setFlagEstado("2");
        if (observacion != null && !observacion.isEmpty()) {
            entity.setObservacion(observacion);
        }
        entity.setUpdatedBy(pe.restaurant.common.security.TenantContext.getUsuarioId());
        repository.save(entity);

        return mapper.toDetalleResponse(entity);
    }

    /**
     * Cierra una liquidación activa estampando además la fecha de cierre en la
     * columna existente {@code finanzas.liquidacion.fecha_liquidacion}, que el cierre
     * tradicional ({@link #cerrarLiquidacion(Long, String)}) no persiste.
     * Se mantiene como método independiente para no alterar el flujo de cierre vigente.
     */
    @Transactional
    public LiquidacionDetalleResponse cerrarLiquidacionConFecha(Long id, LocalDate fechaLiquidacion, String observacion) {
        permisoValidator.validar(PermisoCierreValidator.ACCION_CERRAR);

        Liquidacion entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));

        if (!"1".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                "Solo se pueden cerrar liquidaciones activas",
                FinanzasErrorCodes.LIQUIDACION_ESTADO_INVALIDO
            );
        }

        BigDecimal sumaDetalles = detRepository.calcularSumaImportes(id);
        if (sumaDetalles == null) {
            sumaDetalles = BigDecimal.ZERO;
        }

        if (entity.getImporteNeto().compareTo(sumaDetalles) != 0) {
            throw new BusinessException(
                "Los detalles no cuadran con el importe neto",
                FinanzasErrorCodes.LIQUIDACION_TOTALES_NO_CUADRAN
            );
        }

        entity.setFlagEstado("2");
        entity.setFechaLiquidacion(fechaLiquidacion);
        if (observacion != null && !observacion.isEmpty()) {
            entity.setObservacion(observacion);
        }
        entity.setUpdatedBy(pe.restaurant.common.security.TenantContext.getUsuarioId());
        repository.save(entity);

        return mapper.toDetalleResponse(entity);
    }

    @Transactional
    public List<BatchResultItem> cerrarEnBloque(CerrarEnBloqueRequest request) {
        List<BatchResultItem> resultados = new ArrayList<>();

        for (Long id : request.getIds()) {
            try {
                cerrarLiquidacion(id, request.getObservacion());
                resultados.add(BatchResultItem.builder()
                    .id(id)
                    .exito(true)
                    .mensaje("Liquidación cerrada exitosamente")
                    .build());
            } catch (ResourceNotFoundException e) {
                resultados.add(BatchResultItem.builder()
                    .id(id)
                    .exito(false)
                    .mensaje("Liquidación no encontrada: " + e.getMessage())
                    .build());
            } catch (BusinessException e) {
                resultados.add(BatchResultItem.builder()
                    .id(id)
                    .exito(false)
                    .mensaje(e.getMessage())
                    .build());
            }
        }

        return resultados;
    }

    private void validarSolicitudGiro(Long solicitudGiroId) {
        SolicitudGiro solicitudGiro = solicitudGiroRepository.findById(solicitudGiroId)
            .orElseThrow(() -> new ResourceNotFoundException("SolicitudGiro", solicitudGiroId));
        
        // La solicitud de giro debe estar activa/aprobada (flag_estado = "1") para liquidarse.
        if (!"1".equals(solicitudGiro.getFlagEstado())) {
            throw new BusinessException(
                "La solicitud de giro no está activa",
                FinanzasErrorCodes.SOLICITUD_GIRO_INACTIVA
            );
        }
    }

    private void validarCuadreDetalles(LiquidacionRequest request) {
        BigDecimal sumaDetalles = request.getDetalles().stream()
            .map(det -> {
                BigDecimal importe = det.getImporte();
                Short factor = det.getFactorSigno();
                if (factor != null) {
                    return importe.multiply(BigDecimal.valueOf(factor));
                }
                return importe;
            })
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        if (request.getImporteNeto().compareTo(sumaDetalles) != 0) {
            throw new BusinessException(
                "La suma de los detalles no cuadra con el importe neto",
                FinanzasErrorCodes.LIQUIDACION_TOTALES_NO_CUADRAN
            );
        }
    }
}
