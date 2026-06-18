package pe.restaurant.ventas.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.ventas.entity.PedidoMesa;
import pe.restaurant.ventas.repository.PedidoMesaRepository;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

/**
 * Tests de Branch Coverage para PedidoMesaServiceImpl
 * Cubre los branches condicionales principales
 */
@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class PedidoMesaServiceImplBranchTest {

    @Mock
    private PedidoMesaRepository repository;

    @InjectMocks
    private PedidoMesaServiceImpl service;

    @Test
    void getById_conIdInexistente_lanzaResourceNotFoundException() {
        // Given
        when(repository.findById(999L)).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> service.getById(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }
}
