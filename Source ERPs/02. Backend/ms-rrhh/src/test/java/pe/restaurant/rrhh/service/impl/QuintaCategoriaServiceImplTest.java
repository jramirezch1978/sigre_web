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
import pe.restaurant.rrhh.entity.QuintaCategoria;
import pe.restaurant.rrhh.entity.TipoPlanilla;
import pe.restaurant.rrhh.entity.Trabajador;
import pe.restaurant.rrhh.repository.ContratoRepository;
import pe.restaurant.rrhh.repository.QuintaCategoriaRepository;
import pe.restaurant.rrhh.repository.TipoPlanillaRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("QuintaCategoriaServiceImpl — Pruebas Unitarias")
class QuintaCategoriaServiceImplTest {

    @Mock private QuintaCategoriaRepository quintaCategoriaRepo;
    @Mock private TrabajadorRepository trabajadorRepo;
    @Mock private ContratoRepository contratoRepo;
    @Mock private TipoPlanillaRepository tipoPlanillaRepo;

    @InjectMocks
    private QuintaCategoriaServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @Test
    @DisplayName("procesar() -> calcula retención para todos los activos con contrato")
    void procesar_calculaRetencionParaActivosConContrato() {
        Trabajador trabajador = RrhhTestFixtures.trabajador(1L);
        Contrato contrato = RrhhTestFixtures.contrato(1L, 1L);
        TipoPlanilla tipoPlanilla = new TipoPlanilla();
        tipoPlanilla.setId(1L);
        tipoPlanilla.setCodigo("N");
        when(tipoPlanillaRepo.findByCodigo("N")).thenReturn(Optional.of(tipoPlanilla));
        when(trabajadorRepo.findAll()).thenReturn(List.of(trabajador));
        when(contratoRepo.findByTrabajadorIdAndFlagEstadoOrderByFecCreacionDesc(1L, "1"))
                .thenReturn(List.of(contrato));
        when(quintaCategoriaRepo.saveAll(anyList())).thenAnswer(inv -> inv.getArgument(0));

        List<QuintaCategoria> result = service.procesar(2026, 6);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getTrabajadorId()).isEqualTo(1L);
        assertThat(result.get(0).getFecProceso()).isEqualTo(LocalDate.of(2026, 6, 30));
        verify(quintaCategoriaRepo).deleteByFecProcesoBetween(
                LocalDate.of(2026, 6, 1), LocalDate.of(2026, 6, 30));
        verify(quintaCategoriaRepo).saveAll(anyList());
    }

    @Test
    @DisplayName("procesar() con año null -> lanza BusinessException")
    void procesar_anioNull_lanzaBusinessException() {
        assertThatThrownBy(() -> service.procesar(null, 6))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("El año es obligatorio.");
    }

    @Test
    @DisplayName("procesar() con mes inválido -> lanza BusinessException")
    void procesar_mesInvalido_lanzaBusinessException() {
        assertThatThrownBy(() -> service.procesar(2026, 13))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("El mes debe estar entre 1 y 12.");
    }

    @Test
    @DisplayName("procesar() sin trabajadores activos -> lanza BusinessException")
    void procesar_sinTrabajadoresActivos_lanzaBusinessException() {
        TipoPlanilla tipoPlanilla = new TipoPlanilla();
        tipoPlanilla.setId(1L);
        when(tipoPlanillaRepo.findByCodigo("N")).thenReturn(Optional.of(tipoPlanilla));
        when(trabajadorRepo.findAll()).thenReturn(List.of());

        assertThatThrownBy(() -> service.procesar(2026, 6))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No se encontraron trabajadores afectos");
    }

    @Test
    @DisplayName("procesar() salta trabajadores sin contrato activo")
    void procesar_saltaTrabajadoresSinContrato() {
        Trabajador trabajador = RrhhTestFixtures.trabajador(1L);
        TipoPlanilla tipoPlanilla = new TipoPlanilla();
        tipoPlanilla.setId(1L);
        when(tipoPlanillaRepo.findByCodigo("N")).thenReturn(Optional.of(tipoPlanilla));
        when(trabajadorRepo.findAll()).thenReturn(List.of(trabajador));
        when(contratoRepo.findByTrabajadorIdAndFlagEstadoOrderByFecCreacionDesc(1L, "1"))
                .thenReturn(List.of());
        when(quintaCategoriaRepo.saveAll(anyList())).thenReturn(List.of());

        List<QuintaCategoria> result = service.procesar(2026, 6);

        assertThat(result).isEmpty();
    }

    @Test
    @DisplayName("procesar() solo trabajador inactivo -> lanza BusinessException")
    void procesar_soloInactivo_lanzaBusinessException() {
        Trabajador inactivo = RrhhTestFixtures.trabajadorInactivo(2L);
        TipoPlanilla tipoPlanilla = new TipoPlanilla();
        tipoPlanilla.setId(1L);
        when(tipoPlanillaRepo.findByCodigo("N")).thenReturn(Optional.of(tipoPlanilla));
        when(trabajadorRepo.findAll()).thenReturn(List.of(inactivo));

        assertThatThrownBy(() -> service.procesar(2026, 6))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No se encontraron trabajadores afectos");
    }

    @Test
    @DisplayName("listar() -> retorna página")
    void listar_retornaPagina() {
        Pageable pageable = Pageable.ofSize(10);
        when(quintaCategoriaRepo.findWithFilters(any(), any(), any(), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of(RrhhTestFixtures.quintaCategoria(1L))));

        Page<QuintaCategoria> result = service.listar(null, null, null, pageable);

        assertThat(result.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("listar() con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() {
        Pageable pageable = Pageable.ofSize(10);
        when(quintaCategoriaRepo.findWithFilters(eq(1L), eq(2026), eq(6), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of()));

        service.listar(1L, 2026, 6, pageable);

        verify(quintaCategoriaRepo).findWithFilters(1L, 2026, 6, pageable);
    }

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna registro")
    void obtenerPorId_idExistente_retornaRegistro() {
        when(quintaCategoriaRepo.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.quintaCategoria(1L)));

        QuintaCategoria result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza BusinessException")
    void obtenerPorId_idInexistente_lanzaBusinessException() {
        when(quintaCategoriaRepo.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Registro de quinta categoría no encontrado.");
    }
}
