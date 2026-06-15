package com.sigre.comercializacion.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.comercializacion.entity.Comanda;
import com.sigre.comercializacion.repository.ComandaRepository;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

/**
 * Tests de Branch Coverage para ComandaServiceImpl
 * Cubre los branches condicionales principales
 */
@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class ComandaServiceImplBranchTest {

    @Mock
    private ComandaRepository repository;

    @InjectMocks
    private ComandaServiceImpl service;

    @Test
    void getById_conIdInexistente_lanzaResourceNotFoundException() {
        // Given
        when(repository.findById(999L)).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> service.getById(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }
}
