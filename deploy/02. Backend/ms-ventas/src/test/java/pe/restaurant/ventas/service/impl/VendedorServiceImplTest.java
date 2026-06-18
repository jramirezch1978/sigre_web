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
import pe.restaurant.ventas.entity.Vendedor;
import pe.restaurant.ventas.repository.VendedorRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("VendedorServiceImpl — Pruebas Unitarias")
class VendedorServiceImplTest {

    private static final Pageable PAGE = PageRequest.of(0, 20);

    @Mock
    private VendedorRepository repository;
    @InjectMocks
    private VendedorServiceImpl service;

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
        when(repository.findById(1L)).thenReturn(Optional.of(entity(1L, 100L, "1")));

        assertThat(service.findById(1L).getUsuarioId()).isEqualTo(100L);
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
        when(repository.findAllWithFilters(eq(100L), eq("Juan"), eq("1"), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));

        assertThat(service.findAllWithFilters(100L, "Juan", "1", PAGE).getContent()).isEmpty();
        verify(repository).findAllWithFilters(100L, "Juan", "1", PAGE);
    }

    // ==== create ====

    @Test
    @DisplayName("create() con datos válidos -> persiste con flagEstado ACTIVO")
    void create_conDatosValidos_retornaCreado() {
        Vendedor input = entity(null, 200L, null);
        when(repository.existsUsuarioActivo(200L)).thenReturn(true);
        when(repository.existsByUsuarioIdAndFlagEstado(200L, "1")).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> {
            Vendedor e = inv.getArgument(0);
            e.setId(10L);
            return e;
        });

        Vendedor result = service.create(input);

        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getCreatedBy()).isEqualTo(1L);
        verify(repository).save(any());
    }

    @Test
    @DisplayName("create() con usuario FK inválido -> lanza BusinessException")
    void create_cuandoUsuarioFkInvalido_lanzaBusinessException() {
        Vendedor input = entity(null, 200L, null);
        when(repository.existsUsuarioActivo(200L)).thenReturn(false);

        assertThatThrownBy(() -> service.create(input))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("El usuario indicado no existe");
    }

    @Test
    @DisplayName("create() con usuario duplicado -> lanza BusinessException")
    void create_cuandoUsuarioDuplicado_lanzaBusinessException() {
        Vendedor input = entity(null, 200L, null);
        when(repository.existsUsuarioActivo(200L)).thenReturn(true);
        when(repository.existsByUsuarioIdAndFlagEstado(200L, "1")).thenReturn(true);

        assertThatThrownBy(() -> service.create(input))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe un vendedor para el usuario");
    }

    // ==== update ====

    @Test
    @DisplayName("update() con datos válidos -> actualiza y retorna")
    void update_conDatosValidos_retornaActualizado() {
        Vendedor existing = entity(5L, 100L, "1");
        Vendedor patch = entity(null, 101L, null);
        patch.setNombre("Vendedor B");
        when(repository.findById(5L)).thenReturn(Optional.of(existing));
        when(repository.existsUsuarioActivo(101L)).thenReturn(true);
        when(repository.existsByUsuarioIdAndFlagEstadoAndIdNot(101L, "1", 5L)).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(repository.findByIdWithRelations(5L)).thenReturn(Optional.of(existing));

        Vendedor result = service.update(5L, patch);

        assertThat(result.getNombre()).isEqualTo("Vendedor B");
        assertThat(result.getUsuarioId()).isEqualTo(101L);
        verify(repository).save(any());
    }

    @Test
    @DisplayName("update() con ID inexistente -> lanza ResourceNotFoundException")
    void update_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(5L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.update(5L, entity(null, 1L, null)))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("5");
    }

    // ==== activate / deactivate ====

    @Test
    @DisplayName("activate() con ID existente -> cambia flagEstado a 1 y recarga relaciones")
    void activate_cuandoExiste_cambiaFlagEstado() {
        Vendedor v = entity(3L, 100L, "0");
        when(repository.findById(3L)).thenReturn(Optional.of(v));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(repository.findByIdWithRelations(3L)).thenReturn(Optional.of(v));

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
    @DisplayName("deactivate() con ID existente -> cambia flagEstado a 0 y recarga relaciones")
    void deactivate_cuandoExiste_cambiaFlagEstado() {
        Vendedor v = entity(4L, 100L, "1");
        when(repository.findById(4L)).thenReturn(Optional.of(v));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(repository.findByIdWithRelations(4L)).thenReturn(Optional.of(v));

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
        Vendedor v = entity(3L, 100L, "1");
        when(repository.findById(3L)).thenReturn(Optional.of(v));

        service.delete(3L);

        verify(repository).delete(v);
    }

    @Test
    @DisplayName("delete() con ID inexistente -> lanza ResourceNotFoundException")
    void delete_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.delete(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== findByUsuarioId ====

    @Test
    @DisplayName("findByUsuarioId() con usuario existente -> retorna vendedor")
    void findByUsuarioId_cuandoExiste_retornaVendedor() {
        when(repository.findByUsuarioIdAndActivo(100L)).thenReturn(Optional.of(entity(1L, 100L, "1")));

        assertThat(service.findByUsuarioId(100L).getUsuarioId()).isEqualTo(100L);
        verify(repository).findByUsuarioIdAndActivo(100L);
    }

    @Test
    @DisplayName("findByUsuarioId() con usuario inexistente -> lanza ResourceNotFoundException")
    void findByUsuarioId_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findByUsuarioIdAndActivo(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findByUsuarioId(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("usuarioId");
    }

    // ==== helpers ====

    private static Vendedor entity(Long id, Long usuarioId, String flag) {
        Vendedor v = new Vendedor();
        v.setId(id);
        v.setUsuarioId(usuarioId);
        v.setNombre("Vendedor " + usuarioId);
        v.setComisionPorcentaje(new BigDecimal("5.00"));
        if (flag != null) {
            v.setFlagEstado(flag);
        }
        return v;
    }
}
