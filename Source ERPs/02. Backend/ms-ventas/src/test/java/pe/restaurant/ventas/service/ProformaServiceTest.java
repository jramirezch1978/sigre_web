package pe.restaurant.ventas.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.service.NumeradorDocumentoService;
import pe.restaurant.ventas.VentasTestFixtures;
import pe.restaurant.ventas.dto.request.ProformaRequest;
import pe.restaurant.ventas.entity.Proforma;
import pe.restaurant.ventas.repository.ProformaRepository;
import pe.restaurant.ventas.service.impl.ProformaServiceImpl;

import java.time.LocalDate;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("ProformaService - Edge Cases")
class ProformaServiceTest {

    @Mock
    private NumeradorDocumentoService numeradorDocumentoService;
    @Mock
    private ProformaRepository repository;
    @InjectMocks
    private ProformaServiceImpl service;

    // ========== EDGE CASES: FIND BY ID ==========

    @Test
    @DisplayName("findById() con ID inexistente -> lanza ResourceNotFoundException")
    void findById_conIdInexistente_lanzaExcepcion() {
        when(repository.findByIdWithDetalles(anyLong())).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(99999L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Proforma")
                .hasMessageContaining("99999");
    }

    // ========== EDGE CASES: CREATE ==========

    @Test
    @DisplayName("create() con número duplicado -> lanza BusinessException")
    void create_conNumeroDuplicado_lanzaExcepcion() {
        ProformaRequest request = new ProformaRequest();
        request.setSucursalId(1L);
        request.setClienteId(1L);
        request.setNumero("PRF-001");
        request.setFecha(LocalDate.now());

        when(repository.existsByNumero("PRF-001")).thenReturn(true);

        assertThatThrownBy(() -> service.create(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Número de proforma duplicado");
    }

    @Test
    @DisplayName("create() sin número y sin sucursalId -> lanza BusinessException")
    void create_sinNumeroYSinSucursalId_lanzaExcepcion() {
        ProformaRequest request = new ProformaRequest();
        request.setSucursalId(null);
        request.setClienteId(1L);
        request.setNumero(null);
        request.setFecha(LocalDate.now());

        assertThatThrownBy(() -> service.create(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sucursalId es obligatoria");
    }

    @Test
    @DisplayName("create() sin número -> genera número automáticamente")
    void create_sinNumero_generaNumeroAutomaticamente() {
        ProformaRequest request = new ProformaRequest();
        request.setSucursalId(1L);
        request.setClienteId(1L);
        request.setNumero(null);
        request.setFecha(LocalDate.now());

        Proforma saved = VentasTestFixtures.proformaEntity(1L, "1");
        
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), anyLong(), anyInt()))
                .thenReturn("PRF-2024-0001");
        when(repository.save(any())).thenReturn(saved);

        Proforma result = service.create(request);

        assertThat(result).isNotNull();
    }

    @Test
    @DisplayName("create() con número en blanco -> genera número automáticamente")
    void create_conNumeroEnBlanco_generaNumeroAutomaticamente() {
        ProformaRequest request = new ProformaRequest();
        request.setSucursalId(1L);
        request.setClienteId(1L);
        request.setNumero("   ");
        request.setFecha(LocalDate.now());

        Proforma saved = VentasTestFixtures.proformaEntity(1L, "1");
        
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), anyLong(), anyInt()))
                .thenReturn("PRF-2024-0002");
        when(repository.save(any())).thenReturn(saved);

        Proforma result = service.create(request);

        assertThat(result).isNotNull();
    }
}
