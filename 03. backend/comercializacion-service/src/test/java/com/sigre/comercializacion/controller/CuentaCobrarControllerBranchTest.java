package com.sigre.comercializacion.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.comercializacion.service.CuentaCobrarService;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

/**
 * Tests de Branch Coverage para CuentaCobrarController
 * Cubre los branches condicionales principales
 */
@ExtendWith(MockitoExtension.class)
class CuentaCobrarControllerBranchTest {

    @Mock
    private CuentaCobrarService cuentaCobrarService;

    @InjectMocks
    private CuentaCobrarController controller;

    @Test
    void findById_conIdInexistente_lanzaResourceNotFoundException() {
        // Given
        when(cuentaCobrarService.findByIdWithMovimientos(999L)).thenThrow(new ResourceNotFoundException("Cuenta por cobrar", 999L));

        // When & Then
        assertThatThrownBy(() -> controller.findById(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }
}
