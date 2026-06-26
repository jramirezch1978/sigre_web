package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.dto.reporte.AfReporteLibroLineaResponse;
import pe.restaurant.activos.dto.reporte.AfReporteLibroResponse;
import pe.restaurant.activos.service.AfReporteService;
import pe.restaurant.common.exception.BusinessException;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AfReporteExportServiceImplTest {

    @Mock
    private AfReporteService reporteService;
    @InjectMocks
    private AfReporteExportServiceImpl service;

    private AfReporteLibroLineaResponse lineaCompleta() {
        AfReporteLibroLineaResponse l = new AfReporteLibroLineaResponse();
        l.setAfMaestroId(1L);
        l.setCodigo("AF-01");
        l.setNombre("Laptop Dell");
        l.setClaseSubclase("EQUIPOS / LAPTOPS");
        l.setUbicacionFisica("CC-CENTRAL / Sala 1");
        l.setFechaAdquisicion(LocalDate.of(2024, 3, 1));
        l.setFechaInicioDepreciacion(LocalDate.of(2024, 4, 1));
        l.setValorAdquisicion(new BigDecimal("12000.00"));
        l.setDepreciacionAcumulada(new BigDecimal("2400.00"));
        l.setValorNeto(new BigDecimal("9600.00"));
        l.setMoneda("PEN");
        l.setEstadoActivo("ACTIVO");
        l.setCentroCosto("CC01 — Administración");
        return l;
    }

    private AfReporteLibroResponse responseConLineas() {
        AfReporteLibroResponse data = new AfReporteLibroResponse();
        data.setFechaCorte(LocalDate.of(2026, 5, 31));
        data.setLineas(List.of(lineaCompleta()));
        data.setTotalValorAdquisicion(new BigDecimal("12000.00"));
        data.setTotalDepreciacionAcumulada(new BigDecimal("2400.00"));
        data.setTotalValorNeto(new BigDecimal("9600.00"));
        return data;
    }

    // ------------------------------------------------------------ exportCsv
    @Test
    void exportarCsv_generaBytes() {
        AfReporteLibroResponse data = new AfReporteLibroResponse();
        AfReporteLibroLineaResponse linea = new AfReporteLibroLineaResponse();
        linea.setCodigo("AF-01");
        linea.setNombre("Activo");
        linea.setValorAdquisicion(new BigDecimal("1000"));
        linea.setDepreciacionAcumulada(new BigDecimal("100"));
        linea.setValorNeto(new BigDecimal("900"));
        data.setLineas(List.of(linea));

        byte[] bytes = service.exportarLibroActivos(data, "csv");

        assertThat(bytes.length).isGreaterThan(10);
        String csv = new String(bytes, StandardCharsets.UTF_8);
        assertThat(csv).contains("AF-01");
        assertThat(csv).contains("digo de Activo");
        assertThat(csv).contains("Valor Neto Contable");
    }

    // ------------------------------------------------------------ exportExcel
    @Test
    void exportarExcel_generaBytes() {
        AfReporteLibroResponse data = new AfReporteLibroResponse();
        data.setLineas(List.of());

        byte[] bytes = service.exportarLibroActivos(data, "xlsx");

        assertThat(bytes.length).isGreaterThan(100);
        // XLSX -> ZIP magic PK
        assertThat(bytes[0]).isEqualTo((byte) 'P');
        assertThat(bytes[1]).isEqualTo((byte) 'K');
    }

    @Test
    void exportarExcel_conLineas_escribeNumericosYTotales() {
        byte[] bytes = service.exportarLibroActivos(responseConLineas(), "excel");

        assertThat(bytes.length).isGreaterThan(200);
        assertThat(bytes[0]).isEqualTo((byte) 'P');
        assertThat(bytes[1]).isEqualTo((byte) 'K');
    }

    @Test
    void exportarExcel_conTotalesNulosUsaCero() {
        AfReporteLibroResponse data = new AfReporteLibroResponse();
        data.setLineas(List.of(lineaCompleta()));
        // totales null -> toDouble debe devolver 0
        byte[] bytes = service.exportarLibroActivos(data, "xlsx");
        assertThat(bytes.length).isGreaterThan(100);
    }

    @Test
    void exportarExcel_lineaConValoresNumericosNoParseables_seEscribenComoTexto() {
        AfReporteLibroLineaResponse l = lineaCompleta();
        // Forzamos los importes a null para que el helper escriba "" como texto
        l.setValorAdquisicion(null);
        l.setDepreciacionAcumulada(null);
        l.setValorNeto(null);
        AfReporteLibroResponse data = new AfReporteLibroResponse();
        data.setLineas(List.of(l));

        byte[] bytes = service.exportarLibroActivos(data, "xlsx");
        assertThat(bytes.length).isGreaterThan(100);
    }

    // ------------------------------------------------------------ exportPdf
    @Test
    void exportarPdf_generaPdfValido() {
        byte[] bytes = service.exportarLibroActivos(responseConLineas(), "pdf");

        assertThat(bytes.length).isGreaterThan(100);
        // PDF magic %PDF
        String header = new String(bytes, 0, 4, StandardCharsets.US_ASCII);
        assertThat(header).isEqualTo("%PDF");
    }

    @Test
    void exportarPdf_conFechaCorteNula_noFalla() {
        AfReporteLibroResponse data = new AfReporteLibroResponse();
        data.setFechaCorte(null);
        AfReporteLibroLineaResponse linea = lineaCompleta();
        linea.setCodigo(null);
        linea.setNombre(null);
        data.setLineas(List.of(linea));

        byte[] bytes = service.exportarLibroActivos(data, "pdf");

        assertThat(bytes.length).isGreaterThan(100);
        String header = new String(bytes, 0, 4, StandardCharsets.US_ASCII);
        assertThat(header).isEqualTo("%PDF");
    }

    @Test
    void exportarPdf_sinLineas_generaPdfVacio() {
        AfReporteLibroResponse data = new AfReporteLibroResponse();
        data.setFechaCorte(LocalDate.of(2026, 1, 1));
        data.setLineas(List.of());

        byte[] bytes = service.exportarLibroActivos(data, "pdf");

        assertThat(bytes.length).isGreaterThan(100);
        String header = new String(bytes, 0, 4, StandardCharsets.US_ASCII);
        assertThat(header).isEqualTo("%PDF");
    }

    // ------------------------------------------------------------ formato
    @Test
    void exportarFormatoNulo_usaXlsxPorDefecto() {
        AfReporteLibroResponse data = new AfReporteLibroResponse();
        data.setLineas(List.of());

        byte[] bytes = service.exportarLibroActivos(data, null);

        assertThat(bytes[0]).isEqualTo((byte) 'P');
        assertThat(bytes[1]).isEqualTo((byte) 'K');
    }

    @Test
    void exportarFormatoInvalido_lanzaBusinessException() {
        AfReporteLibroResponse data = new AfReporteLibroResponse();
        data.setLineas(List.of());

        assertThatThrownBy(() -> service.exportarLibroActivos(data, "docx"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Formato no soportado");
    }

    // ------------------------------------------------------------ obtenerLibro
    @Test
    void obtenerLibro_delegaEnReporteService() {
        AfReporteLibroResponse expected = responseConLineas();
        LocalDate fechaCorte = LocalDate.of(2026, 5, 31);
        BigDecimal vMin = new BigDecimal("100");
        BigDecimal vMax = new BigDecimal("50000");

        when(reporteService.libroActivos(eq(fechaCorte), eq(1L), eq(2L), eq("A"), eq("ACTIVO"), eq(vMin), eq(vMax)))
                .thenReturn(expected);

        AfReporteLibroResponse result = service.obtenerLibro(fechaCorte, 1L, 2L, "A", "ACTIVO", vMin, vMax);

        assertThat(result).isSameAs(expected);
        verify(reporteService).libroActivos(any(), any(), any(), any(), any(), any(), any());
    }
}
