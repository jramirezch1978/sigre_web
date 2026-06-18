package pe.restaurant.ventas.service.impl;

import feign.FeignException;
import feign.Request;
import feign.RequestTemplate;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.service.NumeradorDocumentoService;
import pe.restaurant.ventas.service.VentasNumeradorTablas;
import pe.restaurant.ventas.client.AlmacenClient;
import pe.restaurant.ventas.client.dto.MovimientoDetalleResponse;
import pe.restaurant.ventas.dto.request.DespachoOvRequest;
import pe.restaurant.ventas.dto.response.DespachoOvResponse;
import pe.restaurant.ventas.entity.OrdenVenta;
import pe.restaurant.ventas.repository.OrdenVentaRepository;
import pe.restaurant.ventas.testdata.VentasFase4TestDataFactory;

import java.time.LocalDate;
import java.util.Collections;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class OrdenVentaServiceImplTest {

    @Mock
    private NumeradorDocumentoService numeradorDocumentoService;
    @Mock
    private OrdenVentaRepository repository;
    @Mock
    private AlmacenClient almacenClient;
    @InjectMocks
    private OrdenVentaServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    @Test
    void create_persistsSuccessfully() {
        var req = VentasFase4TestDataFactory.ordenVentaRequest("OV-UNIT-001", 5L);
        when(repository.existsByNroOrdenVenta("OV-UNIT-001")).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> {
            OrdenVenta o = inv.getArgument(0);
            o.setId(100L);
            return o;
        });

        OrdenVenta out = service.create(req);

        assertThat(out.getId()).isEqualTo(100L);
        assertThat(out.getMontoTotal()).isEqualByComparingTo("20.0000");
        verify(repository).save(any());
    }

    @Test
    void create_duplicateNro_throws() {
        var req = VentasFase4TestDataFactory.ordenVentaRequest("OV-DUP", 1L);
        when(repository.existsByNroOrdenVenta("OV-DUP")).thenReturn(true);
        assertThrows(BusinessException.class, () -> service.create(req));
    }

    @Test
    void create_generatesNroWhenBlank() {
        var req = VentasFase4TestDataFactory.ordenVentaRequest(null, 2L);
        when(numeradorDocumentoService.siguienteNroDocumento(
                eq(VentasNumeradorTablas.ORDEN_VENTA), eq(1L), anyInt()))
                .thenReturn("012026000099");
        when(repository.save(any())).thenAnswer(inv -> {
            OrdenVenta o = inv.getArgument(0);
            o.setId(101L);
            return o;
        });

        OrdenVenta out = service.create(req);

        assertThat(out.getNroOrdenVenta()).isEqualTo("012026000099");
    }

    @Test
    void update_savesSuccessfully() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStub(1L);
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(ov));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        var req = VentasFase4TestDataFactory.ordenVentaRequest(null, 1L);

        OrdenVenta out = service.update(1L, req);

        assertThat(out).isNotNull();
    }

    @Test
    void confirmar_savesSuccessfully() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStub(2L);
        when(repository.findByIdWithDetalles(2L)).thenReturn(Optional.of(ov));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        OrdenVenta out = service.confirmar(2L);

        assertThat(out).isNotNull();
    }

    @Test
    void anular_setsFlagEstadoInactivo() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStub(3L);
        when(repository.findByIdWithDetalles(3L)).thenReturn(Optional.of(ov));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        OrdenVenta out = service.anular(3L);

        assertThat(out.getFlagEstado()).isEqualTo("0");
    }

    @Test
    void cerrar_savesSuccessfully() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStub(4L);
        when(repository.findByIdWithDetalles(4L)).thenReturn(Optional.of(ov));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        OrdenVenta out = service.cerrar(4L);

        assertThat(out).isNotNull();
    }

    @Test
    void update_whenInactive_throws() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStub(10L);
        ov.setFlagEstado("0");
        when(repository.findByIdWithDetalles(10L)).thenReturn(Optional.of(ov));
        var req = VentasFase4TestDataFactory.ordenVentaRequest(null, 1L);
        assertThrows(BusinessException.class, () -> service.update(10L, req));
    }

    @Test
    void anular_whenAlreadyInactive_throws() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStub(11L);
        ov.setFlagEstado("0");
        when(repository.findByIdWithDetalles(11L)).thenReturn(Optional.of(ov));
        assertThrows(BusinessException.class, () -> service.anular(11L));
    }

    // ── Despacho en almacén ───────────────────────────────────────────────

    @Test
    void despachar_successfully() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStubConDetalles(10L, 3L);
        when(repository.findByIdWithDetalles(10L)).thenReturn(Optional.of(ov));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        MovimientoDetalleResponse movResp = MovimientoDetalleResponse.builder()
                .id(500L).nroVale("V-001").ordenVentaId(10L).build();
        when(almacenClient.salidaOrdenVenta(any())).thenReturn(ApiResponse.ok(movResp));

        DespachoOvRequest req = DespachoOvRequest.builder()
                .articuloMovTipoId(2L).almacenId(3L)
                .fechaMov(LocalDate.now()).build();

        DespachoOvResponse out = service.despacharEnAlmacen(10L, req);

        assertThat(out.getOrdenVentaId()).isEqualTo(10L);
        assertThat(out.getNroOrdenVenta()).isEqualTo("OV-STUB-10");
        assertThat(out.getMovimiento().getNroVale()).isEqualTo("V-001");
        verify(almacenClient).salidaOrdenVenta(any());
    }

    @Test
    void despachar_ovAnulada_throws() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStubConDetalles(11L, 3L);
        ov.setFlagEstado("0");
        when(repository.findByIdWithDetalles(11L)).thenReturn(Optional.of(ov));

        DespachoOvRequest req = DespachoOvRequest.builder()
                .articuloMovTipoId(2L).almacenId(3L).build();

        BusinessException ex = assertThrows(BusinessException.class,
                () -> service.despacharEnAlmacen(11L, req));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-093");
    }

    @Test
    void despachar_sinLineasParaAlmacen_throws() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStubConDetalles(12L, 3L);
        when(repository.findByIdWithDetalles(12L)).thenReturn(Optional.of(ov));

        DespachoOvRequest req = DespachoOvRequest.builder()
                .articuloMovTipoId(2L).almacenId(999L).build();

        BusinessException ex = assertThrows(BusinessException.class,
                () -> service.despacharEnAlmacen(12L, req));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-094");
    }

    @Test
    void despachar_feignNotFound_throws() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStubConDetalles(13L, 3L);
        when(repository.findByIdWithDetalles(13L)).thenReturn(Optional.of(ov));

        Request feignReq = Request.create(Request.HttpMethod.POST, "/test",
                Map.of(), null, new RequestTemplate());
        when(almacenClient.salidaOrdenVenta(any()))
                .thenThrow(new FeignException.NotFound("Not Found", feignReq,
                        "{\"message\":\"OV no encontrada\"}".getBytes(), Collections.emptyMap()));

        DespachoOvRequest req = DespachoOvRequest.builder()
                .articuloMovTipoId(2L).almacenId(3L).build();

        BusinessException ex = assertThrows(BusinessException.class,
                () -> service.despacharEnAlmacen(13L, req));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-095");
    }

    @Test
    void despachar_feignBadRequest_throws() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStubConDetalles(15L, 3L);
        when(repository.findByIdWithDetalles(15L)).thenReturn(Optional.of(ov));

        Request feignReq = Request.create(Request.HttpMethod.POST, "/test",
                Map.of(), null, new RequestTemplate());
        when(almacenClient.salidaOrdenVenta(any()))
                .thenThrow(new FeignException.BadRequest("Bad Request", feignReq,
                        "{\"message\":\"solicitud inválida\"}".getBytes(), Collections.emptyMap()));

        DespachoOvRequest req = DespachoOvRequest.builder()
                .articuloMovTipoId(2L).almacenId(3L).build();

        BusinessException ex = assertThrows(BusinessException.class,
                () -> service.despacharEnAlmacen(15L, req));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-097");
    }

    @Test
    void despachar_feignUnprocessableEntity_throws() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStubConDetalles(16L, 3L);
        when(repository.findByIdWithDetalles(16L)).thenReturn(Optional.of(ov));

        Request feignReq = Request.create(Request.HttpMethod.POST, "/test",
                Map.of(), null, new RequestTemplate());
        when(almacenClient.salidaOrdenVenta(any()))
                .thenThrow(new FeignException.UnprocessableEntity("Unprocessable", feignReq,
                        "{\"message\":\"validación falló\"}".getBytes(), Collections.emptyMap()));

        DespachoOvRequest req = DespachoOvRequest.builder()
                .articuloMovTipoId(2L).almacenId(3L).build();

        BusinessException ex = assertThrows(BusinessException.class,
                () -> service.despacharEnAlmacen(16L, req));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-096");
    }

    @Test
    void despachar_feignResponseSinMessage_usaDefault() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStubConDetalles(17L, 3L);
        when(repository.findByIdWithDetalles(17L)).thenReturn(Optional.of(ov));

        Request feignReq = Request.create(Request.HttpMethod.POST, "/test",
                Map.of(), null, new RequestTemplate());
        when(almacenClient.salidaOrdenVenta(any()))
                .thenThrow(new FeignException.NotFound("Not Found", feignReq,
                        "{\"error\":\"no encontrado\"}".getBytes(), Collections.emptyMap()));

        DespachoOvRequest req = DespachoOvRequest.builder()
                .articuloMovTipoId(2L).almacenId(3L).build();

        BusinessException ex = assertThrows(BusinessException.class,
                () -> service.despacharEnAlmacen(17L, req));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-095");
        assertThat(ex.getMessage()).contains("OV o almacén no encontrado en ms-almacen");
    }

    @Test
    void create_conDetallesVacios_montoTotalCero() {
        var req = VentasFase4TestDataFactory.ordenVentaRequest("OV-EMPTY", 5L);
        req.setDetalles(java.util.List.of());
        when(repository.existsByNroOrdenVenta("OV-EMPTY")).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> {
            OrdenVenta o = inv.getArgument(0);
            o.setId(200L);
            return o;
        });

        OrdenVenta out = service.create(req);

        assertThat(out.getMontoTotal()).isEqualByComparingTo("0.0000");
    }

    @Test
    void despachar_feignServiceUnavailable_throws() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStubConDetalles(14L, 3L);
        when(repository.findByIdWithDetalles(14L)).thenReturn(Optional.of(ov));

        Request feignReq = Request.create(Request.HttpMethod.POST, "/test",
                Map.of(), null, new RequestTemplate());
        when(almacenClient.salidaOrdenVenta(any()))
                .thenThrow(new FeignException.ServiceUnavailable("Unavailable", feignReq,
                        null, Collections.emptyMap()));

        DespachoOvRequest req = DespachoOvRequest.builder()
                .articuloMovTipoId(2L).almacenId(3L).build();

        BusinessException ex = assertThrows(BusinessException.class,
                () -> service.despacharEnAlmacen(14L, req));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-098");
    }
}
