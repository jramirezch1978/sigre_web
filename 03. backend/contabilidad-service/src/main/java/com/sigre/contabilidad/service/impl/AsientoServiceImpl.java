package com.sigre.contabilidad.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.contabilidad.dto.request.AsientoDetalleRequest;
import com.sigre.contabilidad.dto.request.AsientoRequest;
import com.sigre.contabilidad.dto.request.AsientoSearchRequest;
import com.sigre.contabilidad.dto.response.AsientoResponse;
import com.sigre.contabilidad.dto.response.PageData;
import com.sigre.contabilidad.entity.CntblAsiento;
import com.sigre.contabilidad.entity.CntblAsientoDet;
import com.sigre.contabilidad.entity.PlanContableDet;
import com.sigre.contabilidad.mapper.AsientoDetalleMapper;
import com.sigre.contabilidad.mapper.AsientoMapper;
import com.sigre.contabilidad.repository.CntblAsientoDetRepository;
import com.sigre.contabilidad.repository.CntblAsientoRepository;
import com.sigre.contabilidad.repository.CntblCierreRepository;
import com.sigre.contabilidad.repository.PlanContableDetRepository;
import com.sigre.contabilidad.service.AsientoService;
import com.sigre.contabilidad.service.ContabilidadErrorCodes;
import com.sigre.contabilidad.specification.AsientoSpecification;
import com.sigre.contabilidad.support.AsientoPeriodoLibroValidator;
import com.sigre.contabilidad.support.AsientoPeriodoLibroValidator.PeriodoLibro;
import com.sigre.contabilidad.support.SucursalVoucherValidator;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AsientoServiceImpl implements AsientoService {

    private final CntblAsientoRepository asientoRepository;
    private final CntblAsientoDetRepository detalleRepository;
    private final CntblCierreRepository cntblCierreRepository;
    private final AsientoDetalleMapper detalleMapper;
    private final PlanContableDetRepository planContableDetRepository;
    private final AsientoMapper asientoMapper;
    private final AsientoPeriodoLibroValidator periodoLibroValidator;
    private final SucursalVoucherValidator sucursalVoucherValidator;

    @Timed(value = "app.db.query", extraTags = {"table", "cntbl_asiento", "operation", "create"})
    @Override
    @Transactional
    public CntblAsiento crear(AsientoRequest request) {
        log.info("Creando asiento contable - naturaleza: {}, moduloOrigen: {}", 
            request.getNaturalezaAsiento(), request.getModuloOrigen());
        
        validarAsientoBalanceado(request.getDetalles());
        validarCuentasDetalle(request.getDetalles());

        PeriodoLibro periodoLibro = periodoLibroValidator.validar(
                request.getAno(), request.getMes(), request.getLibroId());
        Long sucursalId = sucursalVoucherValidator.validar(
                request.getSucursalId() != null ? request.getSucursalId() : TenantContext.getSucursalId());

        String voucher = asientoRepository.getVoucherNumber(
                sucursalId, periodoLibro.ano(), periodoLibro.mes(), periodoLibro.cntblLibroId());

        CntblAsiento asiento = new CntblAsiento();
        asiento.setVoucher(voucher);
        asiento.setLibroId(periodoLibro.cntblLibroId());
        asiento.setFecha(request.getFecha());
        asiento.setGlosa(request.getGlosa());
        asiento.setNaturalezaAsiento(request.getNaturalezaAsiento());
        asiento.setModuloOrigen(request.getModuloOrigen());
        asiento.setCntblPreasientoId(request.getCntblPreasientoId());
        asiento.setMonedaId(request.getMonedaId());
        asiento.setTasaCambio(request.getTasaCambio());
        asiento.setCreatedBy(TenantContext.getUsuarioId());
        
        CntblAsiento savedAsiento = asientoRepository.save(asiento);
        
        for (AsientoDetalleRequest detRequest : request.getDetalles()) {
            CntblAsientoDet detalle = detalleMapper.toEntity(detRequest);
            detalle.setCntblAsiento(savedAsiento);
            detalle.setCreatedBy(TenantContext.getUsuarioId());
            detalle.setFecCreacion(java.time.Instant.now());
            detalleRepository.save(detalle);
        }
        
        log.info("Asiento contable creado exitosamente con id: {}", savedAsiento.getId());
        return asientoRepository.findByIdWithDetalles(savedAsiento.getId())
            .orElseThrow(() -> new ResourceNotFoundException("Asiento", savedAsiento.getId()));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "cntbl_asiento", "operation", "findById"})
    @Override
    public CntblAsiento obtenerPorId(Long id) {
        log.info("Buscando asiento contable con id: {}", id);
        return asientoRepository.findByIdWithDetalles(id)
            .orElseThrow(() -> {
                log.warn("Asiento contable no encontrado con id: {}", id);
                return new ResourceNotFoundException("Asiento contable", id);
            });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "cntbl_asiento", "operation", "update"})
    @Override
    @Transactional
    public CntblAsiento actualizar(Long id, AsientoRequest request) {
        log.info("Actualizando asiento contable con id: {}", id);
        
        CntblAsiento asiento = obtenerPorId(id);
        
        if (!"1".equals(asiento.getFlagEstado())) {
            throw new BusinessException(
                "Solo se pueden actualizar asientos activos",
                HttpStatus.UNPROCESSABLE_ENTITY,
                ContabilidadErrorCodes.ESTADO_INVALIDO_PARA_ACTUALIZACION
            );
        }
        
        validarAsientoBalanceado(request.getDetalles());
        validarCuentasDetalle(request.getDetalles());
        
        asiento.setFecha(request.getFecha());
        asiento.setGlosa(request.getGlosa());
        asiento.setNaturalezaAsiento(request.getNaturalezaAsiento());
        asiento.setModuloOrigen(request.getModuloOrigen());
        asiento.setMonedaId(request.getMonedaId());
        asiento.setTasaCambio(request.getTasaCambio());
        asiento.setCntblPreasientoId(request.getCntblPreasientoId());
        asiento.setUpdatedBy(TenantContext.getUsuarioId());
        
        asiento.getDetalles().clear();
        detalleRepository.deleteByCntblAsientoId(id);
        asientoRepository.flush();
        
        for (AsientoDetalleRequest detRequest : request.getDetalles()) {
            CntblAsientoDet detalle = detalleMapper.toEntity(detRequest);
            detalle.setCntblAsiento(asiento);
            detalle.setCreatedBy(TenantContext.getUsuarioId());
            detalle.setFecCreacion(java.time.Instant.now());
            asiento.getDetalles().add(detalle);
        }
        
        asientoRepository.save(asiento);
        
        log.info("Asiento contable actualizado exitosamente con id: {}", id);
        return asientoRepository.findByIdWithDetalles(id)
            .orElseThrow(() -> new ResourceNotFoundException("Asiento contable", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "cntbl_asiento", "operation", "anular"})
    @Override
    @Transactional
    public CntblAsiento anular(Long id) {
        log.info("Anulando asiento contable con id: {}", id);
        
        CntblAsiento asiento = obtenerPorId(id);
        
        if ("0".equals(asiento.getFlagEstado())) {
            throw new BusinessException(
                "El asiento ya está anulado",
                HttpStatus.UNPROCESSABLE_ENTITY,
                ContabilidadErrorCodes.ESTADO_INVALIDO_PARA_ANULACION
            );
        }
        
        if (!"1".equals(asiento.getFlagEstado())) {
            throw new BusinessException(
                "Solo se pueden anular asientos activos",
                HttpStatus.UNPROCESSABLE_ENTITY,
                ContabilidadErrorCodes.ESTADO_INVALIDO_PARA_ANULACION
            );
        }

        validarPeriodoAbierto(asiento.getFecha());
        
        asiento.setFlagEstado("0");
        asiento.setUpdatedBy(TenantContext.getUsuarioId());
        
        asientoRepository.save(asiento);
        log.info("Asiento contable anulado exitosamente con id: {}", id);
        
        return asientoRepository.findByIdWithDetalles(id)
            .orElseThrow(() -> new ResourceNotFoundException("Asiento contable", id));
    }

    @Override
    public void validarAsientoBalanceado(List<AsientoDetalleRequest> detalles) {
        BigDecimal sumaDebe = detalles.stream()
            .filter(d -> "D".equals(d.getFlagDebeHaber()))
            .map(d -> d.getImporteSol() != null ? d.getImporteSol() : BigDecimal.ZERO)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal sumaHaber = detalles.stream()
            .filter(d -> "H".equals(d.getFlagDebeHaber()))
            .map(d -> d.getImporteSol() != null ? d.getImporteSol() : BigDecimal.ZERO)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        if (sumaDebe.compareTo(sumaHaber) != 0) {
            log.error("Asiento no balanceado - Debe: {}, Haber: {}", sumaDebe, sumaHaber);
            throw new BusinessException(
                String.format("El asiento no está balanceado. Debe: %s, Haber: %s", 
                    sumaDebe, sumaHaber),
                HttpStatus.UNPROCESSABLE_ENTITY,
                ContabilidadErrorCodes.ASIENTO_NO_BALANCEADO
            );
        }
        
        log.debug("Asiento balanceado correctamente - Total: {}", sumaDebe);
    }

    @Override
    public void validarCuentasDetalle(List<AsientoDetalleRequest> detalles) {
        for (AsientoDetalleRequest det : detalles) {
            PlanContableDet cuenta = planContableDetRepository
                .findByIdAndFlagEstado(det.getPlanContableDetId(), "1")
                .orElseThrow(() -> new BusinessException(
                    String.format("Plan contable no encontrado con id: %d", det.getPlanContableDetId()),
                    HttpStatus.NOT_FOUND,
                    ContabilidadErrorCodes.PLAN_CONTABLE_NO_ENCONTRADO
                ));
        }
    }
    
    @Timed(value = "app.db.query", extraTags = {"table", "cntbl_asiento", "operation", "buscar"})
    @Override
    public PageData<AsientoResponse> buscar(AsientoSearchRequest request, Pageable pageable) {
        log.info("Buscando asientos contables con filtros - fechaDesde: {}, fechaHasta: {}, cuentaContableId: {}, naturaleza: {}, estado: {}",
                request.getFechaDesde(), request.getFechaHasta(), request.getCuentaContableId(),
                request.getNaturalezaAsiento(), request.getFlagEstado());

        Specification<CntblAsiento> spec = AsientoSpecification.conFiltros(
                request.getFechaDesde(),
                request.getFechaHasta(),
                request.getCuentaContableId(),
                request.getNaturalezaAsiento(),
                request.getFlagEstado()
        );

        Page<CntblAsiento> asientosPage = asientoRepository.findAll(spec, pageable);
        List<AsientoResponse> responses = asientoMapper.toResponseList(asientosPage.getContent());

        log.info("Búsqueda completada - {} resultados de {} totales",
                responses.size(), asientosPage.getTotalElements());

        return PageData.of(asientosPage, responses);
    }

    private void validarPeriodoAbierto(LocalDate fecha) {
        int anio = fecha.getYear();
        int mes = fecha.getMonthValue();
        cntblCierreRepository.findByAnoAndMes(anio, mes).ifPresent(cierre -> {
            if ("1".equals(cierre.getFlagCierreMes())) {
                throw new BusinessException(
                    String.format("El período contable %d-%02d está cerrado", anio, mes),
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ContabilidadErrorCodes.PERIODO_CONTABLE_CERRADO
                );
            }
        });
    }

}
