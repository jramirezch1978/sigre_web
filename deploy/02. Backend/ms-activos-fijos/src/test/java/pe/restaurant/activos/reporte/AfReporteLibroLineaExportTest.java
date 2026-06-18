package pe.restaurant.activos.reporte;

import org.junit.jupiter.api.Test;
import pe.restaurant.activos.dto.reporte.AfReporteLibroLineaResponse;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;

class AfReporteLibroLineaExportTest {

    @Test
    void valoresCelda_respetaOrdenHu() {
        AfReporteLibroLineaResponse l = new AfReporteLibroLineaResponse();
        l.setCodigo("AF-01");
        l.setNombre("Equipo");
        l.setClaseSubclase("MOB / M01 — Escritorio");
        l.setUbicacionFisica("S01 — Sede");
        l.setFechaAdquisicion(LocalDate.of(2025, 1, 15));
        l.setFechaInicioDepreciacion(LocalDate.of(2025, 2, 1));
        l.setValorAdquisicion(new BigDecimal("1000"));
        l.setDepreciacionAcumulada(new BigDecimal("100"));
        l.setValorNeto(new BigDecimal("900"));
        l.setMoneda("PEN");
        l.setEstadoActivo("ACTIVO");
        l.setCentroCosto("CC01 — Admin");

        assertThat(AfReporteLibroLineaExport.valoresCelda(l))
                .containsExactly(
                        "AF-01", "Equipo", "MOB / M01 — Escritorio", "S01 — Sede",
                        "15/01/2025", "01/02/2025", "1000", "100", "900", "PEN", "ACTIVO", "CC01 — Admin");
    }
}
