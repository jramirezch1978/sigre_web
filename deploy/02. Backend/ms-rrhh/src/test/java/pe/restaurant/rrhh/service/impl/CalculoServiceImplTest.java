package pe.restaurant.rrhh.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.response.CalculoDetalleResponse;
import pe.restaurant.rrhh.dto.response.CalculoResponse;
import pe.restaurant.rrhh.entity.*;
import pe.restaurant.rrhh.mapper.CalculoMapper;
import pe.restaurant.rrhh.repository.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CalculoServiceImpl — Pruebas Unitarias")
class CalculoServiceImplTest {

    @Mock private CalculoRepository calculoRepo;
    @Mock private CalculoDetRepository calculoDetRepo;
    @Mock private TrabajadorRepository trabajadorRepo;
    @Mock private ContratoRepository contratoRepo;
    @Mock private ConceptoPlanillaRepository conceptoRepo;
    @Mock private AdminAfpRepository adminAfpRepo;
    @Mock private CalculoMapper mapper;

    @InjectMocks
    private CalculoServiceImpl service;

    @Captor
    private ArgumentCaptor<Calculo> calculoCaptor;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    // ═══════════════════════════════════════════════════
    // listar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        Pageable pageable = Pageable.ofSize(10);
        when(calculoRepo.findWithFilters(any(), any(), any(), any()))
            .thenReturn(new PageImpl<>(List.of(RrhhTestFixtures.calculo(1L))));
        when(mapper.toResponse(any(), anyInt())).thenReturn(RrhhTestFixtures.calculoResponse(1L));

        Page<CalculoResponse> result = service.listar(null, null, null, pageable);

