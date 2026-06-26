package pe.restaurant.ventas.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.entity.Mesa;
import pe.restaurant.ventas.repository.MesaRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("MesaServiceImpl — Pruebas Unitarias")
class MesaServiceImplTest {

    private static final Pageable PAGE = PageRequest.of(0, 20);

    @Mock
    private MesaRepository repository;
    @InjectMocks
    private MesaServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        TenantContext.setSucursalId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ==== findById ====

    @Test
    @DisplayName("findById() con ID existente -> retorna entidad")
    void findById_cuandoExiste_retornaEntidad() {
        when(repository.findByIdWithRelations(1L)).thenReturn(Optional.of(mesa(1L, "M01", "1")));

        assertThat(service.findById(1L).getNumero()).isEqualTo("M01");
        verify(repository).findByIdWithRelations(1L);
    }

    @Test
    @DisplayName("findById() con ID inexistente -> lanza ResourceNotFoundException")
    void findById_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findByIdWithRelations(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== findAll ====

    @Test
    @DisplayName("findAll() sin filtros -> retorna pagina")
    void findAll_sinFiltros_retornaPagina() {
        when(repository.findAll(PAGE)).thenReturn(new PageImpl<>(List.of()));

        assertThat(service.findAll(PAGE).getContent()).isEmpty();
        verify(repository).findAll(PAGE);
    }

    @Test
    @DisplayName("findAllWithFilters() con filtros -> retorna pagina filtrada")
    void findAllWithFilters_conFiltros_retornaPagina() {
        when(repository.findAllWithFilters(eq(2L), eq("M01"), eq("1"), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));

        assertThat(service.findAllWithFilters(2L, "M01", "1", PAGE).getContent()).isEmpty();
        verify(repository).findAllWithFilters(2L, "M01", "1", PAGE);
    }

    // ==== create ====

    @Test
    @DisplayName("create() con datos válidos -> persiste con flagEstado ACTIVO")
    void create_conDatosValidos_retornaCreado() {
        Mesa input = mesa(null, "M-NEW", null);
        when(repository.existsByNumeroAndFlagEstado("M-NEW", "1")).thenReturn(false);
        when(repository.existsZonaByIdAndSucursalId(5L, 1L)).thenReturn(true);
        when(repository.save(any())).thenAnswer(inv -> {
            Mesa e = inv.getArgument(0);
            e.setId(10L);
            return e;
        });

        Mesa result = service.create(input);

        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getCreatedBy()).isEqualTo(1L);
        verify(repository).save(any());
    }

    @Test
    @DisplayName("create() con número duplicado -> lanza BusinessException")
    void create_cuandoNumeroDuplicado_lanzaBusinessException() {
        Mesa input = mesa(null, "M-DUP", null);
        when(repository.existsByNumeroAndFlagEstado("M-DUP", "1")).thenReturn(true);

        assertThatThrownBy(() -> service.create(input))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe una mesa con número");
    }

    @Test
    @DisplayName("create() con zona inválida -> lanza BusinessException")
    void create_cuandoZonaInvalida_lanzaBusinessException() {
        Mesa input = mesa(null, "M-Z", null);
        when(repository.existsByNumeroAndFlagEstado("M-Z", "1")).thenReturn(false);
        when(repository.existsZonaByIdAndSucursalId(5L, 1L)).thenReturn(false);

        assertThatThrownBy(() -> service.create(input))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("La zona indicada no existe");
    }

    @Test
    @DisplayName("create() sin zona -> lanza BusinessException")
    void create_sinZona_lanzaBusinessException() {
        Mesa input = new Mesa();
        input.setNumero("M-X");

        assertThatThrownBy(() -> service.create(input))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("La zona es obligatoria");
    }

    // ==== update ====

    @Test
    @DisplayName("update() con datos válidos -> actualiza y retorna")
    void update_conDatosValidos_retornaActualizado() {
        Mesa existing = mesa(5L, "OLD", "1");
        Mesa patch = mesa(null, "NEW", null);
        patch.setCapacidad(8);
        when(repository.findById(5L)).thenReturn(Optional.of(existing));
        when(repository.existsByNumeroAndFlagEstadoAndIdNot("NEW", "1", 5L)).thenReturn(false);
        when(repository.existsZonaByIdAndSucursalId(5L, 1L)).thenReturn(true);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        Mesa result = service.update(5L, patch);

        assertThat(result.getNumero()).isEqualTo("NEW");
        assertThat(result.getCapacidad()).isEqualTo(8);
        verify(repository).save(any());
    }

    @Test
    @DisplayName("update() con ID inexistente -> lanza ResourceNotFoundException")
    void update_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(5L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.update(5L, mesa(null, "X", null)))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("5");
    }

    // ==== activate / deactivate ====

    @Test
    @DisplayName("activate() con ID existente -> cambia flagEstado a 1")
    void activate_cuandoExiste_cambiaFlagEstado() {
        Mesa m = mesa(3L, "M03", "0");
        when(repository.findByIdWithRelations(3L)).thenReturn(Optional.of(m));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        assertThat(service.activate(3L).getFlagEstado()).isEqualTo("1");
        verify(repository).save(any());
    }

    @Test
    @DisplayName("activate() con ID inexistente -> lanza ResourceNotFoundException")
    void activate_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findByIdWithRelations(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.activate(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    @Test
    @DisplayName("deactivate() con ID existente -> cambia flagEstado a 0")
    void deactivate_cuandoExiste_cambiaFlagEstado() {
        Mesa m = mesa(4L, "M04", "1");
        when(repository.findByIdWithRelations(4L)).thenReturn(Optional.of(m));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        assertThat(service.deactivate(4L).getFlagEstado()).isEqualTo("0");
        verify(repository).save(any());
    }

    @Test
    @DisplayName("deactivate() con ID inexistente -> lanza ResourceNotFoundException")
    void deactivate_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findByIdWithRelations(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.deactivate(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== delete ====

    @Test
    @DisplayName("delete() con ID existente -> elimina via repository")
    void delete_cuandoExiste_elimina() {
        Mesa m = mesa(6L, "M06", "1");
        when(repository.findById(6L)).thenReturn(Optional.of(m));

        service.delete(6L);

        verify(repository).delete(m);
    }

    @Test
    @DisplayName("delete() con ID inexistente -> lanza ResourceNotFoundException")
    void delete_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.delete(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== findByZonaId / findBySucursalId ====

    @Test
    @DisplayName("findByZonaId() con zona existente -> retorna lista")
    void findByZonaId_conZonaExistente_retornaLista() {
        when(repository.findByZonaIdAndActivo(1L)).thenReturn(List.of(mesa(1L, "M01", "1")));

        assertThat(service.findByZonaId(1L)).hasSize(1);
        verify(repository).findByZonaIdAndActivo(1L);
    }

    @Test
    @DisplayName("findBySucursalId() con sucursal existente -> retorna lista")
    void findBySucursalId_conSucursalExistente_retornaLista() {
        when(repository.findBySucursalIdAndActivo(1L)).thenReturn(List.of(mesa(2L, "M02", "1")));

        assertThat(service.findBySucursalId(1L)).hasSize(1);
        verify(repository).findBySucursalIdAndActivo(1L);
    }

    // ==== helpers ====

    private static Mesa mesa(Long id, String numero, String flag) {
        Mesa m = new Mesa();
        m.setId(id);
        m.setNumero(numero);
        m.setCapacidad(4);
        Mesa.Zona zona = new Mesa.Zona();
        zona.setId(5L);
        m.setZona(zona);
        if (flag != null) {
            m.setFlagEstado(flag);
        }
        return m;
    }
}
