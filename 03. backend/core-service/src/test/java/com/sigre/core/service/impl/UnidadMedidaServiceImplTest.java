package com.sigre.core.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.core.entity.UnidadMedida;
import com.sigre.core.repository.UnidadMedidaRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UnidadMedidaServiceImplTest {

    @Mock private UnidadMedidaRepository repository;
    @InjectMocks private UnidadMedidaServiceImpl service;

    private UnidadMedida unidad;

    @BeforeEach
    void setUp() {
        unidad = new UnidadMedida();
        unidad.setId(1L);
        unidad.setCodigo("KG");
        unidad.setNombre("Kilogramo");
        unidad.setAbreviatura("kg");
        unidad.setFlagEstado("1");
    }

    @Nested class FindAll {
        @Test void returnsPage() {
            var pageable = PageRequest.of(0, 20);
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(unidad)));
            assertThat(service.findAll(pageable).getContent()).hasSize(1);
        }
    }

    @Nested class FindById {
        @Test void found() {
            when(repository.findById(1L)).thenReturn(Optional.of(unidad));
            assertThat(service.findById(1L).getCodigo()).isEqualTo("KG");
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Create {
        @Test void success() {
            when(repository.findByCodigo("KG")).thenReturn(Optional.empty());
            when(repository.save(unidad)).thenReturn(unidad);
            assertThat(service.create(unidad).getCodigo()).isEqualTo("KG");
        }
        @Test void duplicate() {
            when(repository.findByCodigo("KG")).thenReturn(Optional.of(unidad));
            UnidadMedida dup = new UnidadMedida();
            dup.setId(2L);
            dup.setCodigo("KG");
            assertThatThrownBy(() -> service.create(dup)).isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Update {
        @Test void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(unidad));
            when(repository.findByCodigo("KG")).thenReturn(Optional.of(unidad));
            when(repository.save(any())).thenReturn(unidad);
            assertThat(service.update(1L, unidad)).isNotNull();
        }
        @Test void duplicateOther() {
            UnidadMedida other = new UnidadMedida();
            other.setId(2L);
            other.setCodigo("LT");
            when(repository.findById(1L)).thenReturn(Optional.of(unidad));
            when(repository.findByCodigo("LT")).thenReturn(Optional.of(other));
            UnidadMedida upd = new UnidadMedida();
            upd.setCodigo("LT");
            assertThatThrownBy(() -> service.update(1L, upd)).isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Deactivate {
        @Test void setsActivoFalse() {
            when(repository.findById(1L)).thenReturn(Optional.of(unidad));
            when(repository.save(any())).thenReturn(unidad);
            service.deactivate(1L);
            assertThat(unidad.getFlagEstado()).isEqualTo("0");
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivate(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
