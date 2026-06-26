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
import pe.restaurant.ventas.entity.ZonaDespacho;
import pe.restaurant.ventas.repository.ZonaDespachoRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("ZonaDespachoServiceImpl — Pruebas Unitarias")
class ZonaDespachoServiceImplTest {

    private static final Pageable PAGE = PageRequest.of(0, 20);

    @Mock
    private ZonaDespachoRepository repository;
    @InjectMocks
    private ZonaDespachoServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ==== findById ====

    @Test
    @DisplayName("findById() con ID existente -> retorna entidad")
    void findById_cuandoExiste_retornaEntidad() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity(1L, "ZD01", "1")));

        assertThat(service.findById(1L).getZonaDespacho()).isEqualTo("ZD01");
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("findById() con ID inexistente -> lanza ResourceNotFoundException")
    void findById_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

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
        when(repository.findAllWithFilters(eq("ZD"), eq("Desc"), eq("150101"), eq("1"), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));

        assertThat(service.findAllWithFilters("ZD", "Desc", "150101", "1", PAGE).getContent()).isEmpty();
        verify(repository).findAllWithFilters("ZD", "Desc", "150101", "1", PAGE);
    }

    // ==== create ====

    @Test
    @DisplayName("create() con datos válidos -> persiste con flagEstado ACTIVO")
    void create_conDatosValidos_retornaCreado() {
        ZonaDespacho input = entity(null, "ZD-NEW", null);
        when(repository.existsByZonaDespachoAndFlagEstado("ZD-NEW", "1")).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> {
            ZonaDespacho e = inv.getArgument(0);
            e.setId(10L);
            return e;
        });

        ZonaDespacho result = service.create(input);

        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getCreatedBy()).isEqualTo(1L);
        verify(repository).save(any());
    }

    @Test
    @DisplayName("create() con código duplicado -> lanza BusinessException")
    void create_cuandoCodigoDuplicado_lanzaBusinessException() {
        when(repository.existsByZonaDespachoAndFlagEstado("ZD-DUP", "1")).thenReturn(true);

        assertThatThrownBy(() -> service.create(entity(null, "ZD-DUP", null)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe una zona de despacho con código");
    }

    // ==== update ====

    @Test
    @DisplayName("update() con datos válidos -> actualiza y retorna")
    void update_conDatosValidos_retornaActualizado() {
        ZonaDespacho existing = entity(5L, "OLD", "1");
        ZonaDespacho patch = entity(null, "NEW", null);
        when(repository.findById(5L)).thenReturn(Optional.of(existing));
        when(repository.existsByZonaDespachoAndFlagEstadoAndIdNot("NEW", "1", 5L)).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        assertThat(service.update(5L, patch).getZonaDespacho()).isEqualTo("NEW");
        verify(repository).save(any());
    }

    @Test
    @DisplayName("update() con ID inexistente -> lanza ResourceNotFoundException")
    void update_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(5L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.update(5L, entity(null, "X", null)))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("5");
    }

    // ==== activate / deactivate ====

    @Test
    @DisplayName("activate() con ID existente -> cambia flagEstado a 1")
    void activate_cuandoExiste_cambiaFlagEstado() {
        ZonaDespacho z = entity(3L, "ZD3", "1");
        when(repository.findById(3L)).thenReturn(Optional.of(z));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        assertThat(service.activate(3L).getFlagEstado()).isEqualTo("1");
        verify(repository).save(any());
    }

    @Test
    @DisplayName("activate() con ID inexistente -> lanza ResourceNotFoundException")
    void activate_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.activate(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    @Test
    @DisplayName("deactivate() con ID existente -> cambia flagEstado a 0")
    void deactivate_cuandoExiste_cambiaFlagEstado() {
        ZonaDespacho z = entity(4L, "ZD4", "1");
        when(repository.findById(4L)).thenReturn(Optional.of(z));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        assertThat(service.deactivate(4L).getFlagEstado()).isEqualTo("0");
        verify(repository).save(any());
    }

    @Test
    @DisplayName("deactivate() con ID inexistente -> lanza ResourceNotFoundException")
    void deactivate_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.deactivate(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== delete ====

    @Test
    @DisplayName("delete() con ID existente -> elimina via repository")
    void delete_cuandoExiste_elimina() {
        ZonaDespacho z = entity(6L, "ZD6", "1");
        when(repository.findById(6L)).thenReturn(Optional.of(z));

        service.delete(6L);
        verify(repository).delete(z);
    }

    @Test
    @DisplayName("delete() con ID inexistente -> lanza ResourceNotFoundException")
    void delete_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.delete(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== helpers ====

    private static ZonaDespacho entity(Long id, String codigo, String flag) {
        ZonaDespacho z = new ZonaDespacho();
        z.setId(id);
        z.setZonaDespacho(codigo);
        z.setDescZonaDespacho("Desc " + codigo);
        if (flag != null) {
            z.setFlagEstado(flag);
        }
        return z;
    }
}
