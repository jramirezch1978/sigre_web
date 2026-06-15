package com.sigre.compras.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import com.sigre.compras.dto.*;
import com.sigre.compras.service.OrdenCompraPdfService;
import com.sigre.compras.service.OrdenCompraService;
import com.sigre.common.dto.ApiResponse;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("OrdenCompraController — Pruebas Unitarias")
class OrdenCompraControllerTest {

    @Mock private OrdenCompraService ordenCompraService;
    @Mock private OrdenCompraPdfService ordenCompraPdfService;
    @InjectMocks private OrdenCompraController controller;

    private OrdenCompraDetalleResponse detalleResponse;
    private OrdenCompraResumenResponse resumenResponse;

    @BeforeEach
    void setUp() {
        detalleResponse = OrdenCompraDetalleResponse.builder()
                .id(1L)
                .sucursalId(1L)
                .proveedorId(1L)
                .nroOrdenCompra("OC-001")
                .fechaEmision(LocalDate.now())
                .monedaId(1L)
                .flagEstado("1")
                .total(new BigDecimal("1000"))
                .lineas(Collections.emptyList())
                .build();

        resumenResponse = OrdenCompraResumenResponse.builder()
                .id(1L)
                .nroOrdenCompra("OC-001")
                .flagEstado("1")
                .total(new BigDecimal("1000"))
                .build();
    }

