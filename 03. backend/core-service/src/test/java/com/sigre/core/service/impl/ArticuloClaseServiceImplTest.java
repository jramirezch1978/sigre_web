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
import com.sigre.core.entity.ArticuloClase;
import com.sigre.core.repository.ArticuloClaseRepository;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ArticuloClaseServiceImplTest {

    @Mock private ArticuloClaseRepository repository;
    @InjectMocks private ArticuloClaseServiceImpl service;

    private ArticuloClase clase;

    @BeforeEach
    void setUp() {
        clase = new ArticuloClase("CLS01", "Clase uno");
        clase.setId(1L);
    }

    @Nested class FindAll {
        @Test void returnsPagedResults() {
            var pageable = PageRequest.of(0, 10);
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(clase)));
            assertThat(service.findAll(pageable).getContent()).hasSize(1);
        }

        @Test void returnsEmptyPage() {
            var pageable = PageRequest.of(0, 10);
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(Collections.emptyList()));
            assertThat(service.findAll(pageable).getContent()).isEmpty();
        }
    }

    @Nested class FindById {
        @Test void found() {
            when(repository.findById(1L)).thenReturn(Optional.of(clase));
            assertThat(service.findById(1L).getCodClase()).isEqualTo("CLS01");
        }

        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Create {
        @Test void success() {
            when(repository.existsByCodClaseIgnoreCase("CLS01")).thenReturn(false);
            when(repository.save(clase)).thenReturn(clase);
            assertThat(service.create(clase).getId()).isEqualTo(1L);
        }

        @Test void duplicateCodClaseThrowsConflict() {
            when(repository.existsByCodClaseIgnoreCase("CLS01")).thenReturn(true);
            assertThatThrownBy(() -> service.create(clase))
                    .isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Update {
        @Test void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(clase));
            when(repository.existsByCodClaseIgnoreCaseAndIdNot("CLS01", 1L)).thenReturn(false);
            when(repository.save(any())).thenReturn(clase);
            assertThat(service.update(1L, clase)).isNotNull();
        }

        @Test void notFoundThrows() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, clase))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test void duplicateCodClaseInOtherRecordThrowsConflict() {
            when(repository.findById(1L)).thenReturn(Optional.of(clase));
            when(repository.existsByCodClaseIgnoreCaseAndIdNot("DUP", 1L)).thenReturn(true);
            ArticuloClase upd = new ArticuloClase("DUP", "Duplicado");
            assertThatThrownBy(() -> service.update(1L, upd))
                    .isInstanceOf(BusinessException.class);
        }

        @Test void setsIdFromPath() {
            when(repository.findById(1L)).thenReturn(Optional.of(clase));
            when(repository.existsByCodClaseIgnoreCaseAndIdNot("NEW", 1L)).thenReturn(false);
            ArticuloClase upd = new ArticuloClase("NEW", "Nueva");
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            assertThat(service.update(1L, upd).getId()).isEqualTo(1L);
        }
    }

    @Nested class Activate {
        @Test void setsFlagEstadoToOne() {
            clase.setFlagEstado("0");
            when(repository.findById(1L)).thenReturn(Optional.of(clase));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            assertThat(service.activate(1L).getFlagEstado()).isEqualTo("1");
        }

        @Test void notFoundThrows() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activate(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Deactivate {
        @Test void setsFlagEstadoToZero() {
            when(repository.findById(1L)).thenReturn(Optional.of(clase));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            assertThat(service.deactivate(1L).getFlagEstado()).isEqualTo("0");
        }

        @Test void notFoundThrows() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivate(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Delete {
        @Test void deletesExistingEntity() {
            when(repository.findById(1L)).thenReturn(Optional.of(clase));
            service.delete(1L);
            verify(repository).deleteById(1L);
        }

        @Test void notFoundThrows() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.delete(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
