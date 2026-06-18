package pe.restaurant.compras.service.impl;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.compras.entity.ArticuloEstructura;
import pe.restaurant.compras.entity.ArticuloEstructuraId;
import pe.restaurant.compras.repository.ArticuloEstructuraRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static pe.restaurant.compras.ComprasTestFixtures.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ArticuloEstructuraServiceImpl — Pruebas Unitarias")
class ArticuloEstructuraServiceImplTest {

    @Mock private ArticuloEstructuraRepository repository;

    @InjectMocks private ArticuloEstructuraServiceImpl service;

    // ── findAll ──

    @Test
    @DisplayName("findAll() sin filtro -> retorna find all")
    void findAll_sinFiltro_retornaFindAll() {
        Page<ArticuloEstructura> page = new PageImpl<>(List.of(articuloEstructura(1L, 2L)));
        when(repository.findAll(any(Pageable.class))).thenReturn(page);

        Page<ArticuloEstructura> result = service.findAll(null, PageRequest.of(0, 10));

        assertThat(result.getContent()).hasSize(1);
        verify(repository).findAll(any(Pageable.class));
        verify(repository, never()).findByArticuloPadreId(anyLong(), any(Pageable.class));
    }

    @Test
    @DisplayName("findAll() con artículo padre id -> retorna find by artículo padre id")
    void findAll_conArticuloPadreId_retornaFindByArticuloPadreId() {
        Page<ArticuloEstructura> page = new PageImpl<>(List.of(articuloEstructura(1L, 2L)));
        when(repository.findByArticuloPadreId(eq(1L), any(Pageable.class))).thenReturn(page);

        Page<ArticuloEstructura> result = service.findAll(1L, PageRequest.of(0, 10));

        assertThat(result.getContent()).hasSize(1);
        verify(repository).findByArticuloPadreId(eq(1L), any(Pageable.class));
    }

    // ── findById ──

    @Test
    @DisplayName("findById() existente -> ok")
    void findById_existente_ok() {
        ArticuloEstructuraId id = new ArticuloEstructuraId(1L, 2L);
        ArticuloEstructura entity = articuloEstructura(1L, 2L);
        when(repository.findById(id)).thenReturn(Optional.of(entity));

        ArticuloEstructura result = service.findById(id);

        assertThat(result).isNotNull();
        assertThat(result.getArticuloPadreId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("findById() no existente -> lanza excepción")
    void findById_noExistente_lanzaExcepcion() {
        ArticuloEstructuraId id = new ArticuloEstructuraId(99L, 98L);
        when(repository.findById(id)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(id))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── create ──

    @Test
    @DisplayName("create() ok")
    void create_ok() {
        ArticuloEstructura entity = articuloEstructura(1L, 2L);
        ArticuloEstructuraId id = new ArticuloEstructuraId(1L, 2L);
        when(repository.existsById(id)).thenReturn(false);
        when(repository.save(entity)).thenReturn(entity);

        ArticuloEstructura result = service.create(entity);

        assertThat(result).isNotNull();
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("create() padre igual hijo -> lanza excepción")
    void create_padreIgualHijo_lanzaExcepcion() {
        ArticuloEstructura entity = articuloEstructura(1L, 1L);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("padre");
    }

    @Test
    @DisplayName("create() ya existe -> lanza excepción")
    void create_yaExiste_lanzaExcepcion() {
        ArticuloEstructura entity = articuloEstructura(1L, 2L);
        ArticuloEstructuraId id = new ArticuloEstructuraId(1L, 2L);
        when(repository.existsById(id)).thenReturn(true);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe");
    }

    // ── update ──

    @Test
    @DisplayName("update() ok")
    void update_ok() {
        ArticuloEstructuraId id = new ArticuloEstructuraId(1L, 2L);
        ArticuloEstructura existing = articuloEstructura(1L, 2L);
        when(repository.findById(id)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);

        ArticuloEstructura updated = articuloEstructura(1L, 2L);
        updated.setCantidad(new BigDecimal("5"));
        ArticuloEstructura result = service.update(id, updated);

        assertThat(result).isNotNull();
        verify(repository).save(existing);
    }

    // ── delete ──

    @Test
    @DisplayName("delete() ok")
    void delete_ok() {
        ArticuloEstructuraId id = new ArticuloEstructuraId(1L, 2L);
        ArticuloEstructura existing = articuloEstructura(1L, 2L);
        when(repository.findById(id)).thenReturn(Optional.of(existing));

        service.delete(id);

        verify(repository).deleteById(id);
    }

    @Test
    @DisplayName("delete() no existe -> lanza excepción")
    void delete_noExiste_lanzaExcepcion() {
        ArticuloEstructuraId id = new ArticuloEstructuraId(99L, 98L);
        when(repository.findById(id)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.delete(id))
                .isInstanceOf(ResourceNotFoundException.class);
    }

}