    @Test
    @DisplayName("listar() retorna page data")
    void listar_retornaPageData() {
        var page = new PageImpl<>(List.of(resumenResponse));
        when(ordenCompraService.listar(any(), any(), any(), any(), any(), any(), any(), any()))
                .thenReturn(page);

        ApiResponse<PageData<OrdenCompraResumenResponse>> result = controller.listar(
                null, null, null, null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("pendientesAprobacion() retorna page data")
    void pendientesAprobacion_retornaPageData() {
        var page = new PageImpl<>(List.of(resumenResponse));
        when(ordenCompraService.pendientesAprobacion(any())).thenReturn(page);

        var result = controller.pendientesAprobacion(Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("obtener() retorna detalle")
    void obtener_retornaDetalle() {
        when(ordenCompraService.obtener(1L)).thenReturn(detalleResponse);

        var result = controller.obtener(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("crear() retorna detalle")
    void crear_retornaDetalle() {
        when(ordenCompraService.crear(any(OrdenCompraCabeceraRequest.class))).thenReturn(detalleResponse);

        var result = controller.crear(new OrdenCompraCabeceraRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creada");
    }

    @Test
    @DisplayName("actualizar() retorna detalle")
    void actualizar_retornaDetalle() {
        when(ordenCompraService.actualizar(eq(1L), any(OrdenCompraCabeceraRequest.class)))
                .thenReturn(detalleResponse);

        var result = controller.actualizar(1L, new OrdenCompraCabeceraRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizada");
    }

    @Test
    @DisplayName("modificarIgv() retorna detalle")
    void modificarIgv_retornaDetalle() {
        when(ordenCompraService.modificarIgv(eq(1L), any(ModificarIgvRequest.class)))
                .thenReturn(detalleResponse);

        var result = controller.modificarIgv(1L, new ModificarIgvRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("IGV");
    }

    @Test
    @DisplayName("enviarAprobacion() retorna detalle")
    void enviarAprobacion_retornaDetalle() {
        when(ordenCompraService.enviarAprobacion(1L)).thenReturn(detalleResponse);

        var result = controller.enviarAprobacion(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("aprobación");
    }

    @Test
    @DisplayName("aprobar() con observacion -> retorna detalle")
    void aprobar_conObservacion_retornaDetalle() {
        when(ordenCompraService.aprobar(eq(1L), eq("OK"))).thenReturn(detalleResponse);

        OrdenCompraObservacionRequest body = new OrdenCompraObservacionRequest();
        body.setObservacion("OK");
        var result = controller.aprobar(1L, body);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("aprobada");
    }

    @Test
    @DisplayName("aprobar() sin body -> retorna detalle")
    void aprobar_sinBody_retornaDetalle() {
        when(ordenCompraService.aprobar(eq(1L), isNull())).thenReturn(detalleResponse);

        var result = controller.aprobar(1L, null);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    @DisplayName("rechazar() retorna detalle")
    void rechazar_retornaDetalle() {
        when(ordenCompraService.rechazar(eq(1L), eq("No cumple"))).thenReturn(detalleResponse);

        OrdenCompraMotivoRequest req = new OrdenCompraMotivoRequest();
        req.setMotivo("No cumple");
        var result = controller.rechazar(1L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("rechazada");
    }

    @Test
    @DisplayName("devolver() con motivo -> retorna detalle")
    void devolver_conMotivo_retornaDetalle() {
        when(ordenCompraService.devolver(eq(1L), eq("Falta almacén"))).thenReturn(detalleResponse);

        OrdenCompraMotivoRequest req = new OrdenCompraMotivoRequest();
        req.setMotivo("Falta almacén");
        var result = controller.devolver(1L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("devuelta");
    }

    @Test
    @DisplayName("devolver() sin body -> retorna detalle")
    void devolver_sinBody_retornaDetalle() {
        when(ordenCompraService.devolver(eq(1L), isNull())).thenReturn(detalleResponse);

        var result = controller.devolver(1L, null);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    @DisplayName("anular() retorna detalle")
    void anular_retornaDetalle() {
        when(ordenCompraService.anular(eq(1L), eq("Por error"))).thenReturn(detalleResponse);

        OrdenCompraMotivoRequest req = new OrdenCompraMotivoRequest();
        req.setMotivo("Por error");
        var result = controller.anular(1L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("anulada");
    }

    @Test
    @DisplayName("cerrar() retorna detalle")
    void cerrar_retornaDetalle() {
        when(ordenCompraService.cerrar(1L)).thenReturn(detalleResponse);

        var result = controller.cerrar(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("cerrada");
    }

    @Test
    @DisplayName("historial() retorna lista")
    void historial_retornaLista() {
        HistorialAprobacionResponse h = HistorialAprobacionResponse.builder()
                .id(1L).accion("APROBADA").nivel(1).fecha(OffsetDateTime.now()).build();
        when(ordenCompraService.historial(1L)).thenReturn(List.of(h));

        var result = controller.historial(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
    }

    @Test
    @DisplayName("recepciones() retorna lista")
    void recepciones_retornaLista() {
        when(ordenCompraService.recepciones(1L)).thenReturn(Collections.emptyList());

        var result = controller.recepciones(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).isEmpty();
    }

    @Test
    @DisplayName("saldoPendiente() retorna respuesta")
    void saldoPendiente_retornaRespuesta() {
        OrdenCompraSaldoPendienteResponse sp = OrdenCompraSaldoPendienteResponse.builder()
                .ordenCompraId(1L).totalPedido(new BigDecimal("1000"))
                .lineas(Collections.emptyList()).build();
        when(ordenCompraService.saldoPendiente(1L)).thenReturn(sp);

        var result = controller.saldoPendiente(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getOrdenCompraId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("datosArticulo() retorna respuesta")
    void datosArticulo_retornaRespuesta() {
        DatosArticuloResponse da = DatosArticuloResponse.builder()
                .precioPactado(new BigDecimal("50"))
                .unidadMedidaId(1L)
                .build();
        when(ordenCompraService.datosArticulo(any(), any(), any(), any(), any())).thenReturn(da);

        var result = controller.datosArticulo(1L, 1L, 1L, 1L, LocalDate.now());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getPrecioPactado()).isEqualByComparingTo("50");
    }

    @Test
    @DisplayName("enviarProveedor() retorna true")
    void enviarProveedor_retornaTrue() {
        when(ordenCompraService.enviarProveedor(eq(1L), any())).thenReturn(true);

        var result = controller.enviarProveedor(1L, null);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).isTrue();
    }

    @Test
    @DisplayName("pdf() retorna bytes")
    void pdf_retornaBytes() {
        byte[] pdfBytes = new byte[]{1, 2, 3, 4, 5};
        when(ordenCompraPdfService.generarPdf(1L)).thenReturn(pdfBytes);

        ResponseEntity<byte[]> result = controller.pdf(1L);

        assertThat(result.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(result.getBody()).hasSize(5);
        assertThat(result.getHeaders().getFirst("Content-Disposition")).contains("OC-1.pdf");
    }
}
