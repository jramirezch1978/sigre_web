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
import com.sigre.compras.service.OrdenServicioPdfService;
import com.sigre.compras.service.OrdenServicioService;
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
@DisplayName("OrdenServicioController — Pruebas Unitarias")
class OrdenServicioControllerTest {

    @Mock private OrdenServicioService ordenServicioService;
    @Mock private OrdenServicioPdfService ordenServicioPdfService;
    @InjectMocks private OrdenServicioController controller;

    private OrdenServicioDetalleResponse detalleResponse;
    private OrdenServicioResumenResponse resumenResponse;

    @BeforeEach
    void setUp() {
        detalleResponse = OrdenServicioDetalleResponse.builder()
                .id(1L)
                .sucursalId(1L)
                .proveedorId(1L)
                .nroOs("OS-00000001")
                .fecRegistro(LocalDate.now())
                .monedaId(1L)
                .flagEstado("1")
                .montoTotal(new BigDecimal("1000"))
                .lineas(Collections.emptyList())
                .build();

        resumenResponse = OrdenServicioResumenResponse.builder()
                .id(1L)
                .nroOs("OS-00000001")
                .flagEstado("1")
                .montoTotal(new BigDecimal("1000"))
                .build();
    }

    @Test
    @DisplayName("listar() retorna page data")
    void listar_retornaPageData() {
        var page = new PageImpl<>(List.of(resumenResponse));
        when(ordenServicioService.listar(any(), any(), any(), any(), any(),
                any(), any(), any(), any(), any(), any(), any(), any()))
                .thenReturn(page);

        ApiResponse<PageData<OrdenServicioResumenResponse>> result = controller.listar(
                null, null, null, null, null, null, null,
                null, null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("pendientesAprobacion() retorna page data")
    void pendientesAprobacion_retornaPageData() {
        var page = new PageImpl<>(List.of(resumenResponse));
        when(ordenServicioService.pendientesAprobacion(any())).thenReturn(page);

        var result = controller.pendientesAprobacion(Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("obtener() retorna detalle")
    void obtener_retornaDetalle() {
        when(ordenServicioService.obtener(1L)).thenReturn(detalleResponse);

        var result = controller.obtener(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("crear() retorna detalle")
    void crear_retornaDetalle() {
        when(ordenServicioService.crear(any(OrdenServicioCabeceraRequest.class))).thenReturn(detalleResponse);

        var result = controller.crear(new OrdenServicioCabeceraRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creada");
    }

    @Test
    @DisplayName("actualizar() retorna detalle")
    void actualizar_retornaDetalle() {
        when(ordenServicioService.actualizar(eq(1L), any(OrdenServicioCabeceraRequest.class)))
                .thenReturn(detalleResponse);

        var result = controller.actualizar(1L, new OrdenServicioCabeceraRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizada");
    }

    @Test
    @DisplayName("enviarAprobacion() retorna detalle")
    void enviarAprobacion_retornaDetalle() {
        when(ordenServicioService.enviarAprobacion(1L)).thenReturn(detalleResponse);

        var result = controller.enviarAprobacion(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("aprobación");
    }

    @Test
    @DisplayName("aprobar() con observacion -> retorna detalle")
    void aprobar_conObservacion_retornaDetalle() {
        when(ordenServicioService.aprobar(eq(1L), eq("OK"))).thenReturn(detalleResponse);

        OrdenServicioObservacionRequest body = new OrdenServicioObservacionRequest();
        body.setObservacion("OK");
        var result = controller.aprobar(1L, body);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("aprobada");
    }

    @Test
    @DisplayName("aprobar() sin body -> retorna detalle")
    void aprobar_sinBody_retornaDetalle() {
        when(ordenServicioService.aprobar(eq(1L), isNull())).thenReturn(detalleResponse);

        var result = controller.aprobar(1L, null);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    @DisplayName("rechazar() retorna detalle")
    void rechazar_retornaDetalle() {
        when(ordenServicioService.rechazar(eq(1L), eq("No cumple"))).thenReturn(detalleResponse);

        OrdenServicioMotivoRequest req = new OrdenServicioMotivoRequest();
        req.setMotivo("No cumple");
        var result = controller.rechazar(1L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("rechazada");
    }

    @Test
    @DisplayName("devolver() retorna detalle")
    void devolver_retornaDetalle() {
        when(ordenServicioService.devolver(eq(1L), eq("Revisar"))).thenReturn(detalleResponse);

        OrdenServicioMotivoRequest req = new OrdenServicioMotivoRequest();
        req.setMotivo("Revisar");
        var result = controller.devolver(1L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("generada");
    }

    @Test
    @DisplayName("anular() retorna detalle")
    void anular_retornaDetalle() {
        when(ordenServicioService.anular(eq(1L), eq("Por error"))).thenReturn(detalleResponse);

        OrdenServicioMotivoRequest req = new OrdenServicioMotivoRequest();
        req.setMotivo("Por error");
        var result = controller.anular(1L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("anulada");
    }

    @Test
    @DisplayName("cerrar() retorna detalle")
    void cerrar_retornaDetalle() {
        when(ordenServicioService.cerrar(1L)).thenReturn(detalleResponse);

        var result = controller.cerrar(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("cerrada");
    }

    @Test
    @DisplayName("registrarConformidad() retorna detalle")
    void registrarConformidad_retornaDetalle() {
        when(ordenServicioService.registrarConformidad(eq(1L), eq(100L), any()))
                .thenReturn(detalleResponse);

        var result = controller.registrarConformidad(1L, 100L, null);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("Conformidad registrada");
    }

    @Test
    @DisplayName("revertirConformidad() retorna detalle")
    void revertirConformidad_retornaDetalle() {
        when(ordenServicioService.revertirConformidad(eq(1L), eq(100L), any()))
                .thenReturn(detalleResponse);

        var result = controller.revertirConformidad(1L, 100L, null);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("revertida");
    }

    @Test
    @DisplayName("ajustarValor() retorna detalle")
    void ajustarValor_retornaDetalle() {
        when(ordenServicioService.ajustarValor(eq(1L), any(AjusteValorOsRequest.class)))
                .thenReturn(detalleResponse);

        var result = controller.ajustarValor(1L, new AjusteValorOsRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("ajustado");
    }

    @Test
    @DisplayName("historial() retorna lista")
    void historial_retornaLista() {
        HistorialAprobacionResponse h = HistorialAprobacionResponse.builder()
                .id(1L).accion("APROBADA").nivel(1).fecha(OffsetDateTime.now()).build();
        when(ordenServicioService.historial(1L)).thenReturn(List.of(h));

        var result = controller.historial(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
    }

    @Test
    @DisplayName("saldoPendiente() retorna respuesta")
    void saldoPendiente_retornaRespuesta() {
        OrdenServicioSaldoPendienteResponse sp = OrdenServicioSaldoPendienteResponse.builder()
                .ordenServicioId(1L).montoTotal(new BigDecimal("1000"))
                .lineas(Collections.emptyList()).build();
        when(ordenServicioService.saldoPendiente(1L)).thenReturn(sp);

        var result = controller.saldoPendiente(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getOrdenServicioId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("datosServicio() retorna respuesta")
    void datosServicio_retornaRespuesta() {
        DatosServicioResponse ds = DatosServicioResponse.builder()
                .servicioId(1L)
                .servicioCodigo("SRV001")
                .precioPactado(new BigDecimal("500"))
                .build();
        when(ordenServicioService.datosServicio(any(), any(), any(), any())).thenReturn(ds);

        var result = controller.datosServicio(1L, 1L, 1L, 1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getPrecioPactado()).isEqualByComparingTo("500");
    }

    @Test
    @DisplayName("enviarProveedor() retorna true")
    void enviarProveedor_retornaTrue() {
        when(ordenServicioService.enviarProveedor(eq(1L), any())).thenReturn(true);

        var result = controller.enviarProveedor(1L, null);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).isTrue();
    }

    @Test
    @DisplayName("pdf() retorna bytes")
    void pdf_retornaBytes() {
        byte[] pdfBytes = new byte[]{1, 2, 3, 4, 5};
        when(ordenServicioPdfService.generarPdf(1L)).thenReturn(pdfBytes);

        ResponseEntity<byte[]> result = controller.pdf(1L);

        assertThat(result.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(result.getBody()).hasSize(5);
        assertThat(result.getHeaders().getFirst("Content-Disposition")).contains("OS-1.pdf");
    }

    @Test
    @DisplayName("actaConformidadPdf() retorna bytes")
    void actaConformidadPdf_retornaBytes() {
        byte[] pdfBytes = new byte[]{10, 20, 30};
        when(ordenServicioPdfService.generarActaConformidadPdf(1L)).thenReturn(pdfBytes);

        ResponseEntity<byte[]> result = controller.actaConformidadPdf(1L);

        assertThat(result.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(result.getBody()).hasSize(3);
        assertThat(result.getHeaders().getFirst("Content-Disposition")).contains("ACTA-OS-1.pdf");
    }

    @Test
    @DisplayName("pendientesConformidad() retorna page data")
    void pendientesConformidad_retornaPageData() {
        LineaConformidadResponse lc = LineaConformidadResponse.builder()
                .ordenServicioId(1L).lineaId(100L).nroItem(1).build();
        var page = new PageImpl<>(List.of(lc));
        when(ordenServicioService.pendientesConformidad(any(), any(), any(), any(), any()))
                .thenReturn(page);

        var result = controller.pendientesConformidad("APROBACION", null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("asignarOc() retorna detalle")
    void asignarOc_retornaDetalle() {
        when(ordenServicioService.asignarOc(eq(1L), any(AsignacionOsOcRequest.class)))
                .thenReturn(detalleResponse);

        AsignacionOsOcRequest req = new AsignacionOsOcRequest();
        req.setOrdenCompraId(10L);
        AsignacionOsOcRequest.LineaAsignacion la = new AsignacionOsOcRequest.LineaAsignacion();
        la.setLineaOsId(100L);
        la.setLineaOcId(200L);
        la.setMonto(new BigDecimal("500"));
        req.setLineas(List.of(la));

        var result = controller.asignarOc(1L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("Asignación");
    }
}
