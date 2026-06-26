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
import pe.restaurant.ventas.client.AlmacenClient;
import pe.restaurant.ventas.dto.request.OrdenVentaRequest;
import pe.restaurant.ventas.entity.OrdenVenta;
import pe.restaurant.ventas.repository.OrdenVentaRepository;
import pe.restaurant.ventas.service.impl.OrdenVentaServiceImpl;

import java.time.LocalDate;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("OrdenVentaService - Edge Cases")
class OrdenVentaServiceTest {

    @Mock
    private NumeradorDocumentoService numeradorDocumentoService;
    @Mock
    private OrdenVentaRepository repository;
    @Mock
    private AlmacenClient almacenClient;
    @InjectMocks
    private OrdenVentaServiceImpl service;

    // ========== EDGE CASES: FIND BY ID ==========

    @Test
    @DisplayName("findById() con ID inexistente -> lanza ResourceNotFoundException")
    void findById_conIdInexistente_lanzaExcepcion() {
        when(repository.findByIdWithDetalles(anyLong())).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(99999L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("OrdenVenta")
                .hasMessageContaining("99999");
    }

    // ========== EDGE CASES: CREATE ==========

    @Test
    @DisplayName("create() con número duplicado -> lanza BusinessException")
    void create_conNumeroDuplicado_lanzaExcepcion() {
        OrdenVentaRequest request = new OrdenVentaRequest();
        request.setSucursalId(1L);
        request.setClienteId(1L);
        request.setNroOrdenVenta("OV-001");
        request.setFechaEmision(LocalDate.now());

        when(repository.existsByNroOrdenVenta("OV-001")).thenReturn(true);

        assertThatThrownBy(() -> service.create(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Número de orden ya existe");
    }

    @Test
    @DisplayName("create() sin número -> genera número automáticamente")
    void create_sinNumero_generaNumeroAutomaticamente() {
        OrdenVentaRequest request = new OrdenVentaRequest();
        request.setSucursalId(1L);
        request.setClienteId(1L);
        request.setNroOrdenVenta(null);
        request.setFechaEmision(LocalDate.now());

        OrdenVenta saved = VentasTestFixtures.ordenVentaEntity(1L, "1");
        
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), anyLong(), anyInt()))
                .thenReturn("OV-2024-0001");
        when(repository.save(any())).thenReturn(saved);

        OrdenVenta result = service.create(request);

        assertThat(result).isNotNull();
    }

    @Test
    @DisplayName("create() con número en blanco -> genera número automáticamente")
    void create_conNumeroEnBlanco_generaNumeroAutomaticamente() {
        OrdenVentaRequest request = new OrdenVentaRequest();
        request.setSucursalId(1L);
        request.setClienteId(1L);
        request.setNroOrdenVenta("   ");
        request.setFechaEmision(LocalDate.now());

        OrdenVenta saved = VentasTestFixtures.ordenVentaEntity(1L, "1");
        
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), anyLong(), anyInt()))
                .thenReturn("OV-2024-0002");
        when(repository.save(any())).thenReturn(saved);

        OrdenVenta result = service.create(request);

        assertThat(result).isNotNull();
    }
}
