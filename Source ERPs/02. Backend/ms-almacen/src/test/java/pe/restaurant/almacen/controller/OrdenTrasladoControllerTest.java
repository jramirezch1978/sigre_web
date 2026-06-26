package pe.restaurant.almacen.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import pe.restaurant.almacen.dto.OrdenTrasladoLineaRequest;
import pe.restaurant.almacen.dto.OrdenTrasladoRequest;
import pe.restaurant.almacen.dto.OrdenTrasladoResponse;
import pe.restaurant.almacen.service.OrdenTrasladoOperacionService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OrdenTrasladoControllerTest {

    @Mock
    private OrdenTrasladoOperacionService service;

    @InjectMocks
    private OrdenTrasladoController controller;

    private OrdenTrasladoResponse response;

    @BeforeEach
    void setUp() {
        response = OrdenTrasladoResponse.builder()
                .id(1L)
                .almacenOrigenId(10L)
                .almacenDestinoId(20L)
                .numero("OT-001")
                .fecha(LocalDate.of(2026, 5, 2))
                .flagEstado("1")
                .build();
    }

    @Test
    void buscar_delegates() {
        var page = new PageImpl<>(List.of(response));
        when(service.buscar(isNull(), isNull(), isNull(), isNull(), isNull(), any(Pageable.class))).thenReturn(page);

        var result = controller.buscar(null, null, null, null, null, Pageable.unpaged());

        assertThat(result.getData().getContent()).hasSize(1);
        assertThat(result.getData().getContent().get(0).getNumero()).isEqualTo("OT-001");
    }

    @Test
    void obtener_returnsOne() {
        when(service.obtener(1L)).thenReturn(response);

        assertThat(controller.obtener(1L).getData().getFlagEstado()).isEqualTo("1");
        verify(service).obtener(1L);
    }

    @Test
    void crear_returnsMessage() {
        OrdenTrasladoRequest req = sampleRequest();
        when(service.crear(any())).thenReturn(response);

        var result = controller.crear(req);

        assertThat(result.getMessage()).isEqualTo("Orden de traslado creada");
        verify(service).crear(req);
    }

    @Test
    void actualizar_aprobar_cambiarEstado_delegate() {
        OrdenTrasladoRequest req = sampleRequest();
        when(service.actualizar(1L, req)).thenReturn(response);

        assertThat(controller.actualizar(1L, req).getMessage()).isEqualTo("Orden actualizada");

        when(service.aprobar(9L)).thenReturn(response);
        assertThat(controller.aprobar(9L).getMessage()).isEqualTo("Orden aprobada");
        verify(service).aprobar(9L);

        when(service.cambiarEstado(1L, "APROBADA")).thenReturn(response);
        assertThat(controller.cambiarEstado(1L, "APROBADA").getMessage()).isEqualTo("Estado actualizado");
    }

    @Test
    void rechazar_cerrar_anular_delegan() {
        when(service.rechazar(2L)).thenReturn(response);
        when(service.cerrar(3L)).thenReturn(response);
        when(service.anular(4L)).thenReturn(response);

        assertThat(controller.rechazar(2L).getMessage()).isEqualTo("Orden rechazada");
        assertThat(controller.cerrar(3L).getMessage()).isEqualTo("Orden cerrada");
        assertThat(controller.anular(4L).getMessage()).isEqualTo("Orden anulada");

        verify(service).rechazar(2L);
        verify(service).cerrar(3L);
        verify(service).anular(4L);
    }

    @Test
    void exportarExcel_getYPost_delegan() {
        byte[] xlsx = new byte[]{0x50, 0x4B};
        when(service.exportarExcel(eq(10L), isNull(), eq("BORRADOR"), isNull(), isNull())).thenReturn(xlsx);

        ResponseEntity<byte[]> getResp = controller.exportarExcelGet(10L, null, "BORRADOR", null, null);
        ResponseEntity<byte[]> postResp = controller.exportarExcelPost(10L, null, "BORRADOR", null, null);

        assertThat(getResp.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(postResp.getBody()).isEqualTo(xlsx);
        verify(service, times(2)).exportarExcel(10L, null, "BORRADOR", null, null);
    }

    @Test
    void pdf_getYPost_delegan() {
        byte[] pdf = "%PDF".getBytes();
        when(service.generarPdf(7L)).thenReturn(pdf);

        assertThat(controller.pdfGet(7L).getBody()).isEqualTo(pdf);
        assertThat(controller.pdfPost(7L).getBody()).isEqualTo(pdf);
        verify(service, times(2)).generarPdf(7L);
    }

    private static OrdenTrasladoRequest sampleRequest() {
        OrdenTrasladoLineaRequest linea = new OrdenTrasladoLineaRequest();
        linea.setArticuloId(100L);
        linea.setCantidad(new BigDecimal("10"));
        OrdenTrasladoRequest req = new OrdenTrasladoRequest();
        req.setAlmacenOrigenId(10L);
        req.setAlmacenDestinoId(20L);
        req.setFecha(LocalDate.of(2026, 5, 2));
        req.setLineas(List.of(linea));
        return req;
    }
}
