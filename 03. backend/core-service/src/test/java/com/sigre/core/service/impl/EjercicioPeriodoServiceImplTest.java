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
import org.springframework.data.domain.Pageable;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.core.entity.EjercicioPeriodo;
import com.sigre.core.repository.EjercicioPeriodoRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class EjercicioPeriodoServiceImplTest {

    @Mock private EjercicioPeriodoRepository repository;
    @InjectMocks private EjercicioPeriodoServiceImpl service;

    private EjercicioPeriodo ejercicio;
    private final Pageable pageable = PageRequest.of(0, 20);

    @BeforeEach
    void setUp() {
        ejercicio = new EjercicioPeriodo(2026,
                LocalDate.of(2026, 1, 1), LocalDate.of(2026, 12, 31));
        ejercicio.setId(1L);
    }

    @Nested class FindAll {
        @Test void noFilters() {
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(ejercicio)));
            assertThat(service.findAll(null, pageable).getContent()).hasSize(1);
        }
        @Test void filterByAnioOnly() {
            when(repository.findByAnio(2026, pageable)).thenReturn(new PageImpl<>(List.of(ejercicio)));
            assertThat(service.findAll(2026, pageable).getContent()).hasSize(1);
        }
    }

    @Nested class FindById {
        @Test void found() {
            when(repository.findById(1L)).thenReturn(Optional.of(ejercicio));
            assertThat(service.findById(1L).getAnio()).isEqualTo(2026);
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Create {
        @Test void success() {
            when(repository.findByAnio(2026)).thenReturn(Optional.empty());
            when(repository.save(ejercicio)).thenReturn(ejercicio);
            assertThat(service.create(ejercicio).getAnio()).isEqualTo(2026);
        }
        @Test void duplicateAnio() {
            when(repository.findByAnio(2026)).thenReturn(Optional.of(ejercicio));
            EjercicioPeriodo dup = new EjercicioPeriodo(2026, null, null);
            assertThatThrownBy(() -> service.create(dup)).isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Update {
        @Test void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(ejercicio));
            when(repository.findByAnio(2026)).thenReturn(Optional.of(ejercicio));
            when(repository.save(any())).thenReturn(ejercicio);
            assertThat(service.update(1L, ejercicio)).isNotNull();
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, ejercicio)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Deactivate {
        @Test void setsFlagEstadoCerrado() {
            when(repository.findById(1L)).thenReturn(Optional.of(ejercicio));
            when(repository.save(any())).thenReturn(ejercicio);
            service.deactivate(1L);
            assertThat(ejercicio.getFlagEstado()).isEqualTo("2");
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivate(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
