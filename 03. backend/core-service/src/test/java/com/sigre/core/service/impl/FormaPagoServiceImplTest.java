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
import com.sigre.core.entity.FormaPago;
import com.sigre.core.repository.FormaPagoRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class FormaPagoServiceImplTest {

    @Mock private FormaPagoRepository repository;
    @InjectMocks private FormaPagoServiceImpl service;

    private FormaPago forma;

    @BeforeEach
    void setUp() {
        forma = new FormaPago();
        forma.setId(1L);
        forma.setCodigo("EFECTIVO");
        forma.setNombre("Pago en efectivo");
        forma.setFlagEstado("1");
    }

    @Nested class FindAll {
        @Test void returnsPage() {
            when(repository.findAll(PageRequest.of(0, 20))).thenReturn(new PageImpl<>(List.of(forma)));
            assertThat(service.findAll(PageRequest.of(0, 20)).getContent()).hasSize(1);
        }
    }

    @Nested class FindById {
        @Test void found() {
            when(repository.findById(1L)).thenReturn(Optional.of(forma));
            assertThat(service.findById(1L).getCodigo()).isEqualTo("EFECTIVO");
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Create {
        @Test void success() {
            when(repository.findByCodigo("EFECTIVO")).thenReturn(Optional.empty());
            when(repository.save(forma)).thenReturn(forma);
            assertThat(service.create(forma)).isNotNull();
        }
        @Test void duplicate() {
            when(repository.findByCodigo("EFECTIVO")).thenReturn(Optional.of(forma));
            FormaPago dup = new FormaPago();
            dup.setId(2L);
            dup.setCodigo("EFECTIVO");
            assertThatThrownBy(() -> service.create(dup)).isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Update {
        @Test void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(forma));
            when(repository.findByCodigo("EFECTIVO")).thenReturn(Optional.of(forma));
            when(repository.save(any())).thenReturn(forma);
            assertThat(service.update(1L, forma)).isNotNull();
        }
        @Test void duplicateOther() {
            FormaPago other = new FormaPago();
            other.setId(2L);
            other.setCodigo("TARJETA");
            when(repository.findById(1L)).thenReturn(Optional.of(forma));
            when(repository.findByCodigo("TARJETA")).thenReturn(Optional.of(other));
            FormaPago upd = new FormaPago();
            upd.setCodigo("TARJETA");
            assertThatThrownBy(() -> service.update(1L, upd)).isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Deactivate {
        @Test void setsActivoFalse() {
            when(repository.findById(1L)).thenReturn(Optional.of(forma));
            when(repository.save(any())).thenReturn(forma);
            service.deactivate(1L);
            assertThat(forma.getFlagEstado()).isEqualTo("0");
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivate(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
