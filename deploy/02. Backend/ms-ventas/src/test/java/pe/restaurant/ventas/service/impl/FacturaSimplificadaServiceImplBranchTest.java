package pe.restaurant.ventas.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.ventas.entity.FsFacturaSimpl;
import pe.restaurant.ventas.repository.FsFacturaSimplRepository;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

/**
 * Tests de Branch Coverage para FacturaSimplificadaServiceImpl
 * Cubre los branches condicionales principales
 */
@ExtendWith(MockitoExtension.class)
class FacturaSimplificadaServiceImplBranchTest {

    @Mock
    private FsFacturaSimplRepository fsRepository;

    @InjectMocks
    private FacturaSimplificadaServiceImpl service;

    @Test
    void loadFull_conIdInexistente_lanzaResourceNotFoundException() {
        // Given
        when(fsRepository.findById(999L)).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> {
            try {
                var method = FacturaSimplificadaServiceImpl.class.getDeclaredMethod("loadFull", Long.class);
                method.setAccessible(true);
                method.invoke(service, 999L);
            } catch (Exception e) {
                if (e.getCause() instanceof ResourceNotFoundException) {
                    throw (ResourceNotFoundException) e.getCause();
                }
                throw new RuntimeException(e);
            }
        }).isInstanceOf(ResourceNotFoundException.class)
          .hasMessageContaining("FacturaSimplificada");
    }

    @Test
    void requireActivo_conFacturaInactiva_lanzaBusinessException() {
        // Given
        FsFacturaSimpl facturaInactiva = new FsFacturaSimpl();
        facturaInactiva.setId(1L);
        facturaInactiva.setFlagEstado("0"); // Inactiva

        // When & Then
        assertThatThrownBy(() -> {
            try {
                var method = FacturaSimplificadaServiceImpl.class.getDeclaredMethod("requireActivo", FsFacturaSimpl.class);
                method.setAccessible(true);
                method.invoke(service, facturaInactiva);
            } catch (Exception e) {
                if (e.getCause() instanceof BusinessException) {
                    throw (BusinessException) e.getCause();
                }
                throw new RuntimeException(e);
            }
        }).isInstanceOf(BusinessException.class)
          .hasMessage("Factura inactiva");
    }
}