        assertThat(result.getContent()).hasSize(1);
        verify(calculoRepo).findWithFilters(null, null, null, pageable);
    }

    @Test
    @DisplayName("listar() con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() {
        Pageable pageable = Pageable.ofSize(10);
        when(calculoRepo.findWithFilters(eq(2026), eq(6), eq(1L), any()))
            .thenReturn(new PageImpl<>(List.of()));

        service.listar(2026, 6, 1L, pageable);

        verify(calculoRepo).findWithFilters(2026, 6, 1L, pageable);
    }

    // ═══════════════════════════════════════════════════
    // obtenerDetalle()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("obtenerDetalle() con ID existente -> retorna detalle")
    void obtenerDetalle_idExistente_retornaDetalle() {
        Calculo entity = RrhhTestFixtures.calculo(1L);
        List<CalculoDet> detalles = List.of(RrhhTestFixtures.calculoDet(1L, 1L));
        when(calculoRepo.findById(1L)).thenReturn(Optional.of(entity));
        when(calculoDetRepo.findByCalculoIdOrderByTrabajadorId(1L)).thenReturn(detalles);
        when(mapper.toDetalleResponse(entity, detalles)).thenReturn(RrhhTestFixtures.calculoDetalleResponse(1L));

        CalculoDetalleResponse result = service.obtenerDetalle(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("obtenerDetalle() con ID inexistente -> lanza ResourceNotFoundException")
    void obtenerDetalle_idInexistente_lanzaResourceNotFoundException() {
        when(calculoRepo.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerDetalle(999L))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    // ═══════════════════════════════════════════════════
    // procesar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("procesar() -> crea cálculo con trabajadores activos")
    void procesar_creaCalculo() {
        when(calculoRepo.existsTipoPlanillaById(1L)).thenReturn(true);
        when(calculoRepo.findByAnioAndMesAndTipoPlanillaId(2026, 6, 1L)).thenReturn(Optional.empty());
        Trabajador t = RrhhTestFixtures.trabajador(1L);
        when(trabajadorRepo.findAll()).thenReturn(List.of(t));
        when(calculoRepo.findTipoConceptoCalculoIdByCodigo("INGRESO")).thenReturn(1L);
        when(calculoRepo.findTipoConceptoCalculoIdByCodigo("DESCUENTO")).thenReturn(2L);
        when(calculoRepo.save(any(Calculo.class))).thenAnswer(i -> {
            Calculo c = i.getArgument(0);
            if (c.getId() == null) c.setId(1L);
            return c;
        });
        Contrato contrato = RrhhTestFixtures.contrato(1L, 1L);
        when(contratoRepo.findByTrabajadorIdAndFlagEstadoOrderByFecCreacionDesc(1L, "1")).thenReturn(List.of(contrato));

        ConceptoPlanilla cpIngreso = new ConceptoPlanilla();
        cpIngreso.setId(1L);
        cpIngreso.setCodigo("C001");
        cpIngreso.setNombre("Remuneración básica");
        cpIngreso.setTipo("INGRESO");
        when(conceptoRepo.findAll()).thenReturn(List.of(cpIngreso));

        when(calculoDetRepo.saveAll(anyList())).thenReturn(null);
        when(mapper.toDetalleResponse(any(), anyList())).thenReturn(RrhhTestFixtures.calculoDetalleResponse(1L));

        CalculoDetalleResponse result = service.procesar(2026, 6, 1L);

        assertThat(result).isNotNull();
        verify(calculoRepo, atLeastOnce()).save(any(Calculo.class));
        verify(calculoDetRepo).saveAll(anyList());
    }

    @Test
    @DisplayName("procesar() con tipo planilla inexistente -> lanza RH-CA-001")
    void procesar_tipoPlanillaInexistente_lanzaError() {
        when(calculoRepo.existsTipoPlanillaById(999L)).thenReturn(false);

        assertThatThrownBy(() -> service.procesar(2026, 6, 999L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Tipo de planilla no encontrado");
        verify(calculoRepo, never()).save(any());
    }

    @Test
    @DisplayName("procesar() sin trabajadores activos -> lanza RH-CA-004")
    void procesar_sinTrabajadoresActivos_lanzaError() {
        when(calculoRepo.existsTipoPlanillaById(1L)).thenReturn(true);
        when(calculoRepo.findByAnioAndMesAndTipoPlanillaId(2026, 6, 1L)).thenReturn(Optional.empty());
        when(trabajadorRepo.findAll()).thenReturn(List.of());

        assertThatThrownBy(() -> service.procesar(2026, 6, 1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("No existen trabajadores activos");
    }

    @Test
    @DisplayName("procesar() con trabajador con AFP -> calcula descuento AFP")
    void procesar_conTrabajadorConAfp_calculaDescuentoAfp() {
        when(calculoRepo.existsTipoPlanillaById(1L)).thenReturn(true);
        when(calculoRepo.findByAnioAndMesAndTipoPlanillaId(2026, 6, 1L)).thenReturn(Optional.empty());
        Trabajador t = RrhhTestFixtures.trabajador(1L);
        t.setAdminAfpId(1L);
        when(trabajadorRepo.findAll()).thenReturn(List.of(t));
        when(calculoRepo.findTipoConceptoCalculoIdByCodigo("INGRESO")).thenReturn(1L);
        when(calculoRepo.findTipoConceptoCalculoIdByCodigo("DESCUENTO")).thenReturn(2L);
        when(calculoRepo.save(any(Calculo.class))).thenAnswer(i -> {
            Calculo c = i.getArgument(0);
            if (c.getId() == null) c.setId(1L);
            return c;
        });
        Contrato contrato = RrhhTestFixtures.contrato(1L, 1L);
        when(contratoRepo.findByTrabajadorIdAndFlagEstadoOrderByFecCreacionDesc(1L, "1")).thenReturn(List.of(contrato));

        ConceptoPlanilla cpIngreso = new ConceptoPlanilla();
        cpIngreso.setId(1L);
        cpIngreso.setCodigo("C001");
        cpIngreso.setNombre("Remuneración básica");
        cpIngreso.setTipo("INGRESO");
        ConceptoPlanilla cpAfp = new ConceptoPlanilla();
        cpAfp.setId(2L);
        cpAfp.setCodigo("D001");
        cpAfp.setNombre("Aporte AFP");
        cpAfp.setTipo("DESCUENTO");
        when(conceptoRepo.findAll()).thenReturn(List.of(cpIngreso, cpAfp));

        AdminAfp afp = new AdminAfp();
        afp.setId(1L);
        afp.setComisionPorcentaje(new BigDecimal("1.8000"));
        afp.setPrimaSeguro(new BigDecimal("0.9800"));
        afp.setAporteObligatorio(new BigDecimal("10.0000"));
        when(adminAfpRepo.findById(1L)).thenReturn(Optional.of(afp));

        when(calculoDetRepo.saveAll(anyList())).thenReturn(null);
        when(mapper.toDetalleResponse(any(), anyList())).thenReturn(RrhhTestFixtures.calculoDetalleResponse(1L));

        CalculoDetalleResponse result = service.procesar(2026, 6, 1L);

        assertThat(result).isNotNull();
        verify(adminAfpRepo).findById(1L);
    }

    // ═══════════════════════════════════════════════════
    // eliminar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("eliminar() -> elimina cálculo y sus detalles")
    void eliminar_eliminaCalculoYDetalles() {
        Calculo entity = RrhhTestFixtures.calculo(1L);
        when(calculoRepo.findById(1L)).thenReturn(Optional.of(entity));

        service.eliminar(1L);

        verify(calculoDetRepo).deleteByCalculoId(1L);
        verify(calculoRepo).delete(entity);
    }

    @Test
    @DisplayName("eliminar() con ID inexistente -> lanza ResourceNotFoundException")
    void eliminar_idInexistente_lanzaResourceNotFoundException() {
        when(calculoRepo.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.eliminar(999L))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(calculoDetRepo, never()).deleteByCalculoId(any());
        verify(calculoRepo, never()).delete(any());
    }
}
