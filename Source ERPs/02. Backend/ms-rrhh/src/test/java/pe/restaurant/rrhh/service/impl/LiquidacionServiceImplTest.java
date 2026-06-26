package pe.restaurant.rrhh.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.entity.Contrato;
import pe.restaurant.rrhh.entity.Liquidacion;
import pe.restaurant.rrhh.entity.Trabajador;
import pe.restaurant.rrhh.repository.ContratoRepository;
import pe.restaurant.rrhh.repository.LiquidacionRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("LiquidacionServiceImpl — Pruebas Unitarias")
class LiquidacionServiceImplTest {

    @Mock private LiquidacionRepository liquidacionRepo;
    @Mock private TrabajadorRepository trabajadorRepo;
    @Mock private ContratoRepository contratoRepo;

    @InjectMocks
    private LiquidacionServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @Test
    @DisplayName("calcular() -> calcula y registra liquidación para régimen general")
    void calcular_regimenGeneral_calculaYLiquidacion() {
        Trabajador trabajador = RrhhTestFixtures.trabajador(1L);
        trabajador.setFechaCese(LocalDate.of(2026, 1, 31));
        trabajador.setRegimenLaboralId(1L);
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));
        when(trabajadorRepo.findRegimenLaboralCodigoById(1L)).thenReturn("GENERAL");
        when(liquidacionRepo.existsActivaByTrabajadorAndFecha(1L, LocalDate.of(2026, 1, 31))).thenReturn(false);
        when(contratoRepo.findByTrabajadorIdAndFlagEstadoOrderByFecCreacionDesc(1L, "1"))
                .thenReturn(List.of(RrhhTestFixtures.contrato(1L, 1L)));
        when(liquidacionRepo.save(any())).thenAnswer(inv -> inv.getArgument(0));

        Liquidacion result = service.calcular(1L, LocalDate.of(2026, 1, 31));

        assertThat(result).isNotNull();
        assertThat(result.getTrabajadorId()).isEqualTo(1L);
        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getCtsPendiente()).isNotNull();
        assertThat(result.getVacacionesTruncas()).isNotNull();
        assertThat(result.getGratificacionTrunca()).isNotNull();
        assertThat(result.getTotalBeneficios()).isNotNull();
        assertThat(result.getTotalDescuentos()).isNotNull();
        assertThat(result.getNetoPagar()).isNotNull();
        verify(liquidacionRepo).save(any());
    }

    @Test
    @DisplayName("calcular() con trabajadorId null -> lanza BusinessException")
    void calcular_trabajadorIdNull_lanzaBusinessException() {
        assertThatThrownBy(() -> service.calcular(null, LocalDate.of(2026, 1, 31)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Debe seleccionar un trabajador.");
    }

    @Test
    @DisplayName("calcular() con trabajador inexistente -> lanza BusinessException")
    void calcular_trabajadorInexistente_lanzaBusinessException() {
        when(trabajadorRepo.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.calcular(999L, LocalDate.of(2026, 1, 31)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Liquidación no encontrada.");
    }

    @Test
    @DisplayName("calcular() sin fecha de cese -> lanza BusinessException")
    void calcular_sinFechaCese_lanzaBusinessException() {
        Trabajador trabajador = RrhhTestFixtures.trabajador(1L);
        trabajador.setFechaCese(null);
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));

        assertThatThrownBy(() -> service.calcular(1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("El trabajador no tiene fecha de cese registrada.");
    }

    @Test
    @DisplayName("calcular() con liquidación activa existente -> lanza BusinessException")
    void calcular_liquidacionActivaExistente_lanzaBusinessException() {
        Trabajador trabajador = RrhhTestFixtures.trabajador(1L);
        trabajador.setFechaCese(LocalDate.of(2026, 1, 31));
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));
        when(liquidacionRepo.existsActivaByTrabajadorAndFecha(1L, LocalDate.of(2026, 1, 31))).thenReturn(true);

        assertThatThrownBy(() -> service.calcular(1L, LocalDate.of(2026, 1, 31)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe una liquidación activa");
    }

    @Test
    @DisplayName("calcular() régimen agrícola -> solo vacaciones truncas")
    void calcular_regimenAgricola_soloVacacionesTruncas() {
        Trabajador trabajador = RrhhTestFixtures.trabajador(1L);
        trabajador.setFechaCese(LocalDate.of(2026, 1, 31));
        trabajador.setRegimenLaboralId(1L);
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));
        when(trabajadorRepo.findRegimenLaboralCodigoById(1L)).thenReturn("AGRICOLA");
        when(liquidacionRepo.existsActivaByTrabajadorAndFecha(1L, LocalDate.of(2026, 1, 31))).thenReturn(false);
        when(contratoRepo.findByTrabajadorIdAndFlagEstadoOrderByFecCreacionDesc(1L, "1"))
                .thenReturn(List.of(RrhhTestFixtures.contrato(1L, 1L)));
        when(liquidacionRepo.save(any())).thenAnswer(inv -> inv.getArgument(0));

        Liquidacion result = service.calcular(1L, LocalDate.of(2026, 1, 31));

        assertThat(result.getGratificacionTrunca()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(result.getCtsPendiente()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(result.getVacacionesTruncas()).isNotEqualByComparingTo(BigDecimal.ZERO);
    }

    @Test
    @DisplayName("listar() -> retorna página de liquidaciones")
    void listar_retornaPagina() {
        Pageable pageable = Pageable.ofSize(10);
        when(liquidacionRepo.findWithFilters(any(), any(), any(), any(), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of(RrhhTestFixtures.liquidacion(1L))));

        Page<Liquidacion> result = service.listar(null, null, null, null, pageable);

        assertThat(result.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna liquidación")
    void obtenerPorId_idExistente_retornaLiquidacion() {
        when(liquidacionRepo.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.liquidacion(1L)));

        Liquidacion result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza BusinessException")
    void obtenerPorId_idInexistente_lanzaBusinessException() {
        when(liquidacionRepo.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Liquidación no encontrada.");
    }

    @Test
    @DisplayName("aprobar() -> cambia estado a aprobado")
    void aprobar_cambiaEstadoYAprobado() {
        Liquidacion liquidacion = RrhhTestFixtures.liquidacion(1L);
        liquidacion.setFlagEstado("1");
        when(liquidacionRepo.findById(1L)).thenReturn(Optional.of(liquidacion));
        when(liquidacionRepo.save(any())).thenAnswer(inv -> inv.getArgument(0));

        Liquidacion result = service.aprobar(1L);

        assertThat(result.getFlagEstado()).isEqualTo("2");
    }

    @Test
    @DisplayName("aprobar() liquidación no pendiente -> lanza BusinessException")
    void aprobar_noPendiente_lanzaBusinessException() {
        Liquidacion liquidacion = RrhhTestFixtures.liquidacion(1L);
        liquidacion.setFlagEstado("2");
        when(liquidacionRepo.findById(1L)).thenReturn(Optional.of(liquidacion));

        assertThatThrownBy(() -> service.aprobar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Solo se pueden aprobar liquidaciones en estado Pendiente.");
    }

    @Test
    @DisplayName("anular() -> cambia estado a anulado")
    void anular_cambiaEstadoAAnulado() {
        Liquidacion liquidacion = RrhhTestFixtures.liquidacion(1L);
        liquidacion.setFlagEstado("1");
        when(liquidacionRepo.findById(1L)).thenReturn(Optional.of(liquidacion));
        when(liquidacionRepo.save(any())).thenAnswer(inv -> inv.getArgument(0));

        Liquidacion result = service.anular(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("anular() liquidación no pendiente -> lanza BusinessException")
    void anular_noPendiente_lanzaBusinessException() {
        Liquidacion liquidacion = RrhhTestFixtures.liquidacion(1L);
        liquidacion.setFlagEstado("0");
        when(liquidacionRepo.findById(1L)).thenReturn(Optional.of(liquidacion));

        assertThatThrownBy(() -> service.anular(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Solo se pueden anular liquidaciones en estado Pendiente.");
    }
}
