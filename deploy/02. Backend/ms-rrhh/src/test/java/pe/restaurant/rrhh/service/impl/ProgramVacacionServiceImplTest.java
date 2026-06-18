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
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.ProgramVacacionCreateRequest;
import pe.restaurant.rrhh.dto.request.ProgramVacacionImportarRequest;
import pe.restaurant.rrhh.dto.request.ProgramVacacionUpdateRequest;
import pe.restaurant.rrhh.dto.response.ProgramVacacionResponse;
import pe.restaurant.rrhh.entity.ProgramVacacion;
import pe.restaurant.rrhh.mapper.ProgramVacacionMapper;
import pe.restaurant.rrhh.repository.ProgramVacacionRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ProgramVacacionServiceImpl — Pruebas Unitarias")
class ProgramVacacionServiceImplTest {

    @Mock private ProgramVacacionRepository repository;
    @Mock private ProgramVacacionMapper mapper;

    @InjectMocks
    private ProgramVacacionServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        Pageable pageable = Pageable.ofSize(10);
        when(repository.findAll(pageable))
                .thenReturn(new PageImpl<>(List.of(RrhhTestFixtures.programVacacion(1L))));
        when(mapper.toResponse(any())).thenReturn(RrhhTestFixtures.programVacacionResponse(1L));

        Page<ProgramVacacionResponse> result = service.listar(null, null, pageable);

        assertThat(result.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("listar() con filtros -> busca por trabajador y año")
    void listar_conFiltros_buscaPorTrabajadorYAnio() {
        Pageable pageable = Pageable.ofSize(10);
        when(repository.findByTrabajadorIdAndAnio(1L, 2026))
                .thenReturn(List.of(RrhhTestFixtures.programVacacion(1L)));
        when(mapper.toResponseList(anyList())).thenReturn(List.of(RrhhTestFixtures.programVacacionResponse(1L)));

        Page<ProgramVacacionResponse> result = service.listar(1L, 2026, pageable);

        assertThat(result.getContent()).hasSize(1);
        verify(repository).findByTrabajadorIdAndAnio(1L, 2026);
    }

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna programación")
    void obtenerPorId_idExistente_retornaProgramacion() {
        when(repository.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.programVacacion(1L)));
        when(mapper.toResponse(any())).thenReturn(RrhhTestFixtures.programVacacionResponse(1L));

        ProgramVacacionResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza ResourceNotFoundException")
    void obtenerPorId_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("crear() -> crea programación con auditoría")
    void crear_creaProgramacionConAuditoria() {
        ProgramVacacionCreateRequest request = RrhhTestFixtures.programVacacionCreateRequest();
        ProgramVacacion entity = new ProgramVacacion();
        entity.setTrabajadorId(1L);
        entity.setAnio(2026);
        entity.setMes(3);
        entity.setDiasProgramados(15);

        ProgramVacacion saved = RrhhTestFixtures.programVacacion(1L);

        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(entity)).thenReturn(saved);
        when(mapper.toResponse(saved)).thenReturn(RrhhTestFixtures.programVacacionResponse(1L));

        ProgramVacacionResponse result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
        assertThat(entity.getFecCreacion()).isNotNull();
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("actualizar() -> actualiza programación existente")
    void actualizar_actualizaProgramacionExistente() {
        ProgramVacacion existing = RrhhTestFixtures.programVacacion(1L);
        ProgramVacacionUpdateRequest request = RrhhTestFixtures.programVacacionUpdateRequest();
        ProgramVacacion updated = RrhhTestFixtures.programVacacion(1L);
        updated.setDiasProgramados(10);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(updated);
        when(mapper.toResponse(updated)).thenReturn(RrhhTestFixtures.programVacacionResponse(1L));

        ProgramVacacionResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        verify(mapper).updateEntity(existing, request);
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza ResourceNotFoundException")
    void actualizar_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, RrhhTestFixtures.programVacacionUpdateRequest()))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("desactivar() -> cambia flagEstado a 0")
    void desactivar_cambiaFlagEstadoACero() {
        ProgramVacacion entity = RrhhTestFixtures.programVacacion(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        service.desactivar(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("desactivar() con ID inexistente -> lanza ResourceNotFoundException")
    void desactivar_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.desactivar(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ══════════════════════════════════════════════════════════════
    // importar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("importar() -> crea múltiples registros batch")
    void importar_creaMultiplesRegistros() {
        ProgramVacacionImportarRequest.ProgramVacacionImportRow row1 =
                new ProgramVacacionImportarRequest.ProgramVacacionImportRow(1L, 3, 15, "Ene-mar");
        ProgramVacacionImportarRequest.ProgramVacacionImportRow row2 =
                new ProgramVacacionImportarRequest.ProgramVacacionImportRow(2L, 4, 10, "Abril");
        ProgramVacacionImportarRequest request = new ProgramVacacionImportarRequest(2026, List.of(row1, row2));
        ProgramVacacion saved1 = RrhhTestFixtures.programVacacion(1L);
        ProgramVacacion saved2 = RrhhTestFixtures.programVacacion(2L);
        ProgramVacacionResponse resp1 = RrhhTestFixtures.programVacacionResponse(1L);
        ProgramVacacionResponse resp2 = RrhhTestFixtures.programVacacionResponse(2L);

        when(repository.save(any())).thenReturn(saved1, saved2);
        when(mapper.toResponse(saved1)).thenReturn(resp1);
        when(mapper.toResponse(saved2)).thenReturn(resp2);

        List<ProgramVacacionResponse> results = service.importar(request);

        assertThat(results).hasSize(2);
        assertThat(results.get(0).getId()).isEqualTo(1L);
        assertThat(results.get(1).getId()).isEqualTo(2L);
        verify(repository, times(2)).save(any());
        verify(mapper, times(2)).toResponse(any());
    }

    @Test
    @DisplayName("importar() con registros vacíos -> retorna lista vacía")
    void importar_registrosVacios_retornaListaVacia() {
        ProgramVacacionImportarRequest request = new ProgramVacacionImportarRequest(2026, List.of());

        List<ProgramVacacionResponse> results = service.importar(request);

        assertThat(results).isEmpty();
        verify(repository, never()).save(any());
    }

    // ══════════════════════════════════════════════════════════════
    // exportarExcel()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("exportarExcel() con año -> genera bytes")
    void exportarExcel_conAnio_generaBytes() {
        when(repository.findByAnio(2026)).thenReturn(List.of(RrhhTestFixtures.programVacacion(1L)));

        byte[] result = service.exportarExcel(2026);

        assertThat(result).isNotNull();
        assertThat(result.length).isPositive();
        verify(repository).findByAnio(2026);
    }

    @Test
    @DisplayName("exportarExcel() sin año -> exporta todos los registros")
    void exportarExcel_sinAnio_exportaTodos() {
        when(repository.findAll()).thenReturn(List.of(RrhhTestFixtures.programVacacion(1L)));

        byte[] result = service.exportarExcel(null);

        assertThat(result).isNotNull();
        assertThat(result.length).isPositive();
        verify(repository).findAll();
    }
}
