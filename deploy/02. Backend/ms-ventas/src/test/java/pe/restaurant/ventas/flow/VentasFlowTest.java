package pe.restaurant.ventas.flow;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.service.NumeradorDocumentoService;
import pe.restaurant.ventas.client.AlmacenClient;
import pe.restaurant.ventas.client.dto.MovimientoDetalleResponse;
import pe.restaurant.ventas.dto.request.DespachoOvRequest;
import pe.restaurant.ventas.dto.response.DespachoOvResponse;
import pe.restaurant.ventas.entity.OrdenVenta;
import pe.restaurant.ventas.repository.OrdenVentaRepository;
import pe.restaurant.ventas.service.VentasNumeradorTablas;
import pe.restaurant.ventas.service.impl.OrdenVentaServiceImpl;
import pe.restaurant.ventas.testdata.VentasFase4TestDataFactory;

import java.time.LocalDate;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Flujos de negocio con servicios reales y repos mockeados (patrón {@code ComprasFlowTest}).
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("Flujos de negocio — Ventas")
class VentasFlowTest {

    @Mock private OrdenVentaRepository repository;
    @Mock private NumeradorDocumentoService numeradorDocumentoService;
    @Mock private AlmacenClient almacenClient;

    @InjectMocks private OrdenVentaServiceImpl ordenVentaService;

    @BeforeEach
    void tenant() {
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void clearTenant() {
        TenantContext.clear();
    }

    @Test
    @DisplayName("Flujo OV: crear → confirmar → despachar en almacén")
    void flujoOrdenVenta_crearConfirmarDespachar() {
        var req = VentasFase4TestDataFactory.ordenVentaRequest("OV-FLOW-001", 50L);
        when(repository.existsByNroOrdenVenta("OV-FLOW-001")).thenReturn(false);
        when(repository.save(any(OrdenVenta.class))).thenAnswer(inv -> {
            OrdenVenta o = inv.getArgument(0);
            if (o.getId() == null) {
                o.setId(10L);
            }
            return o;
        });

        OrdenVenta creada = ordenVentaService.create(req);
        assertThat(creada.getId()).isEqualTo(10L);

        OrdenVenta activa = VentasFase4TestDataFactory.ordenVentaStubConDetalles(10L, 3L);
        when(repository.findByIdWithDetalles(10L)).thenReturn(Optional.of(activa));

        OrdenVenta confirmada = ordenVentaService.confirmar(10L);
        assertThat(confirmada).isNotNull();

        MovimientoDetalleResponse mov = MovimientoDetalleResponse.builder()
                .id(500L).nroVale("V-FLOW-001").ordenVentaId(10L).build();
        when(almacenClient.salidaOrdenVenta(any())).thenReturn(ApiResponse.ok(mov));

        DespachoOvRequest despachoReq = DespachoOvRequest.builder()
                .articuloMovTipoId(2L)
                .almacenId(3L)
                .fechaMov(LocalDate.now())
                .build();
        DespachoOvResponse despacho = ordenVentaService.despacharEnAlmacen(10L, despachoReq);

        assertThat(despacho.getOrdenVentaId()).isEqualTo(10L);
        assertThat(despacho.getMovimiento().getNroVale()).isEqualTo("V-FLOW-001");
        verify(almacenClient).salidaOrdenVenta(any());
    }

    @Test
    @DisplayName("Flujo OV: numerador corporativo cuando nro viene vacío")
    void flujoOrdenVenta_numeradorAutomatico() {
        var req = VentasFase4TestDataFactory.ordenVentaRequest(null, 50L);
        when(numeradorDocumentoService.siguienteNroDocumento(
                eq(VentasNumeradorTablas.ORDEN_VENTA), eq(1L), anyInt()))
                .thenReturn("012026000099");
        when(repository.save(any(OrdenVenta.class))).thenAnswer(inv -> {
            OrdenVenta o = inv.getArgument(0);
            o.setId(11L);
            o.setNroOrdenVenta("012026000099");
            return o;
        });

        OrdenVenta out = ordenVentaService.create(req);

        assertThat(out.getNroOrdenVenta()).isEqualTo("012026000099");
        verify(numeradorDocumentoService).siguienteNroDocumento(
                eq(VentasNumeradorTablas.ORDEN_VENTA), eq(1L), anyInt());
    }
}
