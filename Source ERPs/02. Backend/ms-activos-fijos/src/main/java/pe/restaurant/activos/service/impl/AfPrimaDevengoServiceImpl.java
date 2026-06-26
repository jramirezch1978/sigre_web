package pe.restaurant.activos.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfPolizaSeguro;
import pe.restaurant.activos.entity.AfPrimaDevengo;
import pe.restaurant.activos.repository.AfPolizaSeguroRepository;
import pe.restaurant.activos.repository.AfPrimaDevengoRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.service.AfPolizaSeguroService;
import pe.restaurant.activos.service.AfPrimaDevengoService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfPrimaDevengoServiceImpl implements AfPrimaDevengoService {

    private final AfPolizaSeguroService polizaSeguroService;
    private final AfPolizaSeguroRepository polizaSeguroRepository;
    private final AfPrimaDevengoRepository repository;
    private final ContabilidadIntegracionService contabilidadIntegracionService;
    private final ContabilidadAutoContabilizador contabilidadAutoContabilizador;

    @Timed(value = "app.db.query", extraTags = {"table", "af_prima_devengo", "operation", "registrarDevengoMensual"})
    @Override
    @Transactional
    public AfPrimaDevengo registrarDevengoMensual(Long polizaSeguroId, Integer anio, Integer mes) {
        log.info("Devengo prima póliza {} periodo {}/{}", polizaSeguroId, anio, mes);
        if (repository.existsByAfPolizaSeguroIdAndAnioAndMes(polizaSeguroId, anio, mes)) {
            throw new BusinessException(
                    "Ya existe devengo de prima para esta póliza y periodo",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.PRIMA_DEVENGO_DUPLICADO);
        }
        AfPolizaSeguro poliza = polizaSeguroService.findById(polizaSeguroId);
        if (poliza.getPrima() == null || poliza.getPrima().compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException(
                    "La póliza no tiene prima definida para devengar",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.PRIMA_SIN_MONTO);
        }
        LocalDate inicioPoliza = poliza.getFechaInicio();
        LocalDate finPoliza = poliza.getFechaFin() != null ? poliza.getFechaFin() : inicioPoliza.plusYears(1);
        LocalDate inicioPeriodo = LocalDate.of(anio, mes, 1);
        if (inicioPeriodo.isBefore(inicioPoliza.withDayOfMonth(1))
                || inicioPeriodo.isAfter(finPoliza.withDayOfMonth(1))) {
            throw new BusinessException(
                    "El periodo está fuera de la vigencia de la póliza",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.PERIODO_FUERA_VIGENCIA_POLIZA);
        }
        long mesesVigencia = ChronoUnit.MONTHS.between(
                inicioPoliza.withDayOfMonth(1),
                finPoliza.withDayOfMonth(1)) + 1;
        if (mesesVigencia < 1) {
            mesesVigencia = 1;
        }
        BigDecimal mensual = poliza.getPrima()
                .divide(BigDecimal.valueOf(mesesVigencia), 4, RoundingMode.HALF_UP);

        AfPrimaDevengo row = new AfPrimaDevengo();
        row.setAfPolizaSeguroId(polizaSeguroId);
        row.setAnio(anio);
        row.setMes(mes);
        row.setImporteDevengado(mensual);
        row.setMesesVigenciaPoliza((int) mesesVigencia);
        row.setFlagEstado(ActivosFlagEstado.ACTIVO);
        row.setCreatedBy(TenantContext.getUsuarioId());
        AfPrimaDevengo saved = repository.save(row);
        contabilidadAutoContabilizador.ejecutarSiAutomatico(
                "devengo-prima",
                () -> contabilidadIntegracionService.contabilizarDevengoPrima(saved.getId()));
        return saved;
    }

    @Override
    public List<AfPrimaDevengo> listByPoliza(Long polizaSeguroId) {
        polizaSeguroService.findById(polizaSeguroId);
        return repository.findByAfPolizaSeguroIdOrderByAnioDescMesDesc(polizaSeguroId);
    }

    @Override
    @Transactional
    public List<AfPrimaDevengo> registrarDevengoMasivo(Integer anio, Integer mes) {
        log.info("Devengo masivo de primas periodo {}/{}", anio, mes);
        List<AfPrimaDevengo> registrados = new java.util.ArrayList<>();
        for (AfPolizaSeguro poliza : polizaSeguroRepository.findPolizasVigentes(Pageable.unpaged()).getContent()) {
            if (!ActivosFlagEstado.ACTIVO.equals(poliza.getFlagEstado())) {
                continue;
            }
            try {
                registrados.add(registrarDevengoMensual(poliza.getId(), anio, mes));
            } catch (BusinessException e) {
                log.debug("Póliza {} omitida en devengo masivo: {}", poliza.getId(), e.getMessage());
            }
        }
        return registrados;
    }
}
