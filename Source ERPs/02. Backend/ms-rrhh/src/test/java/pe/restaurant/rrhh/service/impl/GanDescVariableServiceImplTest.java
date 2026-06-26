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
import pe.restaurant.rrhh.dto.request.GanDescVariableRequest;
import pe.restaurant.rrhh.dto.response.GanDescVariableResponse;
import pe.restaurant.rrhh.entity.GanDescVariable;
import pe.restaurant.rrhh.entity.Trabajador;
import pe.restaurant.rrhh.mapper.GanDescVariableMapper;
import pe.restaurant.rrhh.repository.ConceptoPlanillaRepository;
import pe.restaurant.rrhh.repository.GanDescVariableRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("GanDescVariableServiceImpl — Pruebas Unitarias")
class GanDescVariableServiceImplTest {

    @Mock
    private GanDescVariableRepository repository;

    @Mock
    private TrabajadorRepository trabajadorRepo;

    @Mock
    private ConceptoPlanillaRepository conceptoPlanillaRepo;

    @Mock
    private GanDescVariableMapper mapper;

    @InjectMocks
    private GanDescVariableServiceImpl service;

    @Captor
    private ArgumentCaptor<GanDescVariable> captor;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(mapper.toResponse(any())).thenAnswer(inv -> {
            GanDescVariable entity = inv.getArgument(0);
            return GanDescVariableResponse.builder()
                    .id(entity.getId())
                    .trabajadorId(entity.getTrabajadorId())
                    .impVar(entity.getImpVar())
                    .build();
        });
    }

    @Test
    @DisplayName("listar() con filtros -> retorna página")
    void listar_conFiltros_retornaPagina() {
        when(repository.findWithFilters(any(), any(), any(), any(), any(), any()))
                .thenReturn(new PageImpl<>(List.of(RrhhTestFixtures.ganDescVariable(1L))));

        Page<GanDescVariableResponse> result = service.listar(1L, 1L, 2026, 1, 1L, Pageable.ofSize(10));

        assertThat(result.getContent()).hasSize(1);
        verify(repository).findWithFilters(any(), any(), any(), any(), any(), any());
    }

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna registro")
    void obtenerPorId_idExistente_retornaRegistro() {
        GanDescVariable entity = RrhhTestFixtures.ganDescVariable(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        GanDescVariableResponse result = service.obtenerPorId(1L);

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
                .hasMessageContaining("GanDescVariable");
    }

    @Test
    @DisplayName("crear() con datos válidos -> guarda registro")
    void crear_datosValidos_guardaRegistro() {
        GanDescVariableRequest request = RrhhTestFixtures.ganDescVariableRequest();
        Trabajador tActivo = Trabajador.builder().nombres("Test").build();
        tActivo.setFlagEstado("1");
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(tActivo));
        when(conceptoPlanillaRepo.existsById(1L)).thenReturn(true);
        when(repository.existsTipoPlanillaById(1L)).thenReturn(true);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        service.crear(request);

        verify(repository).save(captor.capture());
        GanDescVariable saved = captor.getValue();
        assertThat(saved.getTrabajadorId()).isEqualTo(1L);
        assertThat(saved.getConceptoId()).isEqualTo(1L);
        assertThat(saved.getCreatedBy()).isEqualTo(1L);
        assertThat(saved.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("crear() con trabajador inactivo -> lanza BusinessException")
    void crear_trabajadorInactivo_lanzaBusinessException() {
        GanDescVariableRequest request = RrhhTestFixtures.ganDescVariableRequest();
        Trabajador tInactivo = Trabajador.builder().nombres("Test").build();
        tInactivo.setFlagEstado("0");
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(tInactivo));

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("actualizar() con ID existente -> actualiza")
    void actualizar_idExistente_actualiza() {
        GanDescVariable entity = RrhhTestFixtures.ganDescVariable(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        Trabajador tActivo = Trabajador.builder().nombres("Test").build();
        tActivo.setFlagEstado("1");
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(tActivo));
        when(conceptoPlanillaRepo.existsById(1L)).thenReturn(true);
        when(repository.existsTipoPlanillaById(1L)).thenReturn(true);
        when(repository.save(entity)).thenReturn(entity);

        GanDescVariableRequest request = RrhhTestFixtures.ganDescVariableRequest();
        service.actualizar(1L, request);

        assertThat(entity.getNroDoc()).isEqualTo("DOC-002");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("eliminar() con ID existente -> elimina")
    void eliminar_idExistente_elimina() {
        GanDescVariable entity = RrhhTestFixtures.ganDescVariable(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        service.eliminar(1L);

        verify(repository).delete(entity);
    }
}
