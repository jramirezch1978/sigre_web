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
import pe.restaurant.ventas.entity.CanalDistribucion;
import pe.restaurant.ventas.repository.CanalDistribucionRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("CanalDistribucionServiceImpl — Pruebas Unitarias")
class CanalDistribucionServiceImplTest {

    private static final Pageable PAGE = PageRequest.of(0, 20);

    @Mock
    private CanalDistribucionRepository repository;
    @InjectMocks
    private CanalDistribucionServiceImpl service;

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
        when(repository.findById(1L)).thenReturn(Optional.of(entity(1L, "CD01", "1")));

        assertThat(service.findById(1L).getCodigo()).isEqualTo("CD01");
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
        when(repository.findAllWithFilters(eq("CD"), eq("Canal"), eq("1"), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));

        assertThat(service.findAllWithFilters("CD", "Canal", "1", PAGE).getContent()).isEmpty();
        verify(repository).findAllWithFilters("CD", "Canal", "1", PAGE);
    }

    // ==== create ====

    @Test
    @DisplayName("create() con datos válidos -> persiste con flagEstado ACTIVO")
    void create_conDatosValidos_retornaCreado() {
        CanalDistribucion input = entity(null, "CD-NEW", null);
        when(repository.existsByCodigoAndFlagEstado("CD-NEW", "1")).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> {
            CanalDistribucion e = inv.getArgument(0);
            e.setId(10L);
            return e;
        });

        CanalDistribucion result = service.create(input);

        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getCreatedBy()).isEqualTo(1L);
        verify(repository).save(any());
    }

    @Test
    @DisplayName("create() con código duplicado -> lanza BusinessException")
    void create_cuandoCodigoDuplicado_lanzaBusinessException() {
        CanalDistribucion input = entity(null, "CD-DUP", null);
        when(repository.existsByCodigoAndFlagEstado("CD-DUP", "1")).thenReturn(true);

        assertThatThrownBy(() -> service.create(input))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe un canal de distribución con código");
    }

    // ==== update ====

    @Test
    @DisplayName("update() con datos válidos -> actualiza y retorna")
    void update_conDatosValidos_retornaActualizado() {
        CanalDistribucion existing = entity(5L, "OLD", "1");
        CanalDistribucion patch = entity(null, "NEW", null);
        patch.setNombre("Actualizado");
        when(repository.findById(5L)).thenReturn(Optional.of(existing));
        when(repository.existsByCodigoAndFlagEstadoAndIdNot("NEW", "1", 5L)).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        CanalDistribucion result = service.update(5L, patch);

        assertThat(result.getCodigo()).isEqualTo("NEW");
        assertThat(result.getNombre()).isEqualTo("Actualizado");
        assertThat(result.getUpdatedBy()).isEqualTo(1L);
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
        CanalDistribucion c = entity(3L, "CD03", "0");
        when(repository.findById(3L)).thenReturn(Optional.of(c));
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
        CanalDistribucion c = entity(4L, "CD04", "1");
        when(repository.findById(4L)).thenReturn(Optional.of(c));
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
        CanalDistribucion c = entity(6L, "CD06", "1");
        when(repository.findById(6L)).thenReturn(Optional.of(c));

        service.delete(6L);

        verify(repository).delete(c);
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

    private static CanalDistribucion entity(Long id, String codigo, String flag) {
        CanalDistribucion c = new CanalDistribucion();
        c.setId(id);
        c.setCodigo(codigo);
        c.setNombre("Canal " + codigo);
        if (flag != null) {
            c.setFlagEstado(flag);
        }
        return c;
    }
}
