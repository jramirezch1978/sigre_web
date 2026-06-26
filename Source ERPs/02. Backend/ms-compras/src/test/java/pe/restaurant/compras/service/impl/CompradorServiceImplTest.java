package pe.restaurant.compras.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.compras.entity.Comprador;
import pe.restaurant.compras.repository.ArticuloCategoriaRefRepository;
import pe.restaurant.compras.entity.CompradorCategoria;
import pe.restaurant.compras.repository.CompradorCategoriaRepository;
import pe.restaurant.compras.repository.CompradorRepository;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static pe.restaurant.compras.ComprasTestFixtures.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CompradorServiceImpl — Pruebas Unitarias")
class CompradorServiceImplTest {

    @Mock private CompradorRepository repository;
    @Mock private CompradorCategoriaRepository categoriaRepository;
    @Mock private ArticuloCategoriaRefRepository articuloCategoriaRefRepository;
    @Mock private JdbcTemplate securityJdbcTemplate;

    private CompradorServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new CompradorServiceImpl(repository, categoriaRepository, articuloCategoriaRefRepository, securityJdbcTemplate);
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ── findAll ──

    @Test
    @DisplayName("findAll() retorna página")
    void findAll_retornaPagina() {
        Comprador c = comprador(1L);
        Page<Comprador> page = new PageImpl<>(List.of(c));
        when(repository.findAll(any(Pageable.class))).thenReturn(page);

        Page<Comprador> result = service.findAll(PageRequest.of(0, 10));

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getId()).isEqualTo(1L);
    }

    // ── findById ──

    @Test
    @DisplayName("findById() existente -> ok")
    void findById_existente_ok() {
        Comprador c = comprador(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(c));

        Comprador result = service.findById(1L);

        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNombre()).isEqualTo("Comprador Test");
    }

    @Test
    @DisplayName("findById() no existente -> lanza excepción")
    void findById_noExistente_lanzaExcepcion() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── create ──

    @Test
    @DisplayName("create() con usuario id -> ok")
    void create_conUsuarioId_ok() {
        when(securityJdbcTemplate.queryForObject(contains("auth.usuario"), eq(Integer.class), any()))
                .thenReturn(1);
        Comprador entity = comprador(null);
        entity.setUsuarioId(5L);
        Comprador saved = comprador(1L);
        when(repository.save(entity)).thenReturn(saved);

        Comprador result = service.create(entity);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(securityJdbcTemplate).queryForObject(contains("auth.usuario"), eq(Integer.class), eq(5L));
    }

    @Test
    @DisplayName("create() sin usuario id -> usa tenant context")
    void create_sinUsuarioId_usaTenantContext() {
        when(securityJdbcTemplate.queryForObject(contains("auth.usuario"), eq(Integer.class), any()))
                .thenReturn(1);
        Comprador entity = comprador(null);
        entity.setUsuarioId(null);
        Comprador saved = comprador(1L);
        when(repository.save(entity)).thenReturn(saved);

        Comprador result = service.create(entity);

        assertThat(result).isNotNull();
        assertThat(entity.getUsuarioId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("create() sin usuario id y sin tenant -> lanza excepción")
    void create_sinUsuarioIdYSinTenant_lanzaExcepcion() {
        TenantContext.setUsuarioId(null);
        Comprador entity = comprador(null);
        entity.setUsuarioId(null);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("usuarioId");
    }

    @Test
    @DisplayName("create() usuario ya registrado como comprador -> lanza excepción")
    void create_usuarioYaRegistrado_lanzaExcepcion() {
        when(securityJdbcTemplate.queryForObject(contains("auth.usuario"), eq(Integer.class), any()))
                .thenReturn(1);
        when(repository.existsByUsuarioId(5L)).thenReturn(true);
        Comprador entity = comprador(null);
        entity.setUsuarioId(5L);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe un comprador registrado para este usuario");
    }

    @Test
    @DisplayName("create() usuario no existe -> lanza excepción")
    void create_usuarioNoExiste_lanzaExcepcion() {
        when(securityJdbcTemplate.queryForObject(contains("auth.usuario"), eq(Integer.class), any()))
                .thenReturn(0);
        Comprador entity = comprador(null);
        entity.setUsuarioId(999L);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── update ──

    @Test
    @DisplayName("update() ok -> actualiza campos no null")
    void update_ok_actualizaCamposNoNull() {
        Comprador existing = comprador(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(securityJdbcTemplate.queryForObject(contains("auth.usuario"), eq(Integer.class), any()))
                .thenReturn(1);
        when(repository.save(existing)).thenReturn(existing);

        Comprador toUpdate = new Comprador();
        toUpdate.setUsuarioId(5L);
        toUpdate.setNombre("Nuevo Nombre");
        toUpdate.setFlagEstado("0");

        Comprador result = service.update(1L, toUpdate);

        assertThat(result).isNotNull();
        assertThat(existing.getUsuarioId()).isEqualTo(5L);
        assertThat(existing.getNombre()).isEqualTo("Nuevo Nombre");
        assertThat(existing.getFlagEstado()).isEqualTo("0");
    }

    // ── delete ──

    @Test
    @DisplayName("delete() ok")
    void delete_ok() {
        Comprador existing = comprador(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));

        service.delete(1L);

        verify(repository).deleteById(1L);
    }

    // ── activate / deactivate ──

    @Test
    @DisplayName("activate() ok")
    void activate_ok() {
        Comprador existing = comprador(1L);
        existing.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);

        Comprador result = service.activate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("deactivate() ok")
    void deactivate_ok() {
        Comprador existing = comprador(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);

        Comprador result = service.deactivate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    // ── categorias ──

    @Test
    @DisplayName("findCategorias() ok")
    void findCategorias_ok() {
        Comprador c = comprador(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(categoriaRepository.findByCompradorId(1L)).thenReturn(List.of(compradorCategoria(1L, 1L, 10L)));

        List<CompradorCategoria> result = service.findCategorias(1L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getArticuloCategId()).isEqualTo(10L);
    }

    @Test
    @DisplayName("assignCategoria() ok")
    void assignCategoria_ok() {
        Comprador c = comprador(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(articuloCategoriaRefRepository.existsById(10L)).thenReturn(true);
        when(categoriaRepository.existsByCompradorIdAndArticuloCategId(1L, 10L)).thenReturn(false);
        when(categoriaRepository.save(any(CompradorCategoria.class))).thenReturn(compradorCategoria(1L, 1L, 10L));

        CompradorCategoria result = service.assignCategoria(1L, 10L);

        assertThat(result).isNotNull();
        assertThat(result.getArticuloCategId()).isEqualTo(10L);
    }

    @Test
    @DisplayName("assignCategoria() ya asignada -> lanza excepción")
    void assignCategoria_yaAsignada_lanzaExcepcion() {
        Comprador c = comprador(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(articuloCategoriaRefRepository.existsById(10L)).thenReturn(true);
        when(categoriaRepository.existsByCompradorIdAndArticuloCategId(1L, 10L)).thenReturn(true);

        assertThatThrownBy(() -> service.assignCategoria(1L, 10L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ya está asignada");
    }

    @Test
    @DisplayName("assignCategoria() categoria no existe -> lanza excepción")
    void assignCategoria_categoriaNoExiste_lanzaExcepcion() {
        Comprador c = comprador(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(articuloCategoriaRefRepository.existsById(999L)).thenReturn(false);

        assertThatThrownBy(() -> service.assignCategoria(1L, 999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

}
