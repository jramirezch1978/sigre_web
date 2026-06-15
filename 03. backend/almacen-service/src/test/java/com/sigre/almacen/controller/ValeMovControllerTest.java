package com.sigre.almacen.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockMultipartFile;
import com.sigre.almacen.dto.*;
import com.sigre.almacen.service.ValeMovService;
import com.sigre.common.dto.ApiResponse;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ValeMovControllerTest {

    @Mock
    private ValeMovService valeMovService;

    @InjectMocks
    private ValeMovController controller;

    private MovimientoDetalleResponse detalleResponse;

    @BeforeEach
    void setUp() {
        detalleResponse = MovimientoDetalleResponse.builder()
                .id(1L)
                .sucursalId(10L)
                .almacenId(20L)
                .articuloMovTipoId(30L)
                .nroVale("VALE-00000001")
                .fechaMov(LocalDate.of(2026, 4, 17))
                .flagEstado("1")
                .lineas(List.of())
                .build();
    }

    // ────────────────────────────────────────────────────────────────────
    // Crear / Actualizar / Confirmar / Anular (cabecera CRUD)
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("POST /")
    class CrearTests {

        @Test
        @DisplayName("crea un movimiento y retorna detalle con mensaje")
        void crear_ok() {
            MovimientoCabeceraRequest request = new MovimientoCabeceraRequest();
            request.setSucursalId(10L);
            request.setAlmacenId(20L);
            request.setArticuloMovTipoId(30L);
            request.setFechaMov(LocalDate.of(2026, 4, 17));

            when(valeMovService.crear(any(MovimientoCabeceraRequest.class))).thenReturn(detalleResponse);

            ApiResponse<MovimientoDetalleResponse> result = controller.crear(request);

            assertThat(result.isSuccess()).isTrue();
            assertThat(result.getData().getId()).isEqualTo(1L);
            assertThat(result.getData().getNroVale()).isEqualTo("VALE-00000001");
            assertThat(result.getMessage()).isEqualTo("Movimiento registrado");
            verify(valeMovService).crear(request);
        }
    }

    @Nested
    @DisplayName("PUT /{id}")
    class ActualizarTests {

        @Test
        @DisplayName("actualiza un movimiento y retorna detalle con mensaje")
        void actualizar_ok() {
            MovimientoCabeceraRequest request = new MovimientoCabeceraRequest();
            request.setSucursalId(10L);
            request.setAlmacenId(20L);
            request.setArticuloMovTipoId(30L);
            request.setFechaMov(LocalDate.of(2026, 4, 17));

            when(valeMovService.actualizar(eq(1L), any(MovimientoCabeceraRequest.class)))
                    .thenReturn(detalleResponse);

            ApiResponse<MovimientoDetalleResponse> result = controller.actualizar(1L, request);

            assertThat(result.isSuccess()).isTrue();
            assertThat(result.getData().getId()).isEqualTo(1L);
            assertThat(result.getMessage()).isEqualTo("Movimiento actualizado");
            verify(valeMovService).actualizar(1L, request);
        }
    }

    @Nested
    @DisplayName("POST /confirmar")
    class ConfirmarTests {

        @Test
        @DisplayName("confirma un movimiento y retorna detalle con mensaje")
        void confirmar_ok() {
            MovimientoConfirmarRequest request = new MovimientoConfirmarRequest();
            request.setId(1L);
            request.setObservacion("Confirmado OK");

            when(valeMovService.confirmar(any(MovimientoConfirmarRequest.class)))
                    .thenReturn(detalleResponse);

            ApiResponse<MovimientoDetalleResponse> result = controller.confirmar(request);

            assertThat(result.isSuccess()).isTrue();
            assertThat(result.getData().getId()).isEqualTo(1L);
            assertThat(result.getMessage()).isEqualTo("Movimiento procesado");
            verify(valeMovService).confirmar(request);
        }
    }

    @Nested
    @DisplayName("POST /anular")
    class AnularTests {

        @Test
        @DisplayName("anula un movimiento y retorna detalle con mensaje")
        void anular_ok() {
            MovimientoAnularRequest request = new MovimientoAnularRequest();
            request.setId(1L);
            request.setMotivo("Anulado por error de captura");

            when(valeMovService.anular(any(MovimientoAnularRequest.class)))
                    .thenReturn(detalleResponse);

            ApiResponse<MovimientoDetalleResponse> result = controller.anular(request);

            assertThat(result.isSuccess()).isTrue();
            assertThat(result.getData().getId()).isEqualTo(1L);
            assertThat(result.getMessage()).isEqualTo("Movimiento anulado");
            verify(valeMovService).anular(request);
        }
    }

    @Nested
    @DisplayName("GET /{id}")
    class ObtenerTests {

        @Test
        @DisplayName("expone valeMovOrigId y flagEstado en la respuesta JSON")
        void obtener_incluyeCamposCabecera() {
            MovimientoDetalleResponse rich = MovimientoDetalleResponse.builder()
                    .id(88L)
                    .valeMovOrigId(70L)
                    .flagEstado("1")
                    .nroVale("VALE-88")
                    .fechaMov(LocalDate.of(2026, 5, 2))
                    .lineas(List.of())
                    .build();
            when(valeMovService.obtener(88L)).thenReturn(rich);

            ApiResponse<MovimientoDetalleResponse> result = controller.obtener(88L);

            assertThat(result.getData().getValeMovOrigId()).isEqualTo(70L);
            assertThat(result.getData().getFlagEstado()).isEqualTo("1");
            verify(valeMovService).obtener(88L);
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Devolvible
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("GET /devolvible/{id}")
    class DevolvibleTests {

        @Test
        @DisplayName("retorna las líneas devolvibles del movimiento")
        void devolvible_ok() {
            DevolvibleResponse devResp = DevolvibleResponse.builder()
                    .valeMovId(1L)
                    .nroVale("VALE-00000001")
                    .almacenId(20L)
                    .articuloMovTipoId(30L)
                    .fechaMov(LocalDate.of(2026, 4, 17))
                    .tipoMovDevolucion("S04")
                    .lineas(List.of(
                            DevolvibleLineaResponse.builder()
                                    .articuloId(100L)
                                    .cantOriginal(new BigDecimal("50.0000"))
                                    .cantYaDevuelta(BigDecimal.ZERO)
                                    .cantDevolvible(new BigDecimal("50.0000"))
                                    .costoUnitario(new BigDecimal("10.000000"))
                                    .build()
                    ))
                    .build();

            when(valeMovService.obtenerDevolvible(1L)).thenReturn(devResp);

            ApiResponse<DevolvibleResponse> result = controller.devolvible(1L);

            assertThat(result.isSuccess()).isTrue();
            assertThat(result.getData().getValeMovId()).isEqualTo(1L);
            assertThat(result.getData().getTipoMovDevolucion()).isEqualTo("S04");
            assertThat(result.getData().getLineas()).hasSize(1);
            assertThat(result.getData().getLineas().get(0).getCantDevolvible())
                    .isEqualByComparingTo("50.0000");
            verify(valeMovService).obtenerDevolvible(1L);
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Devolución
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("POST /devolucion")
    class DevolucionTests {

        @Test
        @DisplayName("crea una devolución y retorna detalle")
        void crearDevolucion_ok() {
            DevolucionRequest request = new DevolucionRequest();
            request.setValeMovOrigenId(1L);
            request.setSucursalId(10L);
            request.setFechaMov(LocalDate.of(2026, 4, 17));
            request.setObservaciones("Devolución parcial");

            DevolucionLineaRequest linea = new DevolucionLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantDevolver(new BigDecimal("20"));
            request.setLineas(List.of(linea));

            MovimientoDetalleResponse devDetalle = MovimientoDetalleResponse.builder()
                    .id(2L)
                    .sucursalId(10L)
                    .almacenId(20L)
                    .articuloMovTipoId(31L)
                    .nroVale("VALE-00000002")
                    .fechaMov(LocalDate.of(2026, 4, 17))
                    .flagEstado("1")
                    .lineas(List.of())
                    .build();

            when(valeMovService.crearDevolucion(any(DevolucionRequest.class))).thenReturn(devDetalle);

            ApiResponse<MovimientoDetalleResponse> result = controller.devolucion(request);

            assertThat(result.isSuccess()).isTrue();
            assertThat(result.getData().getId()).isEqualTo(2L);
            assertThat(result.getMessage()).isEqualTo("Devolución registrada");
            verify(valeMovService).crearDevolucion(request);
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Exportar Excel
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("GET /exportar")
    class ExportarExcelTests {

        @Test
        @DisplayName("retorna un archivo XLSX con content-disposition attachment")
        void exportarExcel_ok() {
            byte[] fakeExcel = new byte[]{0x50, 0x4B, 0x03, 0x04};
            when(valeMovService.exportarExcel(isNull(), isNull(), isNull(), isNull(), isNull(), isNull()))
                    .thenReturn(fakeExcel);

            ResponseEntity<byte[]> response = controller.exportarExcel(null, null, null, null, null, null);

            assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
            assertThat(response.getHeaders().getFirst("Content-Disposition"))
                    .contains("movimientos.xlsx");
            assertThat(response.getBody()).isEqualTo(fakeExcel);
            verify(valeMovService).exportarExcel(isNull(), isNull(), isNull(), isNull(), isNull(), isNull());
        }

        @Test
        @DisplayName("pasa filtros correctamente al servicio")
        void exportarExcel_conFiltros() {
            byte[] fakeExcel = new byte[]{1, 2, 3};
            LocalDate desde = LocalDate.of(2026, 1, 1);
            LocalDate hasta = LocalDate.of(2026, 4, 17);

            when(valeMovService.exportarExcel(eq(10L), eq(20L), eq(30L), eq("1"), eq(desde), eq(hasta)))
                    .thenReturn(fakeExcel);

            ResponseEntity<byte[]> response = controller.exportarExcel(10L, 20L, 30L, "1", desde, hasta);

            assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
            assertThat(response.getBody()).hasSize(3);
            verify(valeMovService).exportarExcel(10L, 20L, 30L, "1", desde, hasta);
        }

        @Test
        @DisplayName("POST /exportar delega igual que GET")
        void exportarExcel_postDelegaEnMismaLogica() {
            byte[] fakeExcel = new byte[]{0x50, 0x4B};
            when(valeMovService.exportarExcel(eq(1L), isNull(), isNull(), isNull(), isNull(), isNull()))
                    .thenReturn(fakeExcel);

            ResponseEntity<byte[]> response = controller.exportarExcelPost(1L, null, null, null, null, null);

            assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
            assertThat(response.getBody()).isEqualTo(fakeExcel);
            verify(valeMovService).exportarExcel(1L, null, null, null, null, null);
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Importar Excel
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("POST /importar")
    class ImportarExcelTests {

        @Test
        @DisplayName("importa archivo y retorna resumen")
        void importarExcel_ok() {
            MockMultipartFile file = new MockMultipartFile(
                    "file", "movimientos.xlsx",
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    new byte[]{1, 2, 3}
            );

            ImportResultResponse importResp = ImportResultResponse.builder()
                    .totalLeidas(10)
                    .totalImportadas(8)
                    .totalErrores(2)
                    .errores(List.of("Fila 3: artículo inactivo", "Fila 7: stock insuficiente"))
                    .build();

            when(valeMovService.importarExcel(any(), eq(10L))).thenReturn(importResp);

            ApiResponse<ImportResultResponse> result = controller.importarExcel(file, 10L);

            assertThat(result.isSuccess()).isTrue();
            assertThat(result.getData().getTotalLeidas()).isEqualTo(10);
            assertThat(result.getData().getTotalImportadas()).isEqualTo(8);
            assertThat(result.getData().getTotalErrores()).isEqualTo(2);
            assertThat(result.getData().getErrores()).hasSize(2);
            assertThat(result.getMessage()).isEqualTo("Importación completada");
            verify(valeMovService).importarExcel(any(), eq(10L));
        }

        @Test
        @DisplayName("importa archivo sin errores")
        void importarExcel_sinErrores() {
            MockMultipartFile file = new MockMultipartFile(
                    "file", "ok.xlsx",
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    new byte[]{1}
            );

            ImportResultResponse importResp = ImportResultResponse.builder()
                    .totalLeidas(5)
                    .totalImportadas(5)
                    .totalErrores(0)
                    .errores(List.of())
                    .build();

            when(valeMovService.importarExcel(any(), eq(1L))).thenReturn(importResp);

            ApiResponse<ImportResultResponse> result = controller.importarExcel(file, 1L);

            assertThat(result.getData().getTotalErrores()).isZero();
            assertThat(result.getData().getErrores()).isEmpty();
        }

        @Test
        @DisplayName("importar con sucursalId nulo delega en el servicio")
        void importarExcel_sucursalIdOpcional() {
            MockMultipartFile file = new MockMultipartFile(
                    "file", "x.xlsx",
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    new byte[]{1}
            );
            ImportResultResponse importResp = ImportResultResponse.builder()
                    .totalLeidas(1)
                    .totalImportadas(1)
                    .totalErrores(0)
                    .errores(List.of())
                    .build();
            when(valeMovService.importarExcel(any(), isNull())).thenReturn(importResp);

            ApiResponse<ImportResultResponse> result = controller.importarExcel(file, null);

            assertThat(result.getData().getTotalImportadas()).isEqualTo(1);
            verify(valeMovService).importarExcel(any(), isNull());
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // PDF
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("GET /pdf/{id}")
    class PdfTests {

        @Test
        @DisplayName("retorna PDF con content-type application/pdf")
        void generarPdf_ok() {
            byte[] fakePdf = "%PDF-1.4 fake".getBytes();
            when(valeMovService.generarPdf(1L)).thenReturn(fakePdf);

            ResponseEntity<byte[]> response = controller.pdf(1L);

            assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
            assertThat(response.getHeaders().getContentType().toString())
                    .isEqualTo("application/pdf");
            assertThat(response.getHeaders().getFirst("Content-Disposition"))
                    .contains("vale_1.pdf");
            assertThat(response.getBody()).isEqualTo(fakePdf);
            verify(valeMovService).generarPdf(1L);
        }

        @Test
        @DisplayName("pasa el id correcto al servicio")
        void generarPdf_idCorrecto() {
            when(valeMovService.generarPdf(99L)).thenReturn(new byte[]{});

            controller.pdf(99L);

            verify(valeMovService).generarPdf(99L);
            verify(valeMovService, never()).generarPdf(argThat(id -> id != 99L));
        }

        @Test
        @DisplayName("POST /{id}/pdf delega en generarPdf igual que GET")
        void pdfPost_delegaIgualQueGet() {
            byte[] fakePdf = "%PDF".getBytes();
            when(valeMovService.generarPdf(5L)).thenReturn(fakePdf);

            ResponseEntity<byte[]> response = controller.pdfPost(5L);

            assertThat(response.getBody()).isEqualTo(fakePdf);
            verify(valeMovService).generarPdf(5L);
        }
    }
}
