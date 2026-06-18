package pe.restaurant.almacen.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.almacen.entity.AlmacenTipo;
import pe.restaurant.almacen.repository.AlmacenTipoRepository;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Bloque B: API almacen_tipo — código único y operaciones básicas.
 */
@ExtendWith(MockitoExtension.class)
class AlmacenTipoServiceImplTest {

    @Mock
    private AlmacenTipoRepository repository;
    @InjectMocks
    private AlmacenTipoServiceImpl service;

    @Test
    void create_lanzaSiCodigoDuplicado() {
        AlmacenTipo t = new AlmacenTipo();
        t.setCodigo("FRI");
        t.setNombre("Frío");
        when(repository.existsByCodigoIgnoreCase("FRI")).thenReturn(true);
        assertThatThrownBy(() -> service.create(t))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe un tipo de almacén");
        verify(repository, never()).save(any());
    }

    @Test
    void findById_lanzaSiNoExiste() {
        when(repository.findById(5L)).thenReturn(java.util.Optional.empty());
        assertThatThrownBy(() -> service.findById(5L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void create_persisteYAsignaFlagDefecto() {
        AlmacenTipo t = new AlmacenTipo();
        t.setCodigo("SEC");
        t.setNombre("Seco");
        when(repository.existsByCodigoIgnoreCase("SEC")).thenReturn(false);
        when(repository.save(any(AlmacenTipo.class))).thenAnswer(i -> {
            AlmacenTipo a = i.getArgument(0);
            a.setId(1L);
            return a;
        });
        AlmacenTipo out = service.create(t);
        assertThat(out.getId()).isEqualTo(1L);
        assertThat(out.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void findAll_devuelvePagina() {
        AlmacenTipo t = new AlmacenTipo();
        t.setId(1L);
        t.setCodigo("SEC");
        when(repository.findAll(org.springframework.data.domain.Pageable.unpaged()))
                .thenReturn(new org.springframework.data.domain.PageImpl<>(java.util.List.of(t)));

        assertThat(service.findAll(org.springframework.data.domain.Pageable.unpaged()).getContent()).hasSize(1);
    }

    @Test
    void update_ok() {
        AlmacenTipo existing = new AlmacenTipo();
        existing.setId(2L);
        existing.setCodigo("OLD");
        AlmacenTipo cambios = new AlmacenTipo();
        cambios.setCodigo("NEW");
        cambios.setNombre("Nuevo");
        when(repository.findById(2L)).thenReturn(java.util.Optional.of(existing));
        when(repository.existsByCodigoIgnoreCaseAndIdNot("NEW", 2L)).thenReturn(false);
        when(repository.save(existing)).thenReturn(existing);

        AlmacenTipo out = service.update(2L, cambios);

        assertThat(out.getCodigo()).isEqualTo("NEW");
        assertThat(out.getNombre()).isEqualTo("Nuevo");
    }

    @Test
    void update_lanzaSiCodigoDuplicado() {
        AlmacenTipo existing = new AlmacenTipo();
        existing.setId(3L);
        when(repository.findById(3L)).thenReturn(java.util.Optional.of(existing));
        when(repository.existsByCodigoIgnoreCaseAndIdNot("DUP", 3L)).thenReturn(true);

        AlmacenTipo cambios = new AlmacenTipo();
        cambios.setCodigo("DUP");
        assertThatThrownBy(() -> service.update(3L, cambios))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void activate_deactivate_yDelete() {
        AlmacenTipo t = new AlmacenTipo();
        t.setId(4L);
        when(repository.findById(4L)).thenReturn(java.util.Optional.of(t));
        when(repository.save(t)).thenReturn(t);
        when(repository.existsById(4L)).thenReturn(true);

        assertThat(service.activate(4L).getFlagEstado()).isEqualTo("1");
        assertThat(service.deactivate(4L).getFlagEstado()).isEqualTo("0");
        service.delete(4L);
        verify(repository).deleteById(4L);
    }

    @Test
    void delete_lanzaSiNoExiste() {
        when(repository.existsById(8L)).thenReturn(false);
        assertThatThrownBy(() -> service.delete(8L))
                .isInstanceOf(ResourceNotFoundException.class);
    }
}
