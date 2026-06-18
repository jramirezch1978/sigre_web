package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.entity.AfPolizaSeguro;
import pe.restaurant.activos.entity.AfPrimaDevengo;
import pe.restaurant.activos.repository.AfPrimaDevengoRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.repository.AfPolizaSeguroRepository;
import pe.restaurant.activos.service.AfPolizaSeguroService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfPrimaDevengoServiceImplTest {

    @Mock
    private AfPolizaSeguroService polizaSeguroService;
    @Mock
    private AfPolizaSeguroRepository polizaSeguroRepository;
    @Mock
    private AfPrimaDevengoRepository repository;
    @Mock
    private ContabilidadIntegracionService contabilidadIntegracionService;
    @Mock
    private ContabilidadAutoContabilizador contabilidadAutoContabilizador;
    @InjectMocks
    private AfPrimaDevengoServiceImpl service;

    private static AfPolizaSeguro polizaVigencia2026() {
        AfPolizaSeguro p = new AfPolizaSeguro();
        p.setId(1L);
        p.setFechaInicio(LocalDate.of(2026, 1, 1));
        p.setFechaFin(LocalDate.of(2026, 12, 31));
        p.setPrima(new BigDecimal("1200.00"));
        return p;
    }

    @Test
    void registrarDevengoMensualThrowsWhenDuplicatePeriod() {
        when(repository.existsByAfPolizaSeguroIdAndAnioAndMes(1L, 2026, 6)).thenReturn(true);
        BusinessException ex = assertThrows(
                BusinessException.class,
                () -> service.registrarDevengoMensual(1L, 2026, 6));
        assertEquals(ActivosErrorCodes.PRIMA_DEVENGO_DUPLICADO, ex.getErrorCode());
        verify(repository, never()).save(any());
    }

    @Test
    void registrarDevengoMensualThrowsWhenPrimaNull() {
        when(repository.existsByAfPolizaSeguroIdAndAnioAndMes(1L, 2026, 6)).thenReturn(false);
        AfPolizaSeguro p = polizaVigencia2026();
        p.setPrima(null);
        when(polizaSeguroService.findById(1L)).thenReturn(p);
        BusinessException ex = assertThrows(
                BusinessException.class,
                () -> service.registrarDevengoMensual(1L, 2026, 6));
        assertEquals(ActivosErrorCodes.PRIMA_SIN_MONTO, ex.getErrorCode());
    }

    @Test
    void registrarDevengoMensualThrowsWhenPrimaZero() {
        when(repository.existsByAfPolizaSeguroIdAndAnioAndMes(1L, 2026, 6)).thenReturn(false);
        AfPolizaSeguro p = polizaVigencia2026();
        p.setPrima(BigDecimal.ZERO);
        when(polizaSeguroService.findById(1L)).thenReturn(p);
        BusinessException ex = assertThrows(
                BusinessException.class,
                () -> service.registrarDevengoMensual(1L, 2026, 6));
        assertEquals(ActivosErrorCodes.PRIMA_SIN_MONTO, ex.getErrorCode());
    }

    @Test
    void registrarDevengoMensualThrowsWhenPeriodoBeforeVigencia() {
        when(repository.existsByAfPolizaSeguroIdAndAnioAndMes(1L, 2025, 12)).thenReturn(false);
        when(polizaSeguroService.findById(1L)).thenReturn(polizaVigencia2026());
        BusinessException ex = assertThrows(
                BusinessException.class,
                () -> service.registrarDevengoMensual(1L, 2025, 12));
        assertEquals(ActivosErrorCodes.PERIODO_FUERA_VIGENCIA_POLIZA, ex.getErrorCode());
    }

    @Test
    void registrarDevengoMensualThrowsWhenPeriodoAfterVigencia() {
        when(repository.existsByAfPolizaSeguroIdAndAnioAndMes(1L, 2027, 1)).thenReturn(false);
        when(polizaSeguroService.findById(1L)).thenReturn(polizaVigencia2026());
        BusinessException ex = assertThrows(
                BusinessException.class,
                () -> service.registrarDevengoMensual(1L, 2027, 1));
        assertEquals(ActivosErrorCodes.PERIODO_FUERA_VIGENCIA_POLIZA, ex.getErrorCode());
    }

    @Test
    void registrarDevengoMensualSavesPrimaLinealPorMes() {
        when(repository.existsByAfPolizaSeguroIdAndAnioAndMes(1L, 2026, 6)).thenReturn(false);
        when(polizaSeguroService.findById(1L)).thenReturn(polizaVigencia2026());
        when(repository.save(any(AfPrimaDevengo.class))).thenAnswer(inv -> {
            AfPrimaDevengo arg = inv.getArgument(0);
            arg.setId(99L);
            return arg;
        });

        AfPrimaDevengo result = service.registrarDevengoMensual(1L, 2026, 6);
        assertEquals(1L, result.getAfPolizaSeguroId());
        assertEquals(2026, result.getAnio());
        assertEquals(6, result.getMes());
        assertEquals(12, result.getMesesVigenciaPoliza());
        assertEquals(0, new BigDecimal("100.0000").compareTo(result.getImporteDevengado()));
        assertEquals(ActivosFlagEstado.ACTIVO, result.getFlagEstado());
        verify(repository).save(any(AfPrimaDevengo.class));
    }

    @Test
    void registrarDevengoMensualUsesFinSyntheticWhenFechaFinNull() {
        when(repository.existsByAfPolizaSeguroIdAndAnioAndMes(1L, 2026, 6)).thenReturn(false);
        AfPolizaSeguro p = new AfPolizaSeguro();
        p.setId(1L);
        p.setFechaInicio(LocalDate.of(2026, 1, 15));
        p.setFechaFin(null);
        p.setPrima(new BigDecimal("1200.00"));
        when(polizaSeguroService.findById(1L)).thenReturn(p);
        when(repository.save(any(AfPrimaDevengo.class))).thenAnswer(inv -> inv.getArgument(0));

        AfPrimaDevengo result = service.registrarDevengoMensual(1L, 2026, 6);
        assertNotNull(result.getImporteDevengado());
        assertTrue(result.getMesesVigenciaPoliza() >= 1);
    }

    @Test
    void listByPolizaReturnsOrderedRows() {
        when(polizaSeguroService.findById(1L)).thenReturn(polizaVigencia2026());
        AfPrimaDevengo a = new AfPrimaDevengo();
        a.setId(1L);
        when(repository.findByAfPolizaSeguroIdOrderByAnioDescMesDesc(1L)).thenReturn(List.of(a));
        List<AfPrimaDevengo> list = service.listByPoliza(1L);
        assertEquals(1, list.size());
        verify(repository).findByAfPolizaSeguroIdOrderByAnioDescMesDesc(1L);
    }

    @Test
    void registrarDevengoMensualThrowsWhenPrimaNegativa() {
        when(repository.existsByAfPolizaSeguroIdAndAnioAndMes(1L, 2026, 6)).thenReturn(false);
        AfPolizaSeguro p = polizaVigencia2026();
        p.setPrima(new BigDecimal("-100.00"));
        when(polizaSeguroService.findById(1L)).thenReturn(p);
        BusinessException ex = assertThrows(
                BusinessException.class,
                () -> service.registrarDevengoMensual(1L, 2026, 6));
        assertEquals(ActivosErrorCodes.PRIMA_SIN_MONTO, ex.getErrorCode());
    }

    @Test
    void registrarDevengoMensualCalculaMesesVigenciaCorrectamente() {
        when(repository.existsByAfPolizaSeguroIdAndAnioAndMes(1L, 2026, 3)).thenReturn(false);
        AfPolizaSeguro p = new AfPolizaSeguro();
        p.setId(1L);
        p.setFechaInicio(LocalDate.of(2026, 1, 1));
        p.setFechaFin(LocalDate.of(2026, 6, 30));
        p.setPrima(new BigDecimal("600.00"));
        when(polizaSeguroService.findById(1L)).thenReturn(p);
        when(repository.save(any(AfPrimaDevengo.class))).thenAnswer(inv -> inv.getArgument(0));

        AfPrimaDevengo result = service.registrarDevengoMensual(1L, 2026, 3);

        assertEquals(6, result.getMesesVigenciaPoliza());
        assertEquals(0, new BigDecimal("100.0000").compareTo(result.getImporteDevengado()));
    }

    @Test
    void registrarDevengoMasivoOmitePolizasInactivas() {
        AfPolizaSeguro polizaActiva = polizaVigencia2026();
        polizaActiva.setFlagEstado(ActivosFlagEstado.ACTIVO);

        AfPolizaSeguro polizaInactiva = new AfPolizaSeguro();
        polizaInactiva.setId(2L);
        polizaInactiva.setFlagEstado(ActivosFlagEstado.INACTIVO);

        org.springframework.data.domain.Page<AfPolizaSeguro> page =
                new org.springframework.data.domain.PageImpl<>(List.of(polizaActiva, polizaInactiva));
        when(polizaSeguroRepository.findPolizasVigentes(any())).thenReturn(page);

        when(repository.existsByAfPolizaSeguroIdAndAnioAndMes(1L, 2026, 6)).thenReturn(false);
        when(polizaSeguroService.findById(1L)).thenReturn(polizaActiva);
        when(repository.save(any(AfPrimaDevengo.class))).thenAnswer(inv -> {
            AfPrimaDevengo arg = inv.getArgument(0);
            arg.setId(99L);
            return arg;
        });

        List<AfPrimaDevengo> result = service.registrarDevengoMasivo(2026, 6);

        assertEquals(1, result.size());
    }

    @Test
    void registrarDevengoMasivoOmitePolizasConDuplicado() {
        AfPolizaSeguro poliza1 = polizaVigencia2026();
        poliza1.setFlagEstado(ActivosFlagEstado.ACTIVO);

        AfPolizaSeguro poliza2 = new AfPolizaSeguro();
        poliza2.setId(2L);
        poliza2.setFlagEstado(ActivosFlagEstado.ACTIVO);
        poliza2.setFechaInicio(LocalDate.of(2026, 1, 1));
        poliza2.setFechaFin(LocalDate.of(2026, 12, 31));
        poliza2.setPrima(new BigDecimal("2400.00"));

        org.springframework.data.domain.Page<AfPolizaSeguro> page =
                new org.springframework.data.domain.PageImpl<>(List.of(poliza1, poliza2));
        when(polizaSeguroRepository.findPolizasVigentes(any())).thenReturn(page);

        when(repository.existsByAfPolizaSeguroIdAndAnioAndMes(1L, 2026, 6)).thenReturn(true);
        when(repository.existsByAfPolizaSeguroIdAndAnioAndMes(2L, 2026, 6)).thenReturn(false);
        when(polizaSeguroService.findById(2L)).thenReturn(poliza2);
        when(repository.save(any(AfPrimaDevengo.class))).thenAnswer(inv -> {
            AfPrimaDevengo arg = inv.getArgument(0);
            arg.setId(100L);
            return arg;
        });

        List<AfPrimaDevengo> result = service.registrarDevengoMasivo(2026, 6);

        assertEquals(1, result.size());
        assertEquals(2L, result.get(0).getAfPolizaSeguroId());
    }

    @Test
    void registrarDevengoMasivoRetornaListaVaciaSiNoHayPolizasVigentes() {
        org.springframework.data.domain.Page<AfPolizaSeguro> page =
                new org.springframework.data.domain.PageImpl<>(List.of());
        when(polizaSeguroRepository.findPolizasVigentes(any())).thenReturn(page);

        List<AfPrimaDevengo> result = service.registrarDevengoMasivo(2026, 6);

        assertEquals(0, result.size());
    }
}
