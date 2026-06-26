package pe.restaurant.activos.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import pe.restaurant.activos.dto.reporte.AfReporteDepreciacionAnualResponse;
import pe.restaurant.activos.dto.reporte.AfReporteLibroResponse;
import pe.restaurant.activos.service.AfReporteExportService;
import pe.restaurant.activos.service.AfReporteService;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AfReporteControllerTest {

    @Mock private AfReporteService reporteService;
    @Mock private AfReporteExportService reporteExportService;
    @InjectMocks private AfReporteController controller;

    @Test
    void libroActivos() {
        when(reporteService.libroActivos(null, null, null, null, null, null, null))
                .thenReturn(new AfReporteLibroResponse());
        assertThat(controller.libroActivos(null, null, null, null, null, null, null).isSuccess()).isTrue();
    }

    @Test
    void depreciacionAnual() {
        when(reporteService.depreciacionAnual(1L, 2026)).thenReturn(new AfReporteDepreciacionAnualResponse());
        assertThat(controller.depreciacionAnual(1L, 2026).isSuccess()).isTrue();
    }

    @Test
    void consolidado() {
        var fecha = LocalDate.of(2026, 3, 31);
        when(reporteService.consolidado(fecha, 7L)).thenReturn(new AfReporteLibroResponse());

        var resp = controller.consolidado(fecha, 7L);

        assertThat(resp.isSuccess()).isTrue();
        assertThat(resp.getData()).isNotNull();
    }

    @Test
    void exportarLibroActivosXlsxPorDefecto() {
        var data = new AfReporteLibroResponse();
        byte[] bytes = new byte[]{1, 2, 3};
        when(reporteExportService.obtenerLibro(any(), any(), any(), any(), any(), any(), any())).thenReturn(data);
        when(reporteExportService.exportarLibroActivos(eq(data), eq("xlsx"))).thenReturn(bytes);

        var resp = controller.exportarLibroActivos(
                "xlsx", LocalDate.of(2026, 5, 1), 1L, 2L, "1", "OPERATIVO",
                new BigDecimal("100"), new BigDecimal("999"));

        assertThat(resp.getStatusCode().is2xxSuccessful()).isTrue();
        assertThat(resp.getBody()).isEqualTo(bytes);
        assertThat(resp.getHeaders().getFirst(HttpHeaders.CONTENT_DISPOSITION))
                .contains("libro-activos.xlsx");
        assertThat(resp.getHeaders().getContentType()).isEqualTo(
                MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
    }

    @Test
    void exportarLibroActivosCsv() {
        var data = new AfReporteLibroResponse();
        byte[] bytes = "a,b,c".getBytes();
        when(reporteExportService.obtenerLibro(any(), any(), any(), any(), any(), any(), any())).thenReturn(data);
        when(reporteExportService.exportarLibroActivos(eq(data), eq("csv"))).thenReturn(bytes);

        var resp = controller.exportarLibroActivos(
                "csv", null, null, null, null, null, null, null);

        assertThat(resp.getBody()).isEqualTo(bytes);
        assertThat(resp.getHeaders().getFirst(HttpHeaders.CONTENT_DISPOSITION))
                .contains("libro-activos.csv");
        assertThat(resp.getHeaders().getContentType()).isEqualTo(MediaType.parseMediaType("text/csv"));
    }

    @Test
    void exportarLibroActivosPdf() {
        var data = new AfReporteLibroResponse();
        byte[] bytes = new byte[]{37, 80, 68, 70}; // %PDF
        when(reporteExportService.obtenerLibro(any(), any(), any(), any(), any(), any(), any())).thenReturn(data);
        when(reporteExportService.exportarLibroActivos(eq(data), eq("pdf"))).thenReturn(bytes);

        var resp = controller.exportarLibroActivos(
                "pdf", null, null, null, null, null, null, null);

        assertThat(resp.getBody()).isEqualTo(bytes);
        assertThat(resp.getHeaders().getFirst(HttpHeaders.CONTENT_DISPOSITION))
                .contains("libro-activos.pdf");
        assertThat(resp.getHeaders().getContentType()).isEqualTo(MediaType.APPLICATION_PDF);
    }

    @Test
    void exportarLibroActivosFormatoDesconocidoCaeXlsx() {
        var data = new AfReporteLibroResponse();
        byte[] bytes = new byte[]{9, 9};
        when(reporteExportService.obtenerLibro(any(), any(), any(), any(), any(), any(), any())).thenReturn(data);
        when(reporteExportService.exportarLibroActivos(eq(data), eq("zip"))).thenReturn(bytes);

        var resp = controller.exportarLibroActivos(
                "zip", null, null, null, null, null, null, null);

        assertThat(resp.getHeaders().getFirst(HttpHeaders.CONTENT_DISPOSITION))
                .contains("libro-activos.xlsx");
        assertThat(resp.getHeaders().getContentType()).isEqualTo(
                MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
    }
}
