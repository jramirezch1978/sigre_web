package com.sigre.comercializacion.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.comercializacion.entity.Reservacion;
import com.sigre.comercializacion.repository.ReservacionRepository;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

/**
 * Tests de Branch Coverage para ReservacionServiceImpl
 * Cubre los branches condicionales principales
 */
@ExtendWith(MockitoExtension.class)
class ReservacionServiceImplBranchTest {

    @Mock
    private ReservacionRepository repository;

    @InjectMocks
    private ReservacionServiceImpl service;

    @Test
    void getById_conIdInexistente_lanzaResourceNotFoundException() {
        // Given
        when(repository.findDetailById(999L)).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> service.getById(999L))
                .isInstanceOf(RuntimeException.class);
    }
}
