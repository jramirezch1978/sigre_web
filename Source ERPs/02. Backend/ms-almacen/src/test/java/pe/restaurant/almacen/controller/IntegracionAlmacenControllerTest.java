package pe.restaurant.almacen.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.almacen.dto.IntegracionProduccionCosteoRequest;
import pe.restaurant.almacen.dto.IntegracionRecepcionOcRequest;
import pe.restaurant.almacen.dto.MovimientoDetalleResponse;
import pe.restaurant.almacen.dto.ProcesoCosteoAlmacenResponse;
import pe.restaurant.almacen.service.IntegracionAlmacenService;
import pe.restaurant.almacen.service.ProduccionCosteoAlmacenService;
import pe.restaurant.common.dto.ApiResponse;

import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class IntegracionAlmacenControllerTest {

    @Mock
    private IntegracionAlmacenService integracionAlmacenService;

    @Mock
    private ProduccionCosteoAlmacenService produccionCosteoAlmacenService;

    @InjectMocks
    private IntegracionAlmacenController controller;

    private MovimientoDetalleResponse detalleResponse;

    @BeforeEach
    void setUp() {
        detalleResponse = MovimientoDetalleResponse.builder()
                .id(88L)
                .sucursalId(1L)
                .almacenId(3L)
                .articuloMovTipoId(7L)
                .nroVale("VALE-OC-001")
                .fechaMov(LocalDate.of(2026, 4, 28))
                .flagEstado("1")
                .lineas(List.of())
                .build();
    }

    @Test
    void recepcionOrdenCompra_delegaServicioYDevuelveOk() {
        when(integracionAlmacenService.recepcionarOrdenCompra(any(IntegracionRecepcionOcRequest.class)))
                .thenReturn(detalleResponse);

        IntegracionRecepcionOcRequest req = new IntegracionRecepcionOcRequest();
        req.setOrdenCompraId(10L);
        req.setArticuloMovTipoId(7L);
        req.setAlmacenId(3L);

        ApiResponse<MovimientoDetalleResponse> res = controller.recepcionOrdenCompra(req);

        assertThat(res.isSuccess()).isTrue();
        assertThat(res.getData().getId()).isEqualTo(88L);
        assertThat(res.getData().getNroVale()).isEqualTo("VALE-OC-001");
        assertThat(res.getMessage()).contains("Ingreso");
        verify(integracionAlmacenService).recepcionarOrdenCompra(req);
    }

    @Test
    void aplicarCosteoProduccion_delegaServicioYDevuelveOk() {
        ProcesoCosteoAlmacenResponse proceso = ProcesoCosteoAlmacenResponse.builder()
                .anio(2026)
                .mes(5)
                .mensaje("Costeo aplicado")
                .build();
        when(produccionCosteoAlmacenService.aplicarCosteoEnAlmacen(any())).thenReturn(proceso);

        IntegracionProduccionCosteoRequest req = IntegracionProduccionCosteoRequest.builder()
                .anio(2026)
                .mes(5)
                .totalOtsProcesadas(2)
                .totalCreadas(1)
                .totalActualizadas(1)
                .build();

        ApiResponse<ProcesoCosteoAlmacenResponse> res = controller.aplicarCosteoProduccion(req);

        assertThat(res.isSuccess()).isTrue();
        assertThat(res.getData().getMensaje()).isEqualTo("Costeo aplicado");
        verify(produccionCosteoAlmacenService).aplicarCosteoEnAlmacen(any());
    }
}
