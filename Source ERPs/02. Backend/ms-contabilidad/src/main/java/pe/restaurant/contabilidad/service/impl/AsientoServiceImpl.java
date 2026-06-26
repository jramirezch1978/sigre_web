package pe.restaurant.contabilidad.service.impl;

import io.micrometer.core.annotation.Timed;
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
import pe.restaurant.contabilidad.dto.request.AsientoDetalleRequest;
import pe.restaurant.contabilidad.dto.request.AsientoRequest;
import pe.restaurant.contabilidad.dto.request.AsientoSearchRequest;
import pe.restaurant.contabilidad.dto.response.AsientoResponse;
import pe.restaurant.contabilidad.dto.response.PageData;
import pe.restaurant.contabilidad.entity.CntblAsiento;
import pe.restaurant.contabilidad.entity.CntblAsientoDet;
import pe.restaurant.contabilidad.entity.PlanContableDet;
import pe.restaurant.contabilidad.mapper.AsientoDetalleMapper;
import pe.restaurant.contabilidad.mapper.AsientoMapper;
import pe.restaurant.contabilidad.repository.CntblAsientoDetRepository;
import pe.restaurant.contabilidad.repository.CntblAsientoRepository;
import pe.restaurant.contabilidad.repository.CntblCierreRepository;
import pe.restaurant.contabilidad.repository.PlanContableDetRepository;
import pe.restaurant.contabilidad.service.AsientoService;
import pe.restaurant.contabilidad.service.ContabilidadErrorCodes;
import pe.restaurant.contabilidad.specification.AsientoSpecification;
import pe.restaurant.contabilidad.support.AsientoPeriodoLibroValidator;
import pe.restaurant.contabilidad.support.AsientoPeriodoLibroValidator.PeriodoLibro;
import pe.restaurant.contabilidad.support.SucursalVoucherValidator;

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
        validarPeriodoAbierto(request.getFecha());

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

            // 1. Solo cuentas de detalle con permiso de movimiento
            if (!"1".equals(cuenta.getFlagPermiteMov())) {
                throw new BusinessException(
                    String.format("La cuenta %s (%s) no permite movimiento", cuenta.getCntaCtbl(), cuenta.getDescCnta()),
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ContabilidadErrorCodes.CUENTA_SIN_MOVIMIENTO);
            }

            // 3. Flags condicionales obligatorios
            if ("1".equals(cuenta.getFlagCencos()) && det.getCentrosCostoId() == null) {
                throw new BusinessException(
                    String.format("La cuenta %s (%s) requiere centro de costo", 
                        cuenta.getCntaCtbl(), cuenta.getDescCnta()),
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ContabilidadErrorCodes.CUENTA_REQUIERE_CENCOS);
            }
            if ("1".equals(cuenta.getFlagDocRef()) 
                && (det.getDocTipoId() == null || det.getNroReferencia() == null || det.getNroReferencia().isBlank())) {
                throw new BusinessException(
                    String.format("La cuenta %s (%s) requiere documento de referencia (tipo + número)", 
                        cuenta.getCntaCtbl(), cuenta.getDescCnta()),
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ContabilidadErrorCodes.CUENTA_REQUIERE_DOC_REF);
            }
            if ("1".equals(cuenta.getFlagCodRelacion()) && det.getEntidadContribuyenteId() == null) {
                throw new BusinessException(
                    String.format("La cuenta %s (%s) requiere entidad/contribuyente", 
                        cuenta.getCntaCtbl(), cuenta.getDescCnta()),
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ContabilidadErrorCodes.CUENTA_REQUIERE_ENTIDAD);
            }
            if ("1".equals(cuenta.getFlagCtabco()) && det.getBancoCtaId() == null) {
                throw new BusinessException(
                    String.format("La cuenta %s (%s) requiere banco/cuenta", 
                        cuenta.getCntaCtbl(), cuenta.getDescCnta()),
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ContabilidadErrorCodes.CUENTA_REQUIERE_BANCO);
            }
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
