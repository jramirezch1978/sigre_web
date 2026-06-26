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
import org.springframework.data.domain.Pageable;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.EvaluacionDesempenoCreateRequest;
import pe.restaurant.rrhh.dto.request.EvaluacionDesempenoUpdateRequest;
import pe.restaurant.rrhh.dto.response.EvaluacionDesempenoResponse;
import pe.restaurant.rrhh.entity.EvaluacionDesempeno;
import pe.restaurant.rrhh.mapper.EvaluacionDesempenoMapper;
import pe.restaurant.rrhh.repository.EvaluacionDesempenoRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("EvaluacionDesempenoServiceImpl — Pruebas Unitarias")
class EvaluacionDesempenoServiceImplTest {

    @Mock
    private EvaluacionDesempenoRepository repository;

    @Mock
    private EvaluacionDesempenoMapper mapper;

    @InjectMocks
    private EvaluacionDesempenoServiceImpl service;

    @Captor
    private ArgumentCaptor<EvaluacionDesempeno> captor;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(mapper.toResponse(any())).thenAnswer(inv -> {
            EvaluacionDesempeno entity = inv.getArgument(0);
            EvaluacionDesempenoResponse r = new EvaluacionDesempenoResponse();
            r.setId(entity.getId());
            r.setTrabajadorId(entity.getTrabajadorId());
            r.setPeriodoAnio(entity.getPeriodoAnio());
            r.setCalificacion(entity.getCalificacion());
            r.setObservaciones(entity.getObservaciones());
            return r;
        });
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna página con findAll")
    void listar_sinFiltros_retornaPagina() {
        when(repository.findAll()).thenReturn(List.of(RrhhTestFixtures.evaluacionDesempeno(1L)));

        Page<EvaluacionDesempenoResponse> result = service.listar(null, null, null, Pageable.ofSize(10));

        assertThat(result.getContent()).hasSize(1);
        verify(repository).findAll();
    }

    @Test
    @DisplayName("listar() con filtro trabajador -> usa findByTrabajadorId")
    void listar_conFiltroTrabajador_usaFindByTrabajadorId() {
        when(repository.findByTrabajadorId(1L)).thenReturn(List.of());

        service.listar(1L, null, null, Pageable.ofSize(10));

        verify(repository).findByTrabajadorId(1L);
    }

    @Test
    @DisplayName("listar() con filtro trabajador y anio -> usa findByTrabajadorIdAndPeriodoAnio")
    void listar_conFiltroTrabajadorYAnio_usaFindCombinado() {
        when(repository.findByTrabajadorIdAndPeriodoAnio(1L, 2026)).thenReturn(List.of());

        service.listar(1L, 2026, null, Pageable.ofSize(10));

        verify(repository).findByTrabajadorIdAndPeriodoAnio(1L, 2026);
    }

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna evaluación")
    void obtenerPorId_idExistente_retornaEvaluacion() {
        EvaluacionDesempeno entity = RrhhTestFixtures.evaluacionDesempeno(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        EvaluacionDesempenoResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza ResourceNotFoundException")
    void obtenerPorId_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("EvaluacionDesempeno");
    }

    @Test
    @DisplayName("crear() con datos válidos -> guarda evaluación")
    void crear_datosValidos_guardaEvaluacion() {
        EvaluacionDesempenoCreateRequest request = RrhhTestFixtures.evaluacionDesempenoCreateRequest();
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        service.crear(request);

        verify(repository).save(captor.capture());
        EvaluacionDesempeno saved = captor.getValue();
        assertThat(saved.getTrabajadorId()).isEqualTo(1L);
        assertThat(saved.getPeriodoAnio()).isEqualTo(2026);
        assertThat(saved.getCreatedBy()).isEqualTo(1L);
        assertThat(saved.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("actualizar() con ID existente -> actualiza campos")
    void actualizar_idExistente_actualiza() {
        EvaluacionDesempeno entity = RrhhTestFixtures.evaluacionDesempeno(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        EvaluacionDesempenoUpdateRequest request = RrhhTestFixtures.evaluacionDesempenoUpdateRequest();
        service.actualizar(1L, request);

        assertThat(entity.getCalificacion()).isEqualByComparingTo("16.00");
        assertThat(entity.getObservaciones()).isEqualTo("Desempeño mejorado");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza ResourceNotFoundException")
    void actualizar_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, RrhhTestFixtures.evaluacionDesempenoUpdateRequest()))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("eliminar() con ID existente -> elimina")
    void eliminar_idExistente_elimina() {
        EvaluacionDesempeno entity = RrhhTestFixtures.evaluacionDesempeno(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        service.eliminar(1L);

        verify(repository).delete(entity);
    }
}
