package com.sigre.almacen.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.almacen.entity.UbicacionAlmacen;
import com.sigre.almacen.repository.AlmacenRepository;
import com.sigre.almacen.repository.UbicacionAlmacenRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UbicacionAlmacenServiceImplTest {

    @Mock
    private UbicacionAlmacenRepository repository;
    @Mock
    private AlmacenRepository almacenRepository;
    @InjectMocks
    private UbicacionAlmacenServiceImpl service;

    private UbicacionAlmacen ubicacion;

    @BeforeEach
    void setUp() {
        ubicacion = new UbicacionAlmacen();
        ubicacion.setId(1L);
        ubicacion.setAlmacenId(10L);
        ubicacion.setCodigo("U1");
        ubicacion.setNombre("Ubic 1");
        ubicacion.setPasillo("P1");
        ubicacion.setEstante("E1");
        ubicacion.setNivel("N1");
    }

    @Test
    void findByAlmacenId_devuelveLista() {
        when(repository.findByAlmacenId(10L)).thenReturn(List.of(ubicacion));

        List<UbicacionAlmacen> list = service.findByAlmacenId(10L);

        assertThat(list).hasSize(1);
        assertThat(list.get(0).getCodigo()).isEqualTo("U1");
        verify(repository).findByAlmacenId(10L);
    }

    @Test
    void findById_ok() {
        when(repository.findById(1L)).thenReturn(Optional.of(ubicacion));

        UbicacionAlmacen found = service.findById(1L);

        assertThat(found.getId()).isEqualTo(1L);
        assertThat(found.getCodigo()).isEqualTo("U1");
    }

    @Test
    void findById_notFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void create_ok() {
        UbicacionAlmacen nueva = new UbicacionAlmacen();
        nueva.setAlmacenId(10L);
        nueva.setCodigo("U2");
        nueva.setNombre("Ubic 2");
        when(almacenRepository.existsById(10L)).thenReturn(true);
        when(repository.existsByAlmacenIdAndCodigoIgnoreCase(10L, "U2")).thenReturn(false);
        when(repository.save(any(UbicacionAlmacen.class))).thenAnswer(i -> {
            UbicacionAlmacen u = i.getArgument(0);
            u.setId(2L);
            return u;
        });

        UbicacionAlmacen saved = service.create(nueva);

        assertThat(saved.getId()).isEqualTo(2L);
        verify(repository).save(nueva);
    }

    @Test
    void create_lanzaSiAlmacenNoExiste() {
        UbicacionAlmacen u = new UbicacionAlmacen();
        u.setAlmacenId(99L);
        u.setCodigo("U1");
        when(almacenRepository.existsById(99L)).thenReturn(false);

        assertThatThrownBy(() -> service.create(u))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository, never()).save(any());
    }

    @Test
    void create_lanzaSiCodigoDuplicado() {
        UbicacionAlmacen u = new UbicacionAlmacen();
        u.setAlmacenId(10L);
        u.setCodigo("U1");
        when(almacenRepository.existsById(10L)).thenReturn(true);
        when(repository.existsByAlmacenIdAndCodigoIgnoreCase(10L, "U1")).thenReturn(true);

        assertThatThrownBy(() -> service.create(u))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe una ubicacion");
        verify(repository, never()).save(any());
    }

    @Test
    void update_ok() {
        UbicacionAlmacen cambios = new UbicacionAlmacen();
        cambios.setCodigo("U1B");
        cambios.setNombre("Ubic actualizada");
        cambios.setPasillo("P2");
        cambios.setEstante("E2");
        cambios.setNivel("N2");
        when(repository.findById(1L)).thenReturn(Optional.of(ubicacion));
        when(repository.existsByAlmacenIdAndCodigoIgnoreCaseAndIdNot(10L, "U1B", 1L)).thenReturn(false);
        when(repository.save(any(UbicacionAlmacen.class))).thenAnswer(i -> i.getArgument(0));

        UbicacionAlmacen updated = service.update(1L, cambios);

        assertThat(updated.getNombre()).isEqualTo("Ubic actualizada");
        assertThat(updated.getPasillo()).isEqualTo("P2");
        verify(repository).save(ubicacion);
    }

    @Test
    void update_lanzaSiCodigoDuplicado() {
        UbicacionAlmacen cambios = new UbicacionAlmacen();
        cambios.setCodigo("DUP");
        when(repository.findById(1L)).thenReturn(Optional.of(ubicacion));
        when(repository.existsByAlmacenIdAndCodigoIgnoreCaseAndIdNot(10L, "DUP", 1L)).thenReturn(true);

        assertThatThrownBy(() -> service.update(1L, cambios))
                .isInstanceOf(BusinessException.class);
        verify(repository, never()).save(any());
    }

    @Test
    void delete_ok() {
        when(repository.findById(1L)).thenReturn(Optional.of(ubicacion));

        service.delete(1L);

        verify(repository).delete(ubicacion);
    }
}
