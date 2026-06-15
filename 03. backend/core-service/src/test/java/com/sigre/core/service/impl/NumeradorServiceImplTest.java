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
import com.sigre.core.entity.Numerador;
import com.sigre.core.repository.NumeradorRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class NumeradorServiceImplTest {

    @Mock private NumeradorRepository repository;
    @InjectMocks private NumeradorServiceImpl service;

    private Numerador numerador;

    @BeforeEach
    void setUp() {
        numerador = new Numerador("FACTURA", "Numerador Factura", "F001", 100L, 8);
        numerador.setId(1L);
    }

    @Nested class FindAll {
        @Test void returnsPage() {
            var pageable = PageRequest.of(0, 20);
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(numerador)));
            assertThat(service.findAll(pageable).getContent()).hasSize(1);
        }
    }

    @Nested class FindById {
        @Test void found() {
            when(repository.findById(1L)).thenReturn(Optional.of(numerador));
            assertThat(service.findById(1L).getCodigo()).isEqualTo("FACTURA");
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Create {
        @Test void success() {
            when(repository.findByCodigo("FACTURA")).thenReturn(Optional.empty());
            when(repository.save(numerador)).thenReturn(numerador);
            assertThat(service.create(numerador).getCodigo()).isEqualTo("FACTURA");
        }
        @Test void duplicateCodigo() {
            when(repository.findByCodigo("FACTURA")).thenReturn(Optional.of(numerador));
            Numerador dup = new Numerador("FACTURA", "Otro", null, 0L, null);
            assertThatThrownBy(() -> service.create(dup)).isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Update {
        @Test void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(numerador));
            when(repository.findByCodigo("FACTURA")).thenReturn(Optional.of(numerador));
            when(repository.save(any())).thenReturn(numerador);
            assertThat(service.update(1L, numerador)).isNotNull();
        }
        @Test void duplicateCodigoOther() {
            Numerador other = new Numerador("BOLETA", "Boleta", null, 0L, null);
            other.setId(2L);
            when(repository.findById(1L)).thenReturn(Optional.of(numerador));
            when(repository.findByCodigo("BOLETA")).thenReturn(Optional.of(other));
            Numerador upd = new Numerador("BOLETA", "test", null, 0L, null);
            assertThatThrownBy(() -> service.update(1L, upd)).isInstanceOf(BusinessException.class);
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, numerador)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Siguiente {
        @Test void incrementsAndReturnsNext() {
            when(repository.findByCodigoForUpdate("FACTURA")).thenReturn(Optional.of(numerador));
            when(repository.save(any())).thenReturn(numerador);
            Long next = service.siguiente("FACTURA");
            assertThat(next).isEqualTo(101L);
            assertThat(numerador.getUltimoNumero()).isEqualTo(101L);
        }

        @Test void throwsWhenNotFound() {
            when(repository.findByCodigoForUpdate("NOEXISTE")).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.siguiente("NOEXISTE"))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test void throwsWhenInactive() {
            numerador.setFlagEstado("0");
            when(repository.findByCodigoForUpdate("FACTURA")).thenReturn(Optional.of(numerador));
            assertThatThrownBy(() -> service.siguiente("FACTURA"))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("inactivo");
        }
    }
}