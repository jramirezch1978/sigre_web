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
import com.sigre.core.entity.NaturalezaContable;
import com.sigre.core.repository.NaturalezaContableRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class NaturalezaContableServiceImplTest {

    @Mock private NaturalezaContableRepository repository;
    @InjectMocks private NaturalezaContableServiceImpl service;

    private NaturalezaContable nat;

    @BeforeEach
    void setUp() {
        nat = new NaturalezaContable();
        nat.setId(1L);
        nat.setCodigo("GTO");
        nat.setNombre("Gasto");
        nat.setCuentaContable("6000");
        nat.setFlagEstado("1");
    }

    @Nested class FindAll {
        @Test void returnsPage() {
            when(repository.findAll(PageRequest.of(0, 20))).thenReturn(new PageImpl<>(List.of(nat)));
            assertThat(service.findAll(PageRequest.of(0, 20)).getContent()).hasSize(1);
        }
    }

    @Nested class FindById {
        @Test void found() {
            when(repository.findById(1L)).thenReturn(Optional.of(nat));
            assertThat(service.findById(1L).getCodigo()).isEqualTo("GTO");
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Create {
        @Test void success() {
            when(repository.findByCodigo("GTO")).thenReturn(Optional.empty());
            when(repository.save(nat)).thenReturn(nat);
            assertThat(service.create(nat)).isNotNull();
        }
        @Test void duplicate() {
            when(repository.findByCodigo("GTO")).thenReturn(Optional.of(nat));
            NaturalezaContable dup = new NaturalezaContable();
            dup.setId(2L);
            dup.setCodigo("GTO");
            assertThatThrownBy(() -> service.create(dup)).isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Update {
        @Test void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(nat));
            when(repository.findByCodigo("GTO")).thenReturn(Optional.of(nat));
            when(repository.save(any())).thenReturn(nat);
            assertThat(service.update(1L, nat)).isNotNull();
        }
        @Test void duplicateOther() {
            NaturalezaContable other = new NaturalezaContable();
            other.setId(2L);
            other.setCodigo("ING");
            when(repository.findById(1L)).thenReturn(Optional.of(nat));
            when(repository.findByCodigo("ING")).thenReturn(Optional.of(other));
            NaturalezaContable upd = new NaturalezaContable();
            upd.setCodigo("ING");
            assertThatThrownBy(() -> service.update(1L, upd)).isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Deactivate {
        @Test void setsActivoFalse() {
            when(repository.findById(1L)).thenReturn(Optional.of(nat));
            when(repository.save(any())).thenReturn(nat);
            service.deactivate(1L);
            assertThat(nat.getFlagEstado()).isEqualTo("0");
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivate(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
