package pe.restaurant.activos.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.entity.AfClase;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfSubClase;
import pe.restaurant.activos.repository.AfCalculoCntblRepository;
import pe.restaurant.activos.repository.AfClaseRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfSubClaseRepository;
import pe.restaurant.activos.repository.AfVentaRepository;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.service.AfCalculoCntblService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.activos.service.DepreciacionService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfCalculoCntblServiceImpl implements AfCalculoCntblService {

    private final AfCalculoCntblRepository repository;
    private final AfMaestroRepository maestroRepository;
    private final AfSubClaseRepository subClaseRepository;
    private final AfClaseRepository claseRepository;
    private final AfVentaRepository ventaRepository;
    private final DepreciacionService depreciacionService;
    private final ContabilidadIntegracionService contabilidadIntegracionService;
    private final ContabilidadAutoContabilizador contabilidadAutoContabilizador;

    @Timed(value = "app.db.query", extraTags = {"table", "af_calculo_cntbl", "operation", "findAll"})
    @Override
    public Page<AfCalculoCntbl> findAll(Pageable pageable) {
        log.info("Listando cálculos de depreciación - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<AfCalculoCntbl> page = repository.findAll(pageable);
        log.info("Cálculos de depreciación encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_calculo_cntbl", "operation", "findById"})
    @Override
    public AfCalculoCntbl findById(Long id) {
        log.info("Buscando cálculo de depreciación con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Cálculo de depreciación no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Cálculo de depreciación", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_calculo_cntbl", "operation", "create"})
    @Override
    @Transactional
    public AfCalculoCntbl create(AfCalculoCntbl entity) {
        log.info("Creando cálculo de depreciación para activo: {} - Periodo: {}/{}", 
                entity.getAfMaestroId(), entity.getAnio(), entity.getMes());
        
        validarPeriodoDuplicado(entity.getAfMaestroId(), entity.getAnio(), entity.getMes(), null);
        
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        AfCalculoCntbl saved = repository.save(entity);
        log.info("Cálculo de depreciación creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_calculo_cntbl", "operation", "update"})
    @Override
    @Transactional
    public AfCalculoCntbl update(Long id, AfCalculoCntbl entity) {
        log.info("Actualizando cálculo de depreciación con id: {}", id);
        AfCalculoCntbl existing = findById(id);
        
        if (!existing.getAfMaestroId().equals(entity.getAfMaestroId()) ||
            !existing.getAnio().equals(entity.getAnio()) ||
            !existing.getMes().equals(entity.getMes())) {
            validarPeriodoDuplicado(entity.getAfMaestroId(), entity.getAnio(), entity.getMes(), id);
        }
        
        existing.setAfMaestroId(entity.getAfMaestroId());
        existing.setAnio(entity.getAnio());
        existing.setMes(entity.getMes());
        existing.setDepreciacionPeriodo(entity.getDepreciacionPeriodo());
        existing.setDepreciacionAcumulada(entity.getDepreciacionAcumulada());
        existing.setValorNeto(entity.getValorNeto());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        AfCalculoCntbl updated = repository.save(existing);
        log.info("Cálculo de depreciación actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_calculo_cntbl", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando cálculo de depreciación con id: {}", id);
        AfCalculoCntbl existing = findById(id);
        repository.delete(existing);
        log.info("Cálculo de depreciación eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_calculo_cntbl", "operation", "obtenerHistorialPorActivo"})
    @Override
    public List<AfCalculoCntbl> obtenerHistorialPorActivo(Long afMaestroId) {
        log.info("Obteniendo historial de depreciación para activo: {}", afMaestroId);
        List<AfCalculoCntbl> historial = repository.obtenerHistorialDepreciacion(afMaestroId);
        log.info("Registros de depreciación encontrados para activo {}: {}", afMaestroId, historial.size());
        return historial;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_calculo_cntbl", "operation", "obtenerPorPeriodo"})
    @Override
    public List<AfCalculoCntbl> obtenerPorPeriodo(Integer anio, Integer mes) {
        log.info("Obteniendo depreciaciones del periodo: {}/{}", anio, mes);
        List<AfCalculoCntbl> depreciaciones = repository.obtenerDepreciacionPorPeriodo(anio, mes);
        log.info("Depreciaciones encontradas para periodo {}/{}: {}", anio, mes, depreciaciones.size());
        return depreciaciones;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_calculo_cntbl", "operation", "calcularDepreciacionMensual"})
    @Override
    @Transactional
    public AfCalculoCntbl calcularDepreciacionMensual(Long afMaestroId, Integer anio, Integer mes,
                                                      Integer unidadesProducidasPeriodoOverride) {
        log.info("Calculando depreciación mensual para activo: {} - Periodo: {}/{}", afMaestroId, anio, mes);

        validarPeriodoNoFuturo(anio, mes);
        validarPeriodoDuplicado(afMaestroId, anio, mes, null);

        AfMaestro activo = maestroRepository.findById(afMaestroId)
                .orElseThrow(() -> {
                    log.warn("Activo maestro no encontrado con id: {}", afMaestroId);
                    return new BusinessException(
                            "El activo con ID " + afMaestroId + " no existe en el sistema",
                            HttpStatus.NOT_FOUND,
                            ActivosErrorCodes.ACTIVO_MAESTRO_NO_ENCONTRADO
                    );
                });

        if (!ActivosFlagEstado.ACTIVO.equals(activo.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede calcular depreciación para un activo inactivo",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.ACTIVO_INACTIVO_DEPRECIACION
            );
        }

        if (ventaRepository.existsByAfMaestroId(afMaestroId)) {
            throw new BusinessException(
                    "No se puede depreciar un activo con registro de venta/baja en activos.af_venta",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.ACTIVO_YA_VENDIDO);
        }


        if (!ActivosFlagEstado.ACTIVO.equals(activo.getFlagEstado())) {
            log.warn("Activo {} inactivo (flag_estado: {}). No se calcula depreciación.", afMaestroId, activo.getFlagEstado());
            throw new BusinessException(
                    "No se puede calcular depreciación para un activo con flag_estado <> '1' (actual: " + activo.getFlagEstado() + ")",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.ACTIVO_COMPLETAMENTE_DEPRECIADO
            );
        }

        AfSubClase subClase = subClaseRepository.findById(activo.getAfSubClaseId())
                .orElseThrow(() -> new ResourceNotFoundException("Sub-clase", activo.getAfSubClaseId()));

        AfClase clase = claseRepository.findById(subClase.getAfClaseId())
                .orElseThrow(() -> new ResourceNotFoundException("Clase", subClase.getAfClaseId()));

        String metodoDepreciacion = clase.getMetodoDepreciacion();
        if (metodoDepreciacion == null || metodoDepreciacion.isBlank()) {
            log.warn("Activo {} no tiene método de depreciación definido", afMaestroId);
            throw new BusinessException(
                    "El activo no tiene un método de depreciación definido en su clase",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.ACTIVO_SIN_METODO_DEPRECIACION
            );
        }

        Integer vidaUtilMeses = subClase.getVidaUtilMeses() != null ?
                subClase.getVidaUtilMeses() : clase.getVidaUtilMeses();

        if (vidaUtilMeses == null || vidaUtilMeses == 0) {
            log.warn("Activo {} no tiene vida útil definida", afMaestroId);
            throw new BusinessException(
                    "El activo no tiene vida útil definida",
                    HttpStatus.BAD_REQUEST,
                    "ACT-023"
            );
        }

        LocalDate fechaCalculo = LocalDate.of(anio, mes, 1);
        Period periodo = Period.between(activo.getFechaAdquisicion(), fechaCalculo);
        int mesesTranscurridos = periodo.getYears() * 12 + periodo.getMonths();

        if (mesesTranscurridos < 0) {
            log.warn("Periodo de cálculo {}/{} es anterior a la fecha de adquisición del activo {}",
                    anio, mes, afMaestroId);
            throw new BusinessException(
                    "No se puede calcular depreciación para un periodo anterior a la adquisición del activo",
                    HttpStatus.BAD_REQUEST,
                    "ACT-024"
            );
        }

        AfCalculoCntbl ultimaDepreciacion = repository.obtenerUltimaDepreciacion(afMaestroId).orElse(null);
        BigDecimal depreciacionAcumuladaAnterior = ultimaDepreciacion != null ?
                ultimaDepreciacion.getDepreciacionAcumulada() : BigDecimal.ZERO;
        BigDecimal valorNetoActual = ultimaDepreciacion != null ?
                ultimaDepreciacion.getValorNeto() : activo.getValorAdquisicion();

        if (valorNetoActual.compareTo(activo.getValorResidual()) <= 0) {
            log.warn("Activo {} ya está completamente depreciado", afMaestroId);
            throw new BusinessException(
                    "El activo ya alcanzó su valor residual y está completamente depreciado",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.ACTIVO_COMPLETAMENTE_DEPRECIADO
            );
        }

        BigDecimal depreciacionPeriodo;
        switch (metodoDepreciacion.toUpperCase()) {
            case "LINEAL":
                depreciacionPeriodo = depreciacionService.calcularDepreciacionLineal(
                        activo, vidaUtilMeses, mesesTranscurridos);
                break;
            case "ACELERADA":
                depreciacionPeriodo = depreciacionService.calcularDepreciacionAcelerada(
                        activo, vidaUtilMeses, valorNetoActual);
                break;
            case "UNIDADES_PRODUCIDAS":
                depreciacionPeriodo = calcularDepreciacionUnidadesProduccion(
                        activo, unidadesProducidasPeriodoOverride);
                break;
            default:
                log.warn("Método de depreciación no soportado: {}", metodoDepreciacion);
                throw new BusinessException(
                        "Método de depreciación no soportado: " + metodoDepreciacion,
                        HttpStatus.BAD_REQUEST,
                        "ACT-025"
                );
        }

        BigDecimal depreciacionAcumulada = depreciacionAcumuladaAnterior.add(depreciacionPeriodo);
        BigDecimal valorNeto = activo.getValorAdquisicion().subtract(depreciacionAcumulada);

        if (valorNeto.compareTo(activo.getValorResidual()) < 0) {
            valorNeto = activo.getValorResidual();
            depreciacionPeriodo = valorNetoActual.subtract(activo.getValorResidual());
            depreciacionAcumulada = activo.getValorAdquisicion().subtract(activo.getValorResidual());
        }

        AfCalculoCntbl calculo = new AfCalculoCntbl();
        calculo.setAfMaestroId(afMaestroId);
        calculo.setAnio(anio);
        calculo.setMes(mes);
        calculo.setDepreciacionPeriodo(depreciacionPeriodo);
        calculo.setDepreciacionAcumulada(depreciacionAcumulada);
        calculo.setValorNeto(valorNeto);
        calculo.setFlagEstado(ActivosFlagEstado.ACTIVO);
        calculo.setCreatedBy(TenantContext.getUsuarioId());

        AfCalculoCntbl saved = repository.save(calculo);
        log.info("Depreciación calculada y guardada exitosamente para activo {} - Periodo: {}/{} - Depreciación: {}",
                afMaestroId, anio, mes, depreciacionPeriodo);

        if (depreciacionPeriodo.compareTo(BigDecimal.ZERO) > 0) {
            contabilidadAutoContabilizador.ejecutarSiAutomatico(
                    "depreciacion",
                    () -> contabilidadIntegracionService.contabilizarDepreciacion(saved.getId()));
        }

        return saved;
    }

    private BigDecimal calcularDepreciacionUnidadesProduccion(AfMaestro activo,
                                                              Integer unidadesProducidasPeriodoOverride) {
        Integer uTot = activo.getUnidadesProduccionTotales();
        if (uTot == null || uTot <= 0) {
            throw new BusinessException(
                    "Configure unidades de producción totales en el activo para el método por unidades.",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.UNIDADES_PRODUCCION_INCOMPLETAS
            );
        }
        Integer uPeriodo = unidadesProducidasPeriodoOverride != null
                ? unidadesProducidasPeriodoOverride
                : activo.getUnidadesProduccionPeriodo();
        if (uPeriodo == null) {
            throw new BusinessException(
                    "Indique las unidades producidas del período (solicitud o campo en el activo).",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.UNIDADES_PRODUCCION_INCOMPLETAS
            );
        }
        return depreciacionService.calcularDepreciacionUnidadesProduccion(activo, uTot, uPeriodo);
    }

    private static boolean esOmitidoEnDepreciacionMasiva(BusinessException e) {
        String code = e.getErrorCode();
        return ActivosErrorCodes.ACTIVO_COMPLETAMENTE_DEPRECIADO.equals(code)
                || ActivosErrorCodes.UNIDADES_PRODUCCION_INCOMPLETAS.equals(code)
                || ActivosErrorCodes.ACTIVO_INACTIVO_DEPRECIACION.equals(code)
                || ActivosErrorCodes.ACTIVO_YA_VENDIDO.equals(code);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_calculo_cntbl", "operation", "calcularDepreciacionMasiva"})
    @Override
    @Transactional
    public List<AfCalculoCntbl> calcularDepreciacionMasiva(Integer anio, Integer mes) {
        log.info("Calculando depreciación masiva para periodo: {}/{}", anio, mes);
        
        validarPeriodoNoFuturo(anio, mes);
        
        List<AfMaestro> activosElegibles = maestroRepository
                .findByFlagEstado(ActivosFlagEstado.ACTIVO, Pageable.unpaged())
                .getContent();
        log.info("Activos en estado ACTIVO para depreciación masiva: {}", activosElegibles.size());

        List<AfCalculoCntbl> calculosRealizados = new ArrayList<>();
        int exitosos = 0;
        int omitidos = 0;

        for (AfMaestro activo : activosElegibles) {
            try {
                if (!ActivosFlagEstado.ACTIVO.equals(activo.getFlagEstado())) {
                    log.debug("Activo {} inactivo (flag_estado={}), omitiendo", activo.getId(), activo.getFlagEstado());
                    omitidos++;
                    continue;
                }

                if (repository.existsByAfMaestroIdAndAnioAndMes(activo.getId(), anio, mes)) {
                    log.debug("Depreciación ya existe para activo {} en periodo {}/{}, omitiendo",
                            activo.getId(), anio, mes);
                    omitidos++;
                    continue;
                }

                AfCalculoCntbl calculo = calcularDepreciacionMensual(activo.getId(), anio, mes, null);
                calculosRealizados.add(calculo);
                exitosos++;

            } catch (BusinessException e) {
                if (esOmitidoEnDepreciacionMasiva(e)) {
                    log.debug("Activo {} omitido en depreciación masiva: {}", activo.getId(), e.getMessage());
                    omitidos++;
                } else {
                    log.warn("Error al calcular depreciación para activo {}: {}", activo.getId(), e.getMessage());
                }
            } catch (Exception e) {
                log.error("Error inesperado al calcular depreciación para activo {}: {}",
                        activo.getId(), e.getMessage(), e);
            }
        }

        log.info("Depreciación masiva completada - Total activos: {}, Exitosos: {}, Omitidos: {}",
                activosElegibles.size(), exitosos, omitidos);
        
        return calculosRealizados;
    }

    private void validarPeriodoDuplicado(Long afMaestroId, Integer anio, Integer mes, Long excludeId) {
        if (repository.existsByAfMaestroIdAndAnioAndMes(afMaestroId, anio, mes)) {
            log.warn("Ya existe depreciación para activo {} en periodo {}/{}", afMaestroId, anio, mes);
            throw new BusinessException(
                    "Ya existe un cálculo de depreciación para este activo en el periodo " + mes + "/" + anio,
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.DEPRECIACION_DUPLICADA
            );
        }
    }

    private void validarPeriodoNoFuturo(Integer anio, Integer mes) {
        LocalDate periodoCalculo = LocalDate.of(anio, mes, 1);
        LocalDate hoy = LocalDate.now();
        
        if (periodoCalculo.isAfter(hoy.withDayOfMonth(1))) {
            log.warn("Intento de calcular depreciación para periodo futuro: {}/{}", anio, mes);
            throw new BusinessException(
                    "No se puede calcular depreciación para periodos futuros",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.PERIODO_FUTURO_NO_PERMITIDO
            );
        }
    }
}
